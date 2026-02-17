# Cilium Ingress Analysis & Debugging Guide

Use this guide to verify the health of your Cilium NodePort setup.

## 1. External Connectivity

**Explanation**: Checks if traffic can reach the cluster from your host machine.
**Command**:

```bash
curl -v http://localhost:8080/web/
```

**Expectation**:

- **Success**: `HTTP/1.1 200 OK` or `404 Not Found` (Application reached).
- **Partial Success**: `Empty Reply from Server` (Network path open, App closed connection).
- **Failure**: `Connection Refused` (Nothing listening on port 8080/30080).

---

## 2. Service Layer

**Explanation**: Verifies the Kubernetes Service is correctly configured to receive traffic on the NodePort.
**Command**:

```bash
kubectl get svc -n kube-system cilium-ingress
```

**Expectation**:

- `TYPE`: `NodePort`
- `PORT(S)`: `80:30080/TCP`

---

## 3. Configuration (The "Socket" Fix)

**Explanation**: Checks if Envoy is explicitly enabled in the Cilium Config. This is critical for K3d/Kind (non-hostNetwork) setups to ensure `cilium-agent` creates the necessary sockets.
**Command**:

```bash
kubectl get cm -n kube-system cilium-config -o yaml | grep -A 1 "envoy:"
```

**Expectation**:

- Output should contain `enabled: true`.
- **If missing**: You will see "Socket Option not found" errors in Envoy logs.

---

## 4. Envoy Process Status

**Explanation**: Checks if the Envoy Pod is running and reachable.
**Command**:

```bash
kubectl get pods -n kube-system -l k8s-app=cilium-envoy -o wide
```

**Expectation**:

- `STATUS`: `Running`
- `READY`: `1/1`

---

## 5. Envoy Logs & Sockets

**Explanation**: Scans logs for BPF/Socket errors, which indicate a communication breakdown between Agent and Envoy.
**Command**:

```bash
# Check Logs
kubectl logs -n kube-system ds/cilium-envoy --tail=20 | grep -i "socket"

# Verify Socket Directory (Advanced)
# Note: We must target a specific POD, not the DaemonSet.
kubectl debug -n kube-system $(kubectl get pod -n kube-system -l k8s-app=cilium-envoy -o name | head -n 1) -it --image=busybox --target=cilium-envoy -- ls -l /var/run/cilium/envoy/sockets
```

**Expectation**:

- **Logs**: Should NOT show `Cilium Socket Option not found`.
- **Sockets**: Directory should exist and contain socket files (e.g., `admin.sock`).

---

## 6. Envoy Listeners (Self-Diagnostics)

**Explanation**: Asks Envoy directly what ports it is listening on.
**Command**:

```bash
# Launch a temporary debug pod attached to the first Envoy pod
kubectl debug -n kube-system $(kubectl get pod -n kube-system -l k8s-app=cilium-envoy -o name | head -n 1) -it --image=curlimages/curl --target=cilium-envoy -- curl -s http://127.0.0.1:17357/listeners
```

**Expectation**:

- Output should be a JSON list including `"socket_address": { "address": "0.0.0.0", "port_value": 80 }`.
- **Failure**: `Connection Refused` (Envoy Admin interface dead) or Empty JSON (Control Plane failure).
