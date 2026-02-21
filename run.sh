#!/bin/bash
set -e

# ============================================================
# Infrastructure Deployment Script
# ============================================================
# Usage: ./run.sh [-vvv]
# ============================================================

# --- Configuration ---
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
ENV_FILE="$SCRIPT_DIR/config.env"
EXAMPLE_FILE="$SCRIPT_DIR/config.env.example"

# Default verbose to false
VERBOSE=false

# Check for -vvv flag
if [[ "$1" == "-vvv" ]]; then
    VERBOSE=true
fi

# Function to log steps
log_step() {
    echo "============================================================"
    echo "STEP: $1"
    echo "============================================================"
}

# Function to run commands
run() {
    local cmd="$@"
    if [ "$VERBOSE" = true ]; then
        echo "Running: $cmd"
        eval "$cmd"
    else
        # Run silently, but show output on error
        OUTPUT=$(eval "$cmd" 2>&1)
        EXIT_CODE=$?
        if [ $EXIT_CODE -ne 0 ]; then
            echo "Error running command: $cmd"
            echo "$OUTPUT"
            exit $EXIT_CODE
        fi
    fi
}

# --- Load Environment ---
if [ ! -f "$ENV_FILE" ]; then
    echo "⚠️  Configuration file not found: $ENV_FILE"
    echo "Using default values from $EXAMPLE_FILE..."
    if [ -f "$EXAMPLE_FILE" ]; then
        # Load from example if no config provided (for demo purposes)
        if [ "$VERBOSE" = true ]; then echo "Loading defaults from $EXAMPLE_FILE"; fi
        source "$EXAMPLE_FILE"
    else
        echo "❌ Error: Neither config.env nor config.env.example found."
        exit 1
    fi
else
    if [ "$VERBOSE" = true ]; then echo "Loading configuration from $ENV_FILE"; fi
    source "$ENV_FILE"
fi

# --- Validate Required Variables ---
: "${GITHUB_TOKEN:?Variable GITHUB_TOKEN not set}"
: "${DOCKER_USERNAME:?Variable DOCKER_USERNAME not set}"
: "${DOCKER_PASSWORD:?Variable DOCKER_PASSWORD not set}"
: "${POSTGRES_PASSWORD:?Variable POSTGRES_PASSWORD not set}"

# --- OS Detection & Docker Check ---
# Detect based on OS unless overridden
if [ -z "$DOCKER_RUNTIME" ]; then
    if [[ "$OSTYPE" == "darwin"* ]]; then
        DOCKER_RUNTIME="colima"
    else
        DOCKER_RUNTIME="docker"
    fi
fi

log_step "Checking Environment ($DOCKER_RUNTIME)"

if [ "$DOCKER_RUNTIME" == "colima" ]; then
    if ! command -v colima &> /dev/null; then
        echo "❌ Error: colima is not installed."
        exit 1
    fi
    # Check if colima is running
    log_step "Starting Colima (if needed)"
    colima status >/dev/null 2>&1 || run "colima start --cpu 4 --memory 8"
elif [ "$DOCKER_RUNTIME" == "docker" ]; then
    if ! docker info >/dev/null 2>&1; then
        echo "❌ Error: Docker daemon is not running. Please start Docker."
        exit 1
    fi
    log_step "Docker daemon is running."
else
    echo "⚠️ Unknown runtime '$DOCKER_RUNTIME', proceeding assuming Docker is available..."
fi


log_step "Recreating k3d Cluster"
run "k3d cluster delete dev || true"
sleep 5

# Cilium replaces Traefik (ingress), kube-proxy (eBPF), Flannel (CNI) and network policies.
# All four must be disabled in k3s so Cilium can take full ownership.
# Port mapping: 9000 on Mac → NodePort 30080 on server node (ArgoCD Server).
run "k3d cluster create dev \
  --port '9000:30080@server:0' \
  --k3s-arg '--disable=traefik@server:0' \
  --k3s-arg '--disable-kube-proxy@server:0' \
  --k3s-arg '--flannel-backend=none@server:0' \
  --k3s-arg '--disable-network-policy@server:0'"

log_step "Adding Helm Repositories"
run "helm repo add argo https://argoproj.github.io/argo-helm"
run "helm repo add cilium https://helm.cilium.io/"
run "helm repo update"

# ============================================================
# BOOTSTRAP CILIUM FIRST (before ArgoCD)
# ============================================================
# Because Flannel is disabled (--flannel-backend=none), the cluster has
# NO CNI at all after creation. Without a CNI, pods cannot communicate
# and ArgoCD's pre-install Jobs (argocd-redis-secret-init) will time out.
#
# Fix: install Cilium via Helm directly to provide the CNI, THEN install
# ArgoCD. After ArgoCD is up, apps/dev/cilium.yaml hands management of
# the Cilium Helm release over to ArgoCD (it will upgrade in-place).
# ============================================================

log_step "Bootstrapping Cilium CNI (before ArgoCD)"
# k3d assigns a dynamic docker bridge IP to the API server (e.g. 172.18.0.3:6443).
# This IP changes every cluster creation, so we detect it at runtime.
# 10.43.0.1 (k3s service ClusterIP) does NOT work because kube-proxy is disabled
# and Cilium hasn't set up eBPF routing yet at this point.
K8S_HOST=$(kubectl get endpointslices -l kubernetes.io/service-name=kubernetes -n default -o jsonpath='{.items[0].endpoints[0].addresses[0]}')
K8S_PORT=$(kubectl get endpointslices -l kubernetes.io/service-name=kubernetes -n default -o jsonpath='{.items[0].ports[0].port}')
echo "  Detected API server: https://${K8S_HOST}:${K8S_PORT}"

