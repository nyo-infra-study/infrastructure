# How To Run

Step-by-step guide to deploy backend-server and web-frontend to a local Kubernetes cluster using ArgoCD + Helm.

## Prerequisites

| Tool       | Install                      | Purpose                        |
| ---------- | ---------------------------- | ------------------------------ |
| Docker     | `brew install --cask docker` | Build and run container images |
| kubectl    | `brew install kubectl`       | Talk to Kubernetes             |
| Helm       | `brew install helm`          | Package manager for K8s        |
| k3d        | `brew install k3d`           | Local K8s cluster (via k3s)    |
| ArgoCD CLI | `brew install argocd`        | Manage ArgoCD from terminal    |

---

## 1. Create a Local Cluster

```bash
k3d cluster create dev --port "8080:80@loadbalancer"
```

Verify:

```bash
kubectl cluster-info
kubectl get nodes
```

---

## 2. Install ArgoCD (via Helm)

```bash
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update

helm install argocd argo/argo-cd \
  --namespace argocd \
  --create-namespace
```

Wait for pods to be ready:

```bash
kubectl -n argocd rollout status deployment argocd-server
```

---

## 3. Access ArgoCD UI

```bash
# Get admin password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
echo  # newline
```

Open [http://localhost:8080/argocd](http://localhost:8080/argocd) → Login with `admin` and the password above.

ArgoCD is now accessible via Ingress at the `/argocd` path, no port-forwarding needed.

### Password has a corrupt `%` at the end?

Sometimes the decoded password ends with a `%` character that isn't actually part of the password. If login fails, reset the admin password:

```bash
#!/usr/bin/env bash

kubectl patch secret argocd-secret -p '{"data": {"admin.password": null, "admin.passwordMtime": null}}' -n argocd && \
kubectl delete secret argocd-initial-admin-secret -n argocd && \
kubectl rollout restart deployment argocd-server -n argocd && \
sleep 30 && \
kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 --decode
echo ""
```

---

## 4. Deploy the App of Apps

This is the only `kubectl apply` you need. ArgoCD handles everything else.

```bash
kubectl apply -f bootstrap/dev.yaml
```

This will:

1. Create a `dev-root` Application in ArgoCD
2. ArgoCD reads `apps/dev/` directory
3. Creates `dev-backend-server` and `dev-web-frontend` Applications
4. Syncs the Helm charts → Deployments + Services in the `dev` namespace

---

## 5. Verify

```bash
# Check ArgoCD Applications
argocd login localhost:8080 --insecure --grpc-web
argocd app list

# Check running pods
kubectl get pods -n dev

# Check services
kubectl get svc -n dev
```

---

## 6. Access the Apps (via Ingress)

Because we created the cluster with `--port "8080:80@loadbalancer"`, k3d automatically routes traffic from your machine's port **8080** to the cluster's Ingress Controller.

You do **not** need to use `kubectl port-forward` anymore.

- **Frontend**: [http://localhost:8080/](http://localhost:8080/)
- **Backend API**: [http://localhost:8080/api](http://localhost:8080/api)

### ℹ️ Understanding Ports

You might notice in the configuration that we set:

- **Backend Service**: Port 9091
- **Frontend Service**: Port 9092

These are **internal** ports used only inside the cluster (e.g., Ingress talking to the Service). Externally, you always access both apps through the single entry point (Load Balancer) on port **8080**.

---

## Updating

After the initial setup, just push to Git:

```bash
# Change a value (e.g., bump replicas)
# Edit apps/dev/backend-server.yaml → replicaCount: 2
git add . && git commit -m "scale backend to 2 replicas" && git push
# ArgoCD auto-syncs within ~3 minutes (or click Sync in UI)
```

---

## Rebuilding Docker Images

```bash
# Backend
cd /path/to/backend-server
docker build -t skimpjr/backend-server:1.0.0 .
docker push skimpjr/backend-server:1.0.0

# Frontend
cd /path/to/web-frontend
docker build -t skimpjr/web-frontend:1.0.0 .
docker push skimpjr/web-frontend:1.0.0

# Force ArgoCD to re-pull (since tag didn't change)
# Either restart the deployment or trigger a sync:
argocd app sync dev-backend-server
argocd app sync dev-web-frontend
```

---

## Teardown

```bash
# Delete everything
k3d cluster delete dev
```
