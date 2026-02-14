# Infrastructure

GitOps infrastructure repository for deploying applications to Kubernetes using ArgoCD and Helm, following the **App of Apps** pattern.

## 📁 Folder Structure

```
infrastructure/
├── bootstrap/           # Entry point - App of Apps (one per environment)
│   └── dev.yaml        # Bootstraps all apps in apps/dev/
│
├── apps/               # ArgoCD Applications (environment-specific config)
│   └── dev/
│       ├── backend-server.yaml
│       ├── web-frontend.yaml
│       └── argocd-ingress.yaml
│
├── charts/             # Reusable Helm charts (environment-agnostic)
│   ├── backend-server/
│   │   ├── Chart.yaml
│   │   ├── values.yaml     # Base defaults
│   │   └── templates/      # K8s manifests
│   └── web-frontend/
│       ├── Chart.yaml
│       ├── values.yaml
│       └── templates/
│
├── argo-workflows/     # CI/CD workflow definitions
│   └── frontend-build-template.yaml
│
├── argo-events/        # Event-driven automation
│   ├── github-event-source.yaml
│   └── frontend-build-sensor.yaml
│
└── platform/           # Platform services (shared across all environments)
    └── argocd/
        ├── values.yaml     # ArgoCD server configuration
        └── ingress.yaml    # ArgoCD UI ingress
```

### Folder Purposes

| Folder            | Purpose                                                                     | When to Edit                                        |
| ----------------- | --------------------------------------------------------------------------- | --------------------------------------------------- |
| `bootstrap/`      | App-of-Apps entry point. Apply once to bootstrap entire environment         | Adding new environments (staging, prod)             |
| `apps/`           | ArgoCD Application manifests with **environment-specific** config overrides | Changing env-specific values (replicas, image tags) |
| `charts/`         | Reusable Helm charts with templates and **base defaults**                   | Adding new services or changing K8s resources       |
| `argo-workflows/` | CI/CD workflow definitions for building Docker images                       | Creating new workflows or modifying build steps     |
| `argo-events/`    | Event sources and sensors for automated workflow triggering                 | Setting up GitHub webhooks or event automation      |
| `platform/`       | Platform-level services that are **shared across all environments**         | Configuring ArgoCD, monitoring, logging             |

## 🚀 How to Run

### Prerequisites

- Docker Desktop or similar (for local Kubernetes)
- kubectl
- Helm
- k3d (for lightweight local cluster)
- ArgoCD CLI (optional, for CLI management)

Install tools (macOS):

```bash
brew install kubectl helm k3d argocd
```

### Step 1: Create Local Cluster

```bash
# Create k3d cluster with port mapping for Ingress
k3d cluster create dev --port "8080:80@loadbalancer"

# Verify
kubectl cluster-info
kubectl get nodes
```

### Step 2: Install ArgoCD

```bash
# Add Helm repo
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update

# Install ArgoCD with custom values for HTTP and subpath
helm install argocd argo/argo-cd \
  --namespace argocd \
  --create-namespace \
  -f platform/argocd/values.yaml

# Wait for ArgoCD to be ready
kubectl -n argocd rollout status deployment argocd-server
```

### Step 3: Get ArgoCD Admin Password

```bash
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 -d
echo  # newline
```

### Step 4: Bootstrap Applications

This is the **only manual kubectl apply** you need. ArgoCD handles everything else.

```bash
kubectl apply -f bootstrap/dev.yaml
```

This creates the "App of Apps" which:

1. Reads all manifests in `apps/dev/`
2. Creates ArgoCD Applications for each service
3. Deploys Helm charts to the `dev` namespace
4. Auto-syncs on every Git push

### Step 5: Verify Deployment

```bash
# Check ArgoCD Applications
kubectl get applications -n argocd

# Check pods in dev namespace
kubectl get pods -n dev

# Check services
kubectl get svc -n dev

# Check ingresses
kubectl get ingress -n dev
kubectl get ingress -n argocd
```

### Step 6: Access Applications

