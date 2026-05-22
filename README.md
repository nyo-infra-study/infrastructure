# Infrastructure

GitOps infrastructure repository for deploying applications to Kubernetes using ArgoCD and Helm, following the **App of Apps** pattern.

## 📁 Folder Structure

```
infrastructure/
├── bootstrap/              # Entry point - App of Apps
│   └── dev.yaml           # Bootstraps all apps in apps/dev/
│
├── apps/                   # ArgoCD Applications (environment-specific)
│   └── dev/
│       ├── 0-platform/         # Platform layer (VPA controller, ArgoCD)
│       │   ├── argocd.yaml
│       │   └── vpa.yaml
│       ├── 1-monitoring-core/  # Core observability (storage + query + UI)
│       │   ├── monitoring-clickhouse.yaml
│       │   ├── monitoring-gigapipe.yaml
│       │   ├── monitoring-grafana-gigapipe.yaml
│       │   └── monitoring-pyroscope.yaml
│       ├── 2-monitoring-infra/ # Monitoring infrastructure (collectors + exporters)
│       │   ├── monitoring-blackbox-exporter.yaml
│       │   ├── monitoring-ksm.yaml
│       │   ├── monitoring-node-exporter.yaml
│       │   ├── monitoring-otel.yaml
│       │   └── monitoring-radar.yaml
│       ├── 3-data/             # Data stores
│       │   └── backend-db.yaml
│       ├── 4-apps/             # Application workloads
│       │   ├── backend-server.yaml
│       │   └── web-frontend.yaml
│       └── 5-cicd/             # CI/CD (disabled in local dev)
│           ├── argo-events.yaml.disabled
│           └── argo-workflows.yaml.disabled
│
├── charts/                 # Local Helm charts
│   ├── backend-db/        # Wrapper for Bitnami PostgreSQL
│   ├── backend-server/    # Go backend (includes VPA template)
│   ├── clickhouse/        # ClickHouse StatefulSet (includes VPA template)
│   ├── gigapipe/          # Gigapipe writer + readers (includes VPA template)
│   └── web-frontend/      # React frontend (includes VPA template)
│
├── argo-workflows/         # CI/CD templates & RBAC
│   ├── frontend-build-template.yaml
│   ├── github-poller.yaml
│   └── rbac.yaml
│
├── argo-events/            # Event-driven triggers
│   ├── github-event-source.yaml
│   ├── frontend-build-sensor.yaml
│   └── rbac.yaml
│
└── platform/               # Platform configs (values + VPA policies)
    ├── argocd/
    │   └── values.yaml
    ├── vpa/                    # VPA controller values
    │   └── values.yaml
    └── monitoring/
        ├── blackbox-exporter/  # Blackbox exporter values + VPA
        ├── clickhouse/         # ClickHouse values
        ├── collector/          # OTel Collector values + VPA
        ├── gigapipe/           # Gigapipe values
        ├── grafana-gigapipe/   # Grafana values + dashboards + VPA
        ├── pyroscope/          # Pyroscope values + VPA
        ├── radar/              # Radar values + VPA
        ├── common-values.yaml  # Shared OTel config
        └── ksm-vpa.yaml        # KSM VPA policy
```

### Folder Purposes

| Folder | Purpose | When to Edit |
|--------|---------|--------------|
| `bootstrap/` | App-of-Apps entry point. Apply once to bootstrap entire environment | Adding new environments (staging, prod) |
| `apps/` | ArgoCD Application manifests with **environment-specific** config overrides | Changing env-specific values (replicas, image tags) |
| `charts/` | Reusable Helm charts with templates and **base defaults** | Adding new services or changing K8s resources |
| `argo-workflows/` | CI/CD workflow definitions for building Docker images | Creating new workflows or modifying build steps |
| `argo-events/` | Event sources and sensors for automated workflow triggering | Setting up GitHub webhooks or event automation |
| `platform/` | Platform-level services that are **shared across all environments** | Configuring ArgoCD, monitoring, logging |

