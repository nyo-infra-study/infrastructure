# How To Run

Step-by-step guide to deploy backend-server and web-frontend to a local Kubernetes cluster using **Argo Workflows** (for builds) + **ArgoCD** (for deployments) + **Helm** (for packaging).

## Architecture

```
┌─────────────────┐
│ Argo Workflows  │  Build images with env-specific variables
└────────┬────────┘
         │ Push to Docker Hub
         ▼
┌─────────────────┐
│   Docker Hub    │  Image registry
└────────┬────────┘
         │ Pull images
         ▼
┌─────────────────┐
│     ArgoCD      │  Deploy via Helm charts (GitOps)
└────────┬────────┘
         │ Sync
         ▼
┌─────────────────┐
│   Kubernetes    │  Running apps
└─────────────────┘
```

## Prerequisites

| Tool       | Install                      | Purpose                     |
| ---------- | ---------------------------- | --------------------------- |
| Docker     | `brew install --cask docker` | Required by k3d             |
| kubectl    | `brew install kubectl`       | Talk to Kubernetes          |
| Helm       | `brew install helm`          | Package manager for K8s     |
| k3d        | `brew install k3d`           | Local K8s cluster (via k3s) |
| ArgoCD CLI | `brew install argocd`        | Manage ArgoCD from terminal |
| Argo CLI   | `brew install argo`          | Submit workflows (optional) |

---

## 0. Start Colima (Mac Users)

If you are using Colima instead of Docker Desktop, start it with enough resources (ArcgoCD + PLG stack is heavy):

```bash
colima start --cpu 4 --memory 8
```

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

# Wait for ArgoCD to be ready
kubectl wait --for=condition=available deployment/argocd-server -n argocd --timeout=300s
```

Wait for pods to be ready:

```bash
kubectl -n argocd rollout status deployment argocd-server
```

---

## 3. Install Argo Workflows

Following the [official quick-start guide](https://argo-workflows.readthedocs.io/en/latest/quick-start/):

```bash
kubectl create namespace argo
kubectl apply -n argo -f https://github.com/argoproj/argo-workflows/releases/download/v4.0.0/install.yaml --server-side
```

Wait for pods:

```bash
kubectl get pods -n argo -w
# Ctrl+C when both argo-server and workflow-controller are Running
```

---

## 4. Install Argo Events

For automated builds triggered by Git pushes:

```bash
kubectl create namespace argo-events
kubectl apply -f https://raw.githubusercontent.com/argoproj/argo-events/stable/manifests/install.yaml

# Install EventBus (NATS for event transport)
kubectl apply -n argo -f https://raw.githubusercontent.com/argoproj/argo-events/stable/examples/eventbus/native.yaml
```

Wait for controllers:

```bash
kubectl get pods -n argo-events -w
# Ctrl+C when controller-manager is Running
```

**Create GitHub personal access token:**

Only needed if you want automated builds on `git push`:

1. Go to GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Generate new token with `repo` and `admin:repo_hook` scopes
3. Create secret:

```bash
kubectl create secret generic github-access \
  -n argo \
  --from-literal=token=YOUR_GITHUB_TOKEN
```

---

## 5. Set Up Docker Hub Credentials

Argo Workflows needs credentials to push images to Docker Hub:

**Create access token:**

1. Go to [Docker Hub → Settings → Security](https://hub.docker.com/settings/security)
2. Click "New Access Token"
3. Name it "k3d-argo-workflows"
4. Copy the token

**Create Kubernetes secret:**

```bash
kubectl create secret docker-registry docker-credentials \
  --docker-server=https://index.docker.io/v1/ \
  --docker-username=YOUR_DOCKERHUB_USERNAME \
  --docker-password=YOUR_DOCKERHUB_TOKEN \
  --docker-email=YOUR_EMAIL \
  -n argo
```

---

## 6. Set Up Automated Builds (Argo Workflows + Events)

**All workflows are managed by ArgoCD and triggered automatically!**

ArgoCD watches `argo-workflows/` and `argo-events/` directories, deploying:

- **WorkflowTemplates**: Reusable build definitions
- **EventSources**: GitHub webhook listeners
- **Sensors**: Trigger workflows on Git events

**On every `git push`:** Sensors automatically trigger builds with commit SHA as image tag.

**Build backend image** (if needed):

```bash
cd ../backend-server
docker build -t YOUR_DOCKERHUB_USERNAME/backend-server:latest .
docker push YOUR_DOCKERHUB_USERNAME/backend-server:latest
```

> **Note:** Backend doesn't need Argo Workflows since it has no build-time env vars. You can build it locally or create a similar workflow.

---

## 7. Configure Automatic Deployments

**No manual image tag updates needed!** Our setup uses stable tags that automatically trigger deployments.

### How It Works

```
git push (web-frontend)
  ↓
