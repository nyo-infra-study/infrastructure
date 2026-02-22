# Cilium on k3d (Colima): Troubleshooting & Architecture Guide

This document summarizes the specific networking complexities, symptoms, and fixes discovered when replacing the standard k3d networking stack (Traefik, kube-proxy, Flannel) with pure **Cilium** (eBPF) in a local Docker-in-Docker environment powered by **Colima**.

## 1. The Bootstrap Deadlock

**The Goal:** Install Cilium natively so it provides the CNI, Ingress, and kube-proxy replacements, then use ArgoCD to manage the cluster.

**The Symptom:**
If you simply add Cilium as an ArgoCD Application in a completely fresh, CNI-less cluster (`--flannel-backend=none`), the ArgoCD pods themselves will stick in `Pending` or `ContainerCreating` states. ArgoCD cannot start without a CNI, and the CNI cannot be installed if ArgoCD isn't running.

**The Fix (Scripting):**
We broke the cycle in `run.sh` by deploying Cilium imperatively via Helm _before_ installing ArgoCD.

- **Dynamic API Server:** Because kube-proxy is disabled, Cilium needs the hard IP of the Kubernetes API server for eBPF routing. k3d assigns a random Docker bridge IP to the API container on every run.
- **Solution:** We query `kubectl get endpoints kubernetes` in `run.sh` and pass `--set k8sServiceHost=$IP` to the Cilium Helm chart. Once Cilium is up (`cilium status --wait`), ArgoCD can be installed safely.

## 2. Ingress host-routing issues (k3d/Docker)

**The Symptom:**
After deploying an application and exposing it via the Cilium Ingress controller on `localhost:9000`, browser requests return a **`503 Service Unavailable`**.
Looking at the Cilium Envoy Proxy logs (`kubectl logs -l name=cilium-envoy -n kube-system`), we see connection timeouts when Envoy tries to reach the backend pods' `ClusterIP`.

**The Investigation:**
Because k3d runs Kubernetes nodes inside standard Docker containers, the networking stack behaves differently than a raw Linux host. By default, Cilium Ingress runs in `shared` mode, meaning the Envoy proxy daemon runs directly on the root network namespace of the k3d node (`hostNetwork: true`) alongside the `cilium-agent`.

The connection timeout happens because of a recognized eBPF datapath bug/limitation in Cilium: when an Envoy proxy (running with `hostNetwork: true`) and a destination pod reside on the **same Kubernetes node**—which is _always_ true in a single-node k3d cluster—and `HostRouting` is utilizing BPF, the eBPF programs silently drop the packets routed from Envoy to the Pod IP, resulting in an upstream timeout (`503 Service Unavailable`).

**The Fix (Helm Values):**
Since `dedicated` mode (which puts Envoy in the pod network) creates severe port 80 conflicts across multiple Ingress objects when using k3d's built-in servicelb, the solution is to remain in `shared` mode but instruct Cilium to bypass eBPF-based host routing in favor of legacy network stack routing:

```yaml
bpf:
  hostLegacyRouting: true

ingressController:
  enabled: true
  loadbalancerMode: shared
  default: true
```

By enabling `bpf.hostLegacyRouting: true`, traffic originating from Envoy simply travels through standard Linux veth routing to reach the co-located backend pods on the same node, bypassing the eBPF drop bug completely.

## 3. The Colima UDP/DNS Masquerading Bug

**The Symptom:**
Even with Ingress working, applications fail to sync. ArgoCD throws `ComparisonError` attempting to pull from GitHub. CoreDNS logs (`kubectl logs -n kube-system deploy/coredns`) are filled with:
`i/o timeout: read udp 10.42.0.88 -> 192.168.5.2:53`

**The Investigation (Terminal Triage):**

1.  **Is Egress completely broken?**
    We launched a debug pod: `kubectl run test --rm -it --image=alpine -- ping -c 3 8.8.8.8`.
    _Result:_ Success. Cilium was masquerading standard IPv4 internet traffic correctly.
2.  **What is `192.168.5.2`?**
    We checked the k3d node's resolver: `docker exec k3d-dev-server-0 cat /etc/resolv.conf`.
    _Result:_ `nameserver 192.168.5.2`. This is a transparent DNS proxy injected by Colima into the Docker VM.
3.  **Is the DNS proxy reachable?**
    We pinged it from the node: `docker exec k3d-dev-server-0 ping 192.168.5.2`.
    _Result:_ Success.
