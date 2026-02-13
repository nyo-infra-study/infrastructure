# Platform Infrastructure

This directory contains platform-level infrastructure and tooling that is **shared across all environments** (dev, staging, production).

## Contents

- **argocd/** - ArgoCD GitOps platform configuration
  - `values.yaml` - Helm values for ArgoCD server configuration

## Why Platform?

Platform resources differ from application resources because they:

- Are environment-agnostic (same config for dev/staging/prod)
- Provide foundational services (GitOps, monitoring, logging, etc.)
- Are installed once and manage application deployments
- Are managed separately from application code

---

## ArgoCD Setup

### Initial Installation

Install ArgoCD using Helm with custom values:

```bash
# Add ArgoCD Helm repository
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update

# Install ArgoCD in argocd namespace
helm install argocd argo/argo-cd \
  -n argocd \
  --create-namespace \
  -f platform/argocd/values.yaml
```

### Upgrading ArgoCD

To update ArgoCD configuration or upgrade to a new version:

```bash
# Update Helm repository
helm repo update

# Upgrade ArgoCD with latest values
helm upgrade argocd argo/argo-cd \
  -n argocd \
  -f platform/argocd/values.yaml
```

### Accessing ArgoCD

**Via Ingress (Recommended):**

- URL: http://localhost:8080/argocd
- Requires k3d cluster with port mapping: `--port "8080:80@loadbalancer"`

**Via Port Forward (Fallback):**

```bash
kubectl port-forward svc/argocd-server -n argocd 9090:443
# Access: https://localhost:9090
```

**Default Credentials:**

- Username: `admin`
- Password: Get from secret
  ```bash
  kubectl get secret argocd-initial-admin-secret -n argocd \
    -o jsonpath="{.data.password}" | base64 -d
  ```

### What's Configured

The `values.yaml` file configures:

1. **HTTP Mode** (`server.insecure: true`)
   - Disables TLS requirement for local development
   - Production should use TLS certificates

2. **Root Path** (`--rootpath=/argocd`)
   - Makes ArgoCD work behind a reverse proxy at `/argocd` path
   - Without this, ArgoCD generates broken URLs

3. **Ingress** (via Traefik)
   - Enables external access without port-forwarding
   - Routes `http://localhost:8080/argocd` → ArgoCD UI
   - Uses k3d's default Traefik ingress controller

---

## Future Platform Services

Additional platform services to consider:

- **Prometheus/Grafana** - Metrics and monitoring
- **Loki/Promtail** - Centralized logging
- **Cert-Manager** - Automatic TLS certificate management
- **External Secrets Operator** - Secrets management
- **Sealed Secrets** - Encrypted secrets in Git

Each would get its own subdirectory under `platform/` with Helm values or manifests.
