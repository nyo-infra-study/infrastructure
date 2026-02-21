# AGENT.md / AI_CONTEXT.md

> **CRITICAL**: This file describes the **GitOps & Automated Build** nature of this project. Read this before proposing changes.

## 1. Project Identity

- **Goal**: Infrastructure for a 3-tier app (Frontend, Backend, DB) + Monitoring (PLG).
- **Methodology**: Pure GitOps (ArgoCD) + In-Cluster CI (Argo Workflows).
- **Environment**: Local `k3d` cluster named `dev`.

## 2. The Core Loop (Read this!)

Unlike standard K8s setups, we do **not** build locally or `kubectl apply` apps directly.

**The Workflow:**

1.  **Code Change**: Developer pushes to `main`.
2.  **Trigger**: **Argo Events** detects the push.
3.  **Build**: **Argo Workflows** spins up a Pod, runs Kaniko, builds Docker image, and pushes to Docker Hub.
    - _Note_: Frontend has build-time env vars injected here.
4.  **Deploy**: **ArgoCD** detects the new image (via stable tag or digest) and syncs the cluster.

**Implication for Agents**:

- **CRITICAL RULE**: You MUST ALWAYS `git commit` and `git push` any changes to manifests, Helm values, or code **BEFORE** running `./run.sh` or expecting ArgoCD to sync them. ArgoCD pulls from the remote Git repository, so uncommitted local changes will be ignored and overwritten!
- Do **NOT** suggest `docker build` commands for the user (unless debugging).
- Do **NOT** suggest `kubectl apply -f apps/...` manually (ArgoCD will revert it).
- **DO** suggest editing files, committing, and pushing.

## 3. Architecture Stack

| Component       | Tool           | Notes                                                     |
| :-------------- | :------------- | :-------------------------------------------------------- |
| **Cluster**     | k3d            | Exposed on `localhost:9000`.                              |
| **GitOps**      | ArgoCD         | Managed via "App of Apps" pattern (`bootstrap/dev.yaml`). |
| **CI / Builds** | Argo Workflows | Templates in `argo-workflows/`.                           |
| **Triggers**    | Argo Events    | Sensors/Sources in `argo-events/`.                        |
| **Ingress**     | Cilium         | Replaces Traefik. Exposed on port 9000 (shared mode).     |
| **Database**    | PostgreSQL     | Bitnami chart (`bitnamilegacy` repo).                     |
| **Logging**     | PLG Stack      | Promtail -> Loki -> Grafana.                              |

## 4. Where to Edit

| Intent                            | Path to Edit                                                      |
| :-------------------------------- | :---------------------------------------------------------------- |
| **Change Image Tag / Env Vars**   | `apps/dev/<service>.yaml` (ArgoCD App Manifest)                   |
| **Modify Helm Templates**         | `charts/<service>/templates/`                                     |
| **Change Build Logic**            | `argo-workflows/frontend-build-template.yaml`                     |
| **Add New Microservice**          | 1. Create Chart (`charts/new`), 2. Add App (`apps/dev/new.yaml`). |
| **Platform Config (ArgoCD/Loki)** | `platform/<service>/values.yaml`                                  |

## 5. Observability (PLG Stack)

- **Logs**: Do NOT rely solely on `kubectl logs`. Use **Grafana**.
- **URL**: `http://localhost:9000/grafana`
- **Credentials**:
  - User: `admin`
  - Password: See `grafana-auth` secret (or `P5F8lxHPhr58CLlCzFRTpr2iUoxjb2YieWnFBHLY`).
- **Issue**: If logs fail with "unexpected IDENTIFIER", check Loki version compatibility.

## 6. Access Points

The cluster uses a single load balancer on **port 9000**:

- **Frontend**: `http://localhost:9000/`
- **Backend API**: `http://localhost:9000/api`
- **ArgoCD UI**: `http://localhost:9000/argocd`
- **Grafana**: `http://localhost:9000/grafana`

## 7. Common Troubleshooting

- **Database "No such host"**: Use `backend-db-primary` (Write) or `backend-db-read` (Read).
- **Image Pull Error**: Ensure `allowInsecureImages: true` is set for Bitnami legacy images.
- **ArgoCD OutOfSync**: Check `ignoreDifferences` in Application manifest if it fights with dynamic fields (e.g., PVCs).