4.  **Is UDP 53 working?**
    We tested DNS resolution inside a pod targeting public DNS: `nslookup github.com 8.8.8.8`.
    _Result:_ Success.
    We tested against Colima's proxy: `nslookup github.com 192.168.5.2`.
    _Result:_ Timeout.

**The Conclusion:**
Colima's internal DNS proxy silently drops or misroutes UDP packets that have been Source-NAT'd (masqueraded) by Cilium eBPF rules from the pod CIDR subnet.

**The Fix (Scripting/Manifests):**
Instead of relying on the host's broken proxy, we bypassed it entirely. We updated `run.sh` to hot-patch the CoreDNS ConfigMap right after cluster creation, instructing it to forward all external `.` queries to `8.8.8.8` instead of `/etc/resolv.conf`.

```bash
kubectl get cm coredns -n kube-system -o yaml | \
  sed 's/forward . \/etc\/resolv.conf/forward . 8.8.8.8/' | \
  kubectl apply -f -
kubectl rollout restart deployment coredns -n kube-system
```

This restores reliable cluster-wide internet DNS resolution required by ArgoCD without breaking the internal cluster mesh.

## 4. localhost:9000 Timeout — svclb netns Isolation

**The Symptom:**
After a fresh `run.sh`, `curl http://localhost:9000/argocd` times out immediately. The TCP connection is accepted (port 9000 on Mac is bound by Docker) but hangs with no response. From inside the cluster, hitting the `cilium-ingress` ClusterIP works and returns `404 from envoy` — so Envoy itself is healthy.

**The Investigation:**

1. **k3d port mapping is correct.** `docker ps` shows `0.0.0.0:9000->80/tcp` on `k3d-dev-serverlb`. Inside that container, nginx proxies `port 80 → k3d-dev-server-0:80`.

2. **Nothing listens on port 80 of the server node.**

   ```bash
   docker exec k3d-dev-serverlb sh -c \
     "(echo > /dev/tcp/172.18.0.3/80) 2>&1 && echo open || echo closed"
   # Result: closed/refused
   ```

3. **Why? Cilium eBPF NodePort ≠ a socket.**
   Cilium replaces kube-proxy via eBPF programs attached to the node's network interfaces at XDP/tc-bpf level. It does **not** open a real TCP socket on the port. You can confirm this:

   ```bash
   kubectl exec -n kube-system cilium-<pod> -- cilium bpf lb list | grep ':80'
   # Shows:   0.0.0.0:80 [HostPort, non-routable]
   ```

   The `non-routable` label and the absence of a real socket mean that Docker bridge traffic from k3d nginx to `server-node:80` finds nothing to connect to — Cilium's XDP hook is simply not triggered for this traffic path.

4. **Why doesn't svclb fix it?**
   The `svclb-cilium-ingress` pod (klipper-lb) sets up iptables DNAT rules to redirect port 80 → ClusterIP. But these rules live inside the **svclb container's own network namespace**, not the node's host network namespace. Traffic from k3d nginx arrives at the k3d server node's host netns, where those DNAT rules don't exist.

   ```bash
   kubectl get pod svclb-cilium-ingress-... -o jsonpath='{.spec.hostNetwork}'
   # Returns empty = false → isolated netns → DNAT rules are invisible to nginx
   ```

5. **Why does it work inside the cluster?**
   Pod-to-ClusterIP traffic flows through cilium's eBPF programs that _are_ attached to the virtual ethernet interfaces (veth pairs) in the pod's netns. That path works even with the svclb isolated. External access (k3d nginx bridging to node) bypasses that path entirely.

**The Fix:**

Change the k3d cluster creation to map port 9000 directly onto the **server node** (`@server:0`) with a **fixed NodePort** that Cilium's eBPF will honor on the node interface, rather than relying on k3d's nginx LB (`@loadbalancer`) to proxy to port 80 which has no socket listener.

Set a fixed NodePort in the Cilium Helm values:

```yaml
# platform/cilium/values.yaml
ingressController:
  service:
    insecureNodePort: 30080 # fixed HTTP NodePort
    secureNodePort: 30443 # fixed HTTPS NodePort
```

Change the k3d cluster creation port mapping in `run.sh`:

```bash
# Before (broken — nginx proxies to server-node:80 which has no listener):
--port '9000:80@loadbalancer'

# After (correct — Docker maps directly to the server node's NodePort):
--port '9000:30080@server:0'
```

With `@server:0`, Docker itself performs the host port binding (`0.0.0.0:9000 → server-container:30080`), so traffic arrives at the server node's **eth0** interface on port 30080. Cilium's tc-bpf hook on `eth0` intercepts it as a NodePort packet and routes it to Envoy correctly.