CronWorkflow polls GitHub (every 2 min)
  ↓
Updates ConfigMap with latest commit
  ↓
EventSource detects ConfigMap change
  ↓
Sensor triggers Workflow
  ↓
Kaniko builds & pushes to Docker Hub (tag: "dev")
  ↓
ArgoCD detects new image digest
  ↓
Deployment automatically restarts with new image ✅
```

### Configuration

**ArgoCD apps use stable tags:**

```yaml
# apps/dev/web-frontend.yaml
valuesObject:
  image:
    tag: "dev" # Static tag, always points to latest
    pullPolicy: Always # Force pull on every deployment
```

**Build template overwrites the same tag:**

```yaml
# argo-workflows/frontend-build-template.yaml
args:
  - "--destination=skimpjr/web-frontend:{{inputs.parameters.environment}}"
  # Pushes to 'dev' tag, overwrites each time
```

### First-Time Setup Only

**Deploy ArgoCD applications:**

```bash
cd infrastructure
kubectl create namespace dev # (but we need it for the secret, even though it can be created by the bootstrap/dev.yaml)

# Initialize Database Secret (Required for backend-db)
# By default, the chart expects a secret named 'backend-db-secret'
# If you don't create it, the chart will try to create one with default values (which is fine for dev)
# But for security best practices, create it manually:
kubectl create secret generic backend-db-secret \
  --namespace dev \
  --from-literal=POSTGRES_PASSWORD=yoursecurepassword
```

### After First Deployment

**That's it!** Now every time you push to `web-frontend` main branch:

1. ⏱️ Within 2 minutes: CronWorkflow detects new commit
2. 🔨 Build automatically triggers via Sensor
3. 🐳 Kaniko builds and pushes image to `skimpjr/web-frontend:dev`
4. 🔄 ArgoCD sees new image digest
5. ✅ Deployment restarts with new image

**No manual steps required!**

### Build Backend Image (Manual)

Backend doesn't change often and has no build-time env vars:

```bash
cd ../backend-server
docker build -t YOUR_DOCKERHUB_USERNAME/backend-server:latest .
docker push YOUR_DOCKERHUB_USERNAME/backend-server:latest
```

---

## 8. Deploy with ArgoCD

### Access ArgoCD UI

```bash
# Get admin password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
echo  # newline
```

Wait until the ArgoCD Server is ready:

```bash
kubectl wait --for=condition=available deployment/argocd-server -n argocd --timeout=300s
```

Open [http://localhost:8080/argocd](http://localhost:8080/argocd) → Login with `admin` and the password above.

**Password has a corrupt `%` at the end?**

Reset the password:

```bash
kubectl patch secret argocd-secret -p '{"data": {"admin.password": null, "admin.passwordMtime": null}}' -n argocd && \
kubectl delete secret argocd-initial-admin-secret -n argocd && \
kubectl rollout restart deployment argocd-server -n argocd && \
sleep 30 && \
kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 --decode
echo ""
```

### Deploy the App of Apps

This is the only `kubectl apply` you need for ArgoCD. It handles everything else via GitOps.

```bash
kubectl apply -f bootstrap/dev.yaml
```

Thi9. Access the Apps (via Ingress)

Because we created the cluster with `--port "8080:80@loadbalancer"`, k3d automatically routes traffic from your machine's port **8080** to the cluster's Ingress Controller.

You do **not** need to use `kubectl port-forward` anymore.

- **Frontend**: [http://localhost:8080/](http://localhost:8080/)
- **Backend API**: [http://localhost:8080/api](http://localhost:8080/api)
- **ArgoCD UI**: [http://localhost:8080/argocd](http://localhost:8080/argocd)
- **Argo Workflows UI**: Access via port-forward:
  ```bash
  kubectl -n argo port-forward deployment/argo-server 2746:2746
  # Open: https://localhost:2746
  ```

### ℹ️ Understanding Ports

You might notice in the configuration that we set:

- **Backend Service**: Port 9091
- **Frontend Service**: Port 9092

These are **internal** ports used only inside the cluster (e.g., Ingress talking to the Service). Externally, you always access both apps through the single entry point (Load Balancer) on port **8080**.

---

## Workflow Summary

### Initial Setup (one-time)

1. ✅ Create k3d cluster
2. ✅ Install ArgoCD (Helm)
3. ✅ Install Argo Workflows
4. ✅ Install Argo Events
5. ✅ Set up Docker Hub credentials
6. ✅ Set up automated builds (workflows + events)
7. ✅ Update image tags in Git
8. ✅ Deploy with ArgoCD

### Making Changes

**Update code → Automatic build → Update tag → Redeploy:**

```bash
# 1. Commit your code changes
git add .
git commit -m "feat: new feature"
git push origin main

