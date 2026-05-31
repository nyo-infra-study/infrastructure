# Single IP → Multiple Apps via External Load Balancer (Host-Based Routing)

## How It Works

All services share a single IP address (`127.0.0.1` port `80`) and are differentiated by their `Host` HTTP header. The k3d load balancer acts as the "external gateway" — mimicking a cloud load balancer (AWS ALB, GCP LB, etc.) that sits in front of the cluster.

```
                    ┌─────────────────────────────────────────────────────────┐
                    │                    SINGLE IP                             │
                    │              127.0.0.1:80                                │
                    │          (k3d load balancer container)                   │
                    └────────────────────┬────────────────────────────────────┘
                                         │
                                         ▼
                    ┌─────────────────────────────────────────────────────────┐
                    │              TRAEFIK INGRESS CONTROLLER                  │
                    │         (Layer 7 reverse proxy / router)                 │
                    │                                                          │
                    │   Host-Based Routing Rules:                              │
                    │   ┌───────────────────────────────────────────────────┐  │
                    │   │  app.localhost        → web-frontend:9092         │  │
                    │   │  api.localhost        → backend-server:9091       │  │
                    │   │  argocd.localhost     → argocd-server:443         │  │
                    │   │  grafana.localhost    → grafana:80                │  │
                    │   │  radar.localhost      → radar:9280                │  │
                    │   │  perses.localhost     → perses:8080               │  │
                    │   │  opensearch.localhost → opensearch-dashboards:5601│  │
                    │   └───────────────────────────────────────────────────┘  │
                    └────────────────────┬────────────────────────────────────┘
                                         │
                    ┌────────────────────┼────────────────────────────────────┐
                    │                    │     K8S CLUSTER                     │
                    │    ┌───────────────┼───────────────────────┐            │
                    │    │               ▼                       │            │
                    │    │  ┌──────────────────────────────┐    │            │
                    │    │  │   web-frontend (ClusterIP)    │    │            │
                    │    │  │   port: 9092 → pod:8080       │    │            │
                    │    │  └──────────────────────────────┘    │            │
                    │    │                                       │            │
                    │    │  ┌──────────────────────────────┐    │            │
                    │    │  │   backend-server (ClusterIP)  │    │            │
                    │    │  │   port: 9091 → pod:9091       │    │            │
                    │    │  └──────────────────────────────┘    │            │
                    │    │                                       │            │
                    │    │  ┌──────────────────────────────┐    │            │
                    │    │  │   argocd-server (ClusterIP)   │    │            │
                    │    │  │   port: 443 → pod:8080        │    │            │
                    │    │  └──────────────────────────────┘    │            │
                    │    │                                       │            │
                    │    │  ┌──────────────────────────────┐    │            │
                    │    │  │   grafana (ClusterIP)         │    │            │
                    │    │  │   port: 80 → pod:3000         │    │            │
                    │    │  └──────────────────────────────┘    │            │
                    │    └──────────────────────────────────────┘            │
                    └────────────────────────────────────────────────────────┘
```

## Why Host-Based Routing?

| | Path-Based (`/api`, `/web`) | Host-Based (`api.localhost`, `app.localhost`) |
|---|---|---|
| **Clean URLs** | Apps must know their prefix | Apps serve from `/` naturally |
| **No middleware** | Needs strip-prefix middleware | No path rewriting needed |
| **Isolation** | Shared cookie domain | Separate cookie domains |
| **CORS** | Same origin | Cross-origin (explicit CORS) |
| **Production parity** | Uncommon in prod | Matches real-world subdomains |

## The Key Components

### 1. External Load Balancer (k3d LB container)

Created by this line in `scripts/run.sh`:
```bash
k3d cluster create dev --port '80:80@loadbalancer'
```

This maps host port `80` → container port `80` on the k3d load balancer. The LB container is a simple TCP/HTTP proxy that forwards all traffic into the cluster's Traefik ingress.

### 2. DNS Resolution (`.localhost` domains)

On macOS, all `*.localhost` domains resolve to `127.0.0.1` automatically (RFC 6761). No `/etc/hosts` editing needed.

### 3. Ingress Controller (Traefik)

Traefik is the Layer 7 router that inspects the `Host` header to decide where traffic goes. It reads Kubernetes `Ingress` resources to build its routing table.

### 4. Ingress Resources (per app)

Each app declares its hostname via an `Ingress` object:

