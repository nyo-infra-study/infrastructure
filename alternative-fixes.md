# Alternative Fixes for Cilium Ingress

This document collects potential fixes and alternative configurations discovered during the top-to-bottom analysis of the Cilium Ingress setup.

> **Note**: These fixes are intended to be applied manually by the user.

## Issue: 500 Internal Server Error (Envoy)

**Symptoms:**

- `curl -v http://localhost:8080` returns `500 Internal Server Error`.
- `cilium-envoy` logs show:
  ```
  [warning][filter] [cilium/network_filter.cc:88] ... cilium.network: Cilium Socket Option not found
  [warning][config] [cilium/bpf_metadata.cc:326] cilium.bpf_metadata (east/west L7 LB): Non-local pod can not use original source address
  ```

**Root Cause:**
In k3d/Docker environments, traffic entering via the load balancer (NodePort) often loses the metadata required for Cilium's BPF-based transparent proxying/listener lookups. Envoy rejects the connection because the `cilium.network` filter cannot verify the source identity.

## Fix 1: Enable Host Network for Ingress Controller

By running the Ingress Controller (Envoy) on the host network, we bypass the complex BPF socket lookup requirements for ingress traffic and allow it to bind directly to the node's interface.

**Changes to `platform/cilium/values.yaml`:**

```yaml
ingressController:
  enabled: true
  loadbalancerMode: shared
  hostNetwork:
    enabled: true
    sharedListenerPort: 30080 # Must match k3d port mapping (8080:30080)
```

_Apply with:_

```bash
helm upgrade cilium oci://quay.io/cilium/charts/cilium --version 1.19.0 \
  --namespace kube-system \
  -f platform/cilium/values.yaml
kubectl -n kube-system rollout restart deployment/cilium-envoy
```

## Fix 2: Switch to "dedicated" LoadBalancer Mode

If Fix 1 doesn't work, switching to `dedicated` mode creates a separate LoadBalancer service for the Ingress, which might handle traffic differently. However, in k3d without a LoadBalancer provider (we disabled `servicelb`), this is more complex to set up.

## Verification

After applying Fix 1:

1. Verify `cilium-envoy` pod is restarted.
2. Run `curl -v http://localhost:8080`. It should return 404 (Not Found) or the ArgoCD login page, NOT 500.