# 2. Sensor automatically triggers build with commit SHA
# 3. Watch the workflow (optional)
kubectl get workflows -n argo -w

# 4. Update apps/dev/web-frontend.yaml with new commit SHA tag
vim apps/dev/web-frontend.yaml
git add apps/dev/web-frontend.yaml
git commit -m "chore: update frontend to dev-1234567890"
git push origin main

# 4. ArgoCD auto-syncs within ~3 minutes (or click Sync in UI)
```

**Change configuration only:**

```bash
# Example: Scale replicas
# Edit apps/dev/backend-server.yaml → replicaCount: 2
git add . && git commit -m "scale backend to 2 replicas" && git push
# ArgoCD auto-syncs
```

---

## Why This Flow?

### Traditional Flow Issues

- ❌ Frontend has build-time env vars (`VITE_API_URL`) - can't change after build
- ❌ Need local Docker builds for every environment
- ❌ Team members need Docker Hub access and local setup

### This Flow Benefits

- ✅ **Argo Workflows** builds images inside cluster with environment-specific vars
- ✅ **ArgoCD** handles deployment via GitOps (no manual kubectl apply)
- ✅ **Helm** packages everything with reusable templates
- ✅ Everything is declarative and version-controlled
- ✅ Team members just push to Git - infrastructure handles the rest

---

## Troubleshooting

### Argo Workflows - Image Build Fails

Check workflow logs:

```bash
argo logs @latest -n argo -f
```

Common issues:

- Docker credentials secret not found
- Git repository URL is wrong
- Git repository is private (needs Git credentials)

### ArgoCD - Application Not Syncing

```bash
# Check application status
argocd app get dev-backend-server

# Force sync
argocd app sync dev-backend-server

