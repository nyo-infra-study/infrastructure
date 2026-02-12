# Infrastructure

Helm charts and ArgoCD Application manifests for deploying services to Kubernetes, using the **App of Apps** pattern organized by environment.

## Structure

```
infrastructure/
├── root-apps/                               # App of Apps (one per environment)
│   ├── dev.yaml                             # Root app → watches apps/dev/
│   ├── staging.yaml                         # (future)
│   └── prod.yaml                            # (future)
├── apps/                                    # Child ArgoCD Applications (per env)
│   ├── dev/
│   │   ├── backend-server.yaml              # Dev config for backend
│   │   └── web-frontend.yaml                # Dev config for frontend
│   ├── staging/                             # (future)
│   └── prod/                                # (future)
└── charts/                                  # Reusable Helm charts (shared across envs)
    ├── backend-server/
    │   ├── Chart.yaml
    │   ├── values.yaml                      # Base defaults (env-agnostic)
    │   └── templates/
    │       ├── deployment.yaml
    │       └── service.yaml
    └── web-frontend/
        ├── Chart.yaml
        ├── values.yaml
        └── templates/
            ├── deployment.yaml
            └── service.yaml
```

## App of Apps Pattern

Instead of manually applying each Application manifest, you apply **one root app per environment**, and ArgoCD manages everything else.

```
                    kubectl apply -f root-apps/dev.yaml
                                   │
                                   ▼
                          ┌── dev-root ──┐       (ArgoCD App of Apps)
                          │              │
                          ▼              ▼
                 dev-backend-server   dev-web-frontend   (ArgoCD child Apps)
                          │              │
                          ▼              ▼
                  charts/backend    charts/frontend      (Helm charts → K8s resources)
```

### Why One Root App Per Environment?

| Concern                     | Benefit                                             |
| --------------------------- | --------------------------------------------------- |
| **Independent control**     | Pause/disable syncing in prod without affecting dev |
| **Different sync policies** | Dev: auto-sync. Prod: manual approval               |
| **Blast radius**            | A bad push to dev doesn't touch prod                |
| **Clear ownership**         | Each env is a single point of entry                 |

## Deploying

### First Time (bootstrap)

```bash
# 1. Make sure ArgoCD is running in the cluster

# 2. Apply the root app — this is the ONLY thing you apply manually
kubectl apply -f root-apps/dev.yaml

# 3. ArgoCD will:
#    - Read apps/dev/ directory
#    - Create backend-server and web-frontend Applications
#    - Sync the Helm charts to the 'dev' namespace
#    - Auto-sync on any future Git push
```

### After Bootstrap

Just push to Git. ArgoCD watches the repo and auto-syncs.

```
Change charts/backend-server/values.yaml → ArgoCD detects → re-syncs backend
Change apps/dev/web-frontend.yaml        → ArgoCD detects → re-syncs frontend
Add    apps/dev/new-service.yaml         → ArgoCD detects → deploys new service
```

## Accessing the Application

The applications are exposed via Ingress. To access them locally, you need to map the hostnames to your cluster's Ingress IP.

### 1. Get the Ingress IP

If using Minikube with `minikube tunnel` (required for LoadBalancer services):

```bash
# In a separate terminal
minikube tunnel
```

Then get the External IP of the Ingress Controller or use localhost if tunneling:

```bash
kubectl get svc -n ingress-nginx
# OR if using Minikube ingress addon
minikube ip
```

### 2. Update /etc/hosts

Add the IP and hostnames to your `/etc/hosts` file.

If running locally with `minikube tunnel`, the IP is usually `127.0.0.1`.
If using `minikube ip`, use that IP.

```
# Example /etc/hosts
127.0.0.1 backend.dev.local frontend.dev.local
```

### 3. Access in Browser

- **Frontend**: [http://frontend.dev.local](http://frontend.dev.local)
- **Backend API**: [http://backend.dev.local](http://backend.dev.local)

## Adding a New Environment

1. Create `apps/<env>/` with Application manifests (copy from dev, update namespace/values)
2. Create `root-apps/<env>.yaml` (copy from dev, update path and sync policy)
3. `kubectl apply -f root-apps/<env>.yaml`

## Adding a New Service

1. Create chart in `charts/<service-name>/`
2. Add Application manifest in `apps/dev/<service-name>.yaml`
3. Push to Git — ArgoCD picks it up automatically
