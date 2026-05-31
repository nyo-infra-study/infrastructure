# AGENT.md / AI_CONTEXT.md

> **CRITICAL**: This file describes the **GitOps & Automated Build** nature of this project. Read this before proposing changes.

## 1. Project Identity

- **Goal**: Infrastructure for a 3-tier app (Frontend, Backend, DB) + Monitoring (Grafana, Loki, Mimir, Tempo, Pyroscope).
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

- Do **NOT** suggest `docker build` commands for the user (unless debugging).
- Do **NOT** suggest `kubectl apply -f apps/...` manually (ArgoCD will revert it).
- **DO** suggest editing files, committing, and pushing.

## 3. Architecture Stack

| Component       | Tool           | Notes                                                     |
| :-------------- | :------------- | :-------------------------------------------------------- |
| **Cluster**     | k3d            | Exposed on `localhost:80` (host-based routing). |
| **GitOps**      | ArgoCD         | Managed via "App of Apps" pattern (`bootstrap/dev.yaml`). |
| **CI / Builds** | Argo Workflows | Templates in `argo-workflows/`.                           |
| **Triggers**    | Argo Events    | Sensors/Sources in `argo-events/`.                        |
| **Ingress**     | Traefik        | Gateway API (HTTPRoute). Installed via Helm (k3d built-in disabled). |
| **Database**    | PostgreSQL     | Bitnami chart (`bitnamilegacy` repo).                     |
| **Observability** | Grafana Hub | Loki (logs), Mimir (metrics), Tempo (traces), Pyroscope.  |

## 4. Where to Edit

| Intent                            | Path to Edit                                                      |
| :-------------------------------- | :---------------------------------------------------------------- |
| **Change Image Tag / Env Vars**   | `apps/dev/<service>.yaml` (ArgoCD App Manifest)                   |
| **Modify Helm Templates**         | `charts/<service>/templates/`                                     |
| **Change Build Logic**            | `argo-workflows/frontend-build-template.yaml`                     |
| **Add New Microservice**          | 1. Create Chart (`charts/new`), 2. Add App (`apps/dev/new.yaml`). |
| **Add/Change Routing (HTTPRoute)**| App charts: `charts/<svc>/templates/httproute.yaml`. Platform: `platform/gateway/` |
| **Change Gateway Config**         | `platform/gateway/gateway.yaml` (listeners, allowed namespaces)   |
| **Change Traefik Config**         | `platform/traefik/values.yaml`                                    |
| **Platform Config (ArgoCD/Grafana)** | `platform/<service>/values.yaml`                               |

## 5. Observability (O11y Stack)

- **Logs/Metrics/Traces**: Do NOT rely solely on `kubectl`. Use **Grafana**.
- **URL**: `http://grafana.localhost`
- **Credentials**:
  - User: `admin`
  - Password: See `grafana-auth` secret (or `P5F8lxHPhr58CLlCzFRTpr2iUoxjb2YieWnFBHLY`).
- **Issue**: If logs fail with "unexpected IDENTIFIER", check Loki version compatibility.

## 6. Access Points

The cluster uses a single load balancer on **port 80** with host-based routing:

- **Frontend**: `http://app.localhost`
- **Backend API**: `http://api.localhost`
- **ArgoCD UI**: `http://argocd.localhost`
- **Grafana**: `http://grafana.localhost`
- **Radar**: `http://radar.localhost`

All `.localhost` domains resolve to `127.0.0.1` automatically on macOS — no `/etc/hosts` editing needed.

## 7. Scripts & Tools

| Script | Purpose |
| :----- | :------ |
| `scripts/run.sh` | Start the k3d cluster |
| `scripts/stop.sh` | Stop the k3d cluster |
| `scripts/dashboard-tool.py` | Manipulate Grafana dashboard JSON (replace datasources, jobs, list panels/queries) |
| `scripts/validate-dashboard-filters.py` | **Validate that metrics used in enabled dashboards are not dropped by collector filters** |

### validate-dashboard-filters.py

Prevents silent dashboard breakage by cross-referencing dashboard PromQL queries against the `metric_relabel_configs` allowlists in the OTel Collector receiver configs.

```bash
# Basic run — checks shared/ + gigapipe/ dashboards against receivers-infra + receivers-apps
python3 scripts/validate-dashboard-filters.py

# Verbose — show all metrics and their pass/block status
python3 scripts/validate-dashboard-filters.py --verbose

# JSON output (for CI)
python3 scripts/validate-dashboard-filters.py --json

# List all parsed filter rules
python3 scripts/validate-dashboard-filters.py --list-filters

# Custom paths
python3 scripts/validate-dashboard-filters.py \
  --dashboards platform/monitoring/grafana/dashboards/shared/ \
  --receivers platform/monitoring/collector/receivers-infra.yaml
```

**When to run**: After editing any dashboard JSON or any `metric_relabel_configs` in the collector receiver YAML files. Exit code 1 means a dashboard metric would be dropped.

**How it works**:
1. Extracts metric names from PromQL `expr` fields in dashboard JSON files.
2. Parses `metric_relabel_configs` with `action: keep` from receiver YAML files.
3. Maps metrics to their source receiver by prefix (e.g. `container_*` → cAdvisor, `kube_*` → KSM).
4. Reports any metric that has an applicable filter but doesn't match the keep regex.

## 8. Common Troubleshooting

- **Database "No such host"**: Use `backend-db-primary` (Write) or `backend-db-read` (Read).
- **Image Pull Error**: Ensure `allowInsecureImages: true` is set for Bitnami legacy images.
- **ArgoCD OutOfSync**: Check `ignoreDifferences` in Application manifest if it fights with dynamic fields (e.g., PVCs).
- **Dashboard shows "No data"**: Run `python3 scripts/validate-dashboard-filters.py` to check if the metric is being dropped by a collector filter.