# Check pod logs
kubectl logs -n dev -l app=dev-backend-server
```

### Images Not Pulling

Check if images exist in Docker Hub:

```bash
open https://hub.docker.com/r/skimpjr/web-frontend/tags
```

If image exists but not pulling:

- Check image pull policy (should be `Always` or `IfNotPresent`)
- Verify image tag matches in `apps/dev/*.yaml`

---

## Additional Resources

- [ArgoCD Documentation](https://argo-cd.readthedocs.io/)
- [Argo Workflows Documentation](https://argo-workflows.readthedocs.io/)
- [Argo Events Documentation](https://argoproj.github.io/argo-events/)
- [Helm Documentation](https://helm.sh/docs/)

## Automated Image Builds

**All builds are triggered automatically by Sensors on Git push!**

Build images **inside your cluster** with environment-specific configuration:

```bash
# Install Argo Workflows (one-time setup)
kubectl create namespace argo
kubectl apply -n argo -f https://github.com/argoproj/argo-workflows/releases/download/v4.0.0/install.yaml --server-side

# Deploy CI/CD apps (ArgoCD manages workflows/events)
kubectl apply -f apps/dev/argo-workflows.yaml
kubectl apply -f apps/dev/argo-events.yaml

# From now on: git push automatically triggers builds!
# ArgoCD watches argo-workflows/ and argo-events/ → auto-deploys
```

**How It Works:**

1. **Git Push** → GitHub webhook → EventSource receives event
2. **Sensor** detects push → triggers WorkflowTemplate with commit SHA
3. **Workflow** builds image → pushes to Docker Hub with commit SHA tag
4. **You update** apps/dev/web-frontend.yaml with new tag → commit → push
5. **ArgoCD** auto-syncs deployment with new image

**GitOps Workflow Management:**

- All workflows in `argo-workflows/` auto-deployed by ArgoCD
- All sensors in `argo-events/` auto-deployed by ArgoCD
- To add builds: Create WorkflowTemplate + Sensor, commit, push

**Why Argo Workflows?**

- Build with environment-specific variables (e.g., `VITE_API_URL`)
- No need for local Docker builds
- Team members can trigger builds from the cluster
- Integrates with GitOps workflow

---

## 8. Monitor Automated Builds

### Watch All Workflows

```bash
# Watch all workflows in real-time
kubectl get workflows -n argo -w

# List recent workflows
kubectl get workflows -n argo --sort-by=.metadata.creationTimestamp
```

### Check Poller Status

```bash
# See poller runs (every 2 minutes)
kubectl get workflows -n argo | grep github-poller

# Check what commit was detected
kubectl get configmap github-latest-commit -n argo -o yaml

# Watch ConfigMap for updates
kubectl get configmap github-latest-commit -n argo -w
```

### View Sensor Logs

```bash
# Check if sensor is running
kubectl get pods -n argo | grep sensor

# Watch sensor activity (shows when builds are triggered)
kubectl logs -n argo -l sensor-name=frontend-build-trigger -f

# Check sensor status
kubectl describe sensor frontend-build-trigger -n argo
```

### View Build Logs

```bash
# List all frontend builds
kubectl get workflows -n argo | grep frontend-build

# Get logs from specific build (replace with actual name)
kubectl logs -n argo -l workflows.argoproj.io/workflow=frontend-build-xxxxx

# Watch latest build in real-time
kubectl logs -n argo -l workflows.argoproj.io/workflow=frontend-build-xxxxx -f
```

### Check EventSource

```bash
# Check EventSource status
kubectl get eventsources -n argo

# View EventSource logs
kubectl logs -n argo -l eventsource-name=github -f
```

### Test the Full Flow

```bash
# 1. Push a commit to web-frontend
cd ../web-frontend
git commit --allow-empty -m "test: trigger automated build"
git push

# 2. Watch for poller to detect it (within 2 minutes)
kubectl get workflows -n argo -w

# You should see:
# - github-poller-xxxxx runs (every 2 min)
# - frontend-build-xxxxx automatically triggered after poller succeeds!
```

### Useful Debugging Commands

```bash
# Check all pods in argo namespace
kubectl get pods -n argo

# Check ArgoCD application status
kubectl get applications -n argocd

# View argo-events controller logs
kubectl logs -n argo-events -l app.kubernetes.io/name=controller-manager --tail=50

# Check workflow controller logs
kubectl logs -n argo -l app=workflow-controller --tail=50
```

---

## 10. Teardown

```bash
# Delete everything
k3d cluster delete dev
```

## 11. Troubleshooting: Bitnami PostgreSQL

### Image Pull Errors (ImagePullBackOff)

If you see errors pulling `bitnami/postgresql` images (e.g., `manifest unknown` or `not found`), this is because Bitnami archived their main Docker Hub repository.

**Solution:**
We use the legacy repository `bitnamilegacy/postgresql` with tag `16-debian-12`. This requires allowing "insecure" images in the chart logic:

```yaml
global:
  security:
    allowInsecureImages: true

postgresql:
  image:
    repository: bitnamilegacy/postgresql
    tag: 16-debian-12
```

### Database Connection (DNS Error)

If the backend server fails with `dial tcp: lookup backend-db ... no such host`, it's because the Bitnami chart creates specific services for Primary (write) and Read (read-only) nodes.

**Correct Hostnames:**

- **Writes:** `backend-db-primary` (Use this for `DB_HOST`)
- **Reads:** `backend-db-read` (Use for read-only replicas)

## 12. Monitor Logs (PLG Stack)

We use the **PLG Stack** (Promtail, Loki, Grafana) for centralized logging.

### Access Grafana

**URL:** [http://localhost:8080/grafana](http://localhost:8080/grafana)

1.  **Login:**
    - User: `admin`
    - Password: `P5F8lxHPhr58CLlCzFRTpr2iUoxjb2YieWnFBHLY`

_(Backup) Port-forward if Ingress fails:_

```bash
kubectl port-forward svc/dev-plg-stack-grafana 3000:80 -n monitoring
# URL: http://localhost:3000
```

### View Logs

1.  Go to **Explore** (compass icon on the left).
2.  Select **Loki** as the data source.
3.  Use the **Label Browser** to find your app:
    - `{app="web-frontend"}`
    - `{app="backend-server"}`
4.  Click **Run Query** (blue button).

You will see live logs from all pods matching the label, even if they restart!