### VPA Strategy

VPA policies are co-located with each app for visibility in ArgoCD UI:

- **Local charts** → VPA template in `charts/<app>/templates/vpa.yaml`
- **Upstream charts** → VPA file in `platform/monitoring/<app>/vpa.yaml`, included via ArgoCD multi-source `directory.include`

This means clicking any app in ArgoCD shows its VPA resource directly in the resource tree.

## 🚀 How to Run

See [HOW-TO-RUN.md](./HOW-TO-RUN.md) for detailed step-by-step instructions.

### Quick Start

```bash
# 1. Create local cluster
k3d cluster create dev --port "9000:80@loadbalancer"

# 2. Install ArgoCD
helm repo add argo https://argoproj.github.io/argo-helm
helm install argocd argo/argo-cd \
  --namespace argocd --create-namespace \
  -f platform/argocd/values.yaml

# 3. Bootstrap everything (only manual step needed)
kubectl apply -f bootstrap/dev.yaml

# 4. Access
# ArgoCD:  http://localhost:9000/argocd (admin/password)
# Grafana: http://grafana.localhost:9000 (admin/admin)
# Radar:   http://radar.localhost:9000
```

## 🔄 Development Workflow

After initial setup, just push changes to Git:

```bash
# Scale application
# Edit apps/dev/4-apps/backend-server.yaml → change replicaCount: 2
git add . && git commit -m "scale backend to 2 replicas" && git push
# → ArgoCD auto-syncs within ~3 minutes

# Modify Kubernetes resources
# Edit charts/backend-server/templates/deployment.yaml
git add . && git commit -m "add resource limits" && git push
# → ArgoCD redeploys with new template
```

## 📦 App of Apps Pattern

```
kubectl apply -f bootstrap/dev.yaml
              │
              ▼
     ┌── dev-root ──┐                    (App of Apps)
     │              │
     ▼              ▼
  0-platform    1-monitoring-core         (Wave-based ordering)
     │              │
     ▼              ▼
  VPA controller  ClickHouse → Gigapipe → Grafana
                                          (Dependency chain)
```

**Wave-based deployment order:**
1. `0-platform` — VPA controller, ArgoCD (CRDs must exist first)
2. `1-monitoring-core` — ClickHouse, Gigapipe, Grafana, Pyroscope
3. `2-monitoring-infra` — OTel Collector, KSM, Node Exporter, Blackbox, Radar
4. `3-data` — PostgreSQL
5. `4-apps` — Backend Server, Web Frontend
6. `5-cicd` — Argo Workflows/Events (disabled in local dev)

## 🔧 Common Tasks

### Add a New Service

1. Create Helm chart in `charts/my-service/` (include `templates/vpa.yaml`)
2. Create Application manifest in `apps/dev/<wave>/my-service.yaml`
3. Push to Git → ArgoCD deploys automatically

### Add VPA to an Upstream Chart

1. Create `platform/monitoring/<app>/vpa.yaml` with the VPA manifest
2. Add a directory source to the ArgoCD Application:
   ```yaml
   sources:
     - chart: <upstream-chart>
       # ... helm config ...
     - repoURL: https://github.com/nyo-infra-study/infrastructure.git
       targetRevision: main
       path: platform/monitoring/<app>
       directory:
         include: 'vpa.yaml'
     - repoURL: ...
       ref: values
   ```

### Check VPA Recommendations

```bash
kubectl get vpa --all-namespaces
kubectl describe vpa <vpa-name> -n <namespace>
```

## 🧹 Cleanup

```bash
k3d cluster delete dev
```

## 📚 Additional Resources

- [ArgoCD Documentation](https://argo-cd.readthedocs.io/)
- [Helm Documentation](https://helm.sh/docs/)
- [App of Apps Pattern](https://argo-cd.readthedocs.io/en/stable/operator-manual/cluster-bootstrapping/)
- [VPA Documentation](https://github.com/kubernetes/autoscaler/tree/master/vertical-pod-autoscaler)