run "helm install cilium cilium/cilium \
  --version 1.16.6 \
  --namespace kube-system \
  -f '$SCRIPT_DIR/platform/cilium/values.yaml' \
  --set k8sServiceHost=${K8S_HOST} \
  --set k8sServicePort=${K8S_PORT}"

log_step "Waiting for Cilium (bootstrap)"
# cilium status --wait understands Cilium's internal readiness (agents, controllers, etc.)
# much more reliable than kubectl rollout status for CNI readiness.
run "cilium status --wait --wait-duration 5m0s"
echo "✅ Cilium CNI is ready — cluster networking is up"

log_step "Patching CoreDNS (Bypass Colima DNS)"
# Colima's DNS proxy (192.168.5.2) drops SNATed UDP packets from Cilium.
# We patch CoreDNS to forward directly to 8.8.8.8 to ensure cluster egress DNS works.
run "kubectl get cm coredns -n kube-system -o yaml | sed 's/forward . \/etc\/resolv.conf/forward . 8.8.8.8/' | kubectl apply -f -"
run "kubectl rollout restart deployment coredns -n kube-system"
run "kubectl rollout status deployment/coredns -n kube-system --timeout=60s"

log_step "Installing ArgoCD"
# Cilium CNI is running — pods can now communicate, ArgoCD install will succeed.
run "helm install argocd argo/argo-cd \
  --namespace argocd \
  --create-namespace \
  -f '$SCRIPT_DIR/platform/argocd/values.yaml'"

log_step "Waiting for ArgoCD"
run "kubectl wait --for=condition=available deployment/argocd-server -n argocd --timeout=300s"
run "kubectl -n argocd rollout status deployment argocd-server"

log_step "Installing Argo Workflows"
run "kubectl create namespace argo"
# Using --server-side to handle large CRDs
run "kubectl apply -n argo -f https://github.com/argoproj/argo-workflows/releases/download/v4.0.0/install.yaml --server-side"

log_step "Waiting for Argo Workflows"
run "kubectl -n argo rollout status deployment/argo-server"
run "kubectl -n argo rollout status deployment/workflow-controller"

log_step "Installing Argo Events"
run "kubectl create namespace argo-events"
run "kubectl apply -f https://raw.githubusercontent.com/argoproj/argo-events/stable/manifests/install.yaml"
# Install EventBus (NATS for event transport)
run "kubectl apply -n argo -f https://raw.githubusercontent.com/argoproj/argo-events/stable/examples/eventbus/native.yaml"

log_step "Waiting for Argo Events"
run "kubectl -n argo-events rollout status deployment/controller-manager"

log_step "Configuring Secrets"
# GitHub Access Token
run "kubectl create secret generic github-access \
  -n argo \
  --from-literal=token='$GITHUB_TOKEN'"

# Docker Registry Credentials
# Note: Creating generic secret for flexibility or docker-registry type if needed by Argo
run "kubectl create secret docker-registry docker-credentials \
  --docker-server='$DOCKER_REGISTRY_SERVER' \
  --docker-username='$DOCKER_USERNAME' \
  --docker-password='$DOCKER_PASSWORD' \
  --docker-email='$DOCKER_EMAIL' \
  -n argo"

log_step "Initializing Dev Environment"
# Create namespace early (ArgoCD might do it, but we need it for secrets)
run "kubectl create namespace dev || true"

# Initialize Database Secret (Required for backend-db)
run "kubectl create secret generic backend-db-secret \
  --namespace dev \
  --from-literal=POSTGRES_PASSWORD='$POSTGRES_PASSWORD'"

log_step "Initializing Monitoring Environment"
run "kubectl create namespace monitoring || true"
run "kubectl create secret generic grafana-auth -n monitoring \
  --from-literal=admin-user='$GRAFANA_ADMIN_USER' \
  --from-literal=admin-password='$GRAFANA_ADMIN_PASSWORD'"

log_step "Patcing ArgoCD Admin Password (Resetting)"
# Resetting ArgoCD password removes the initial secret and restarts the server
if [ "$VERBOSE" = true ]; then
    kubectl patch secret argocd-secret -p '{"data": {"admin.password": null, "admin.passwordMtime": null}}' -n argocd && \
    kubectl delete secret argocd-initial-admin-secret -n argocd && \
    kubectl rollout restart deployment argocd-server -n argocd && \
    echo "Waiting for restart..." && \
    sleep 30 && \
    kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 --decode
    echo ""
else
    echo "Resetting ArgoCD admin password..."
    OUTPUT=$(kubectl patch secret argocd-secret -p '{"data": {"admin.password": null, "admin.passwordMtime": null}}' -n argocd 2>&1 && \
    kubectl delete secret argocd-initial-admin-secret -n argocd 2>&1 && \
    kubectl rollout restart deployment argocd-server -n argocd 2>&1 && \
    sleep 30 && \
    kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 --decode)
    echo "ArgoCD Password: $OUTPUT"
fi

log_step "Deploying App of Apps"
# bootstrap/dev.yaml creates all child Applications including apps/dev/cilium.yaml.
# ArgoCD will adopt the existing Cilium Helm release (same name+namespace)
# and manage upgrades going forward. Sync wave -10 ensures Cilium is
# reconciled first before other apps.
run "kubectl apply -f '$SCRIPT_DIR/bootstrap/dev.yaml'"

log_step "Done! Cluster is ready."