All applications are accessible via Ingress on `localhost:8080`:

- **Frontend**: http://localhost:8080/
- **Backend API**: http://localhost:8080/api
- **ArgoCD UI**: http://localhost:8080/argocd

Login to ArgoCD with username `admin` and the password from Step 3.

## 🔄 Development Workflow

After initial setup, just push changes to Git:

```bash
# Example 1: Update application code
# 1. Build and push new Docker image with tag 1.0.2
# 2. Update image tag in apps/dev/backend-server.yaml
# 3. Git commit and push
# → ArgoCD auto-syncs within ~3 minutes

# Example 2: Scale application
# Edit apps/dev/web-frontend.yaml → change replicaCount: 2
git add . && git commit -m "scale frontend to 2 replicas" && git push
# → ArgoCD detects change and updates deployment

# Example 3: Modify Kubernetes resources
# Edit charts/backend-server/templates/deployment.yaml
git add . && git commit -m "add resource limits" && git push
# → ArgoCD redeploys with new template
```

## 📦 App of Apps Pattern

```
                    kubectl apply -f bootstrap/dev.yaml
                                   │
                                   ▼
                          ┌── dev-root ──┐       (App of Apps)
                          │              │
                          ▼              ▼
                 dev-backend-server   dev-web-frontend   (Child Apps)
                          │              │
                          ▼              ▼
                  charts/backend    charts/frontend      (Helm → K8s)
```

**Benefits:**

- **Single entry point**: Only `kubectl apply` once
- **Automatic discovery**: Adding `apps/dev/new-service.yaml` auto-deploys
- **Environment isolation**: Dev changes don't affect prod
- **Declarative sync policies**: Dev auto-syncs, prod requires approval

## 🔧 Common Tasks

### Add a New Service

1. Create Helm chart in `charts/my-service/`
2. Create Application manifest in `apps/dev/my-service.yaml`
3. Push to Git → ArgoCD deploys automatically

### Add Staging/Production Environment

1. Create `apps/staging/` with environment-specific configs
2. Create `bootstrap/staging.yaml` (copy from dev, update sync policy)
3. `kubectl apply -f bootstrap/staging.yaml`

### Update Application Image

Edit `apps/dev/backend-server.yaml`:

```yaml
valuesObject:
  image:
    tag: "1.0.2" # Change this
```

### Check ArgoCD Sync Status

```bash
# Using ArgoCD CLI
argocd app list
argocd app get dev-backend-server

# Using kubectl
kubectl get applications -n argocd
kubectl describe application dev-backend-server -n argocd
```

### Force Sync (if needed)

```bash
argocd app sync dev-backend-server
# or sync all
argocd app sync -l environment=dev
```

## 🧹 Cleanup

```bash
# Delete everything
k3d cluster delete dev
```

## 📚 Additional Resources

- [ArgoCD Documentation](https://argo-cd.readthedocs.io/)
- [Argo Workflows Documentation](https://argo-workflows.readthedocs.io/)
- [Argo Events Documentation](https://argoproj.github.io/argo-events/)
- [Helm Documentation](https://helm.sh/docs/)
- [App of Apps Pattern](https://argo-cd.readthedocs.io/en/stable/operator-manual/cluster-bootstrapping/)
- See [HOW-TO-RUN.md](./HOW-TO-RUN.md) for detailed step-by-step instructions

## 🏗️ Infrastructure Patterns

### Bitnami PostgreSQL Chart

We use the [Bitnami PostgreSQL Helm Chart](https://github.com/bitnami/charts/tree/main/bitnami/postgresql) for production-grade database features (Replication, HA).

**Key Implementation Details:**

- **Repository:** Uses `bitnamilegacy/postgresql` due to Docker Hub archiving.
- **Service Discovery:** Read/Write split via `backend-db-primary` and `backend-db-read` services.
- **Replication:** Configured with `architecture: replication` and 1+ read replicas.
- **Secret Management:** Uses existing Kubernetes secrets (`backend-db-secret`) mapped to chart env vars.