```yaml
# Example: web-frontend ingress config
ingress:
  enabled: true
  className: traefik
  hosts:
    - host: app.localhost
      paths:
        - path: /
          pathType: Prefix
```

---

## How to Add a New App Behind the Same IP

Say you want to add a `payments-service` accessible at `http://payments.localhost`:

### Step 1: Create the Helm chart

```
charts/payments-service/
├── Chart.yaml
├── values.yaml
└── templates/
    ├── deployment.yaml
    ├── service.yaml
    └── ingress.yaml
```

### Step 2: Define the ingress in values

```yaml
# charts/payments-service/values.yaml
ingress:
  enabled: false
  className: ""
  hosts:
    - host: chart-example.local
      paths:
        - path: /
          pathType: Prefix
```

### Step 3: Create the ArgoCD Application with ingress overrides

```yaml
# apps/dev/4-apps/payments-service.yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: dev-payments-service
  namespace: argocd
  annotations:
    argocd.argoproj.io/sync-wave: "4"
spec:
  project: default
  sources:
    - repoURL: https://github.com/nyo-infra-study/infrastructure.git
      targetRevision: main
      path: charts/payments-service
      helm:
        releaseName: dev-payments-service
        valuesObject:
          ingress:
            enabled: true
            className: traefik
            hosts:
              - host: payments.localhost
                paths:
                  - path: /
                    pathType: Prefix
  destination:
    server: "https://kubernetes.default.svc"
    namespace: dev
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
```

### Step 4: Push to main → ArgoCD deploys it automatically

Now `http://payments.localhost` routes to your new service. No path stripping, no middleware, no conflicts.

---

## Current Service Map

| Hostname | Service | Namespace | Internal Port |
|----------|---------|-----------|---------------|
| `app.localhost` | web-frontend | dev | 9092 |
| `api.localhost` | backend-server | dev | 9091 |
| `argocd.localhost` | argocd-server | argocd | 443 |
| `grafana.localhost` | grafana | monitoring | 80 |
| `radar.localhost` | radar | monitoring | 9280 |
| `perses.localhost` | perses | monitoring | 8080 |
| `opensearch.localhost` | opensearch-dashboards | monitoring | 5601 |

---

## Production Equivalent

In production, the same pattern applies but the "external gateway" is a cloud load balancer with real DNS:

```
┌──────────────────────────────────────────────────────────────┐
│  PUBLIC IP: 203.0.113.50                                      │
│  (AWS ALB / GCP LB / Azure LB / Cloudflare)                  │
└──────────────────────┬───────────────────────────────────────┘
                       │
                       ▼
┌──────────────────────────────────────────────────────────────┐
│  INGRESS CONTROLLER (Traefik / Nginx / Envoy / Istio)         │
│                                                               │
│  Rules:                                                       │
│    app.example.com       → frontend-service:80                │
│    api.example.com       → backend-service:8080               │
│    payments.example.com  → payments-service:8080              │
│    admin.example.com     → admin-dashboard:3000               │
│    grafana.example.com   → grafana:80                         │
└──────────────────────────────────────────────────────────────┘
```

The only differences from local:
- k3d LB container → Cloud Load Balancer (ALB/NLB/GLB)
- `*.localhost` → real domain with DNS wildcard (`*.example.com → LB IP`)
- Port 80 → Port 443 (HTTPS with TLS termination at the LB or ingress)

---

## Troubleshooting

### "Connection refused" on macOS

Port 80 may require elevated privileges or conflict with existing services:
```bash
# Check if something else is using port 80
sudo lsof -i :80

# If AirPlay Receiver is using it, disable in System Settings → General → AirDrop & Handoff
```

### Browser not resolving `*.localhost`

All modern browsers support `*.localhost` → `127.0.0.1` (RFC 6761). If it doesn't work:
```bash
# Verify DNS resolution
dig app.localhost

# Fallback: add to /etc/hosts
echo "127.0.0.1 app.localhost api.localhost argocd.localhost" | sudo tee -a /etc/hosts
```

### CORS issues between `app.localhost` and `api.localhost`

Since these are different origins, the backend needs CORS headers:
```go
// Backend must allow cross-origin requests from the frontend
w.Header().Set("Access-Control-Allow-Origin", "http://app.localhost")
w.Header().Set("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
w.Header().Set("Access-Control-Allow-Headers", "Content-Type, Authorization")
```

Or configure it at the ingress level with Traefik middleware.
