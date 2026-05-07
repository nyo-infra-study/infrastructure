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
    colima status >/dev/null 2>&1 || run "colima start --cpu 6 --memory 10"
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
sleep 10
# OneUptime needs port 80 because its frontend generates URLs without a port.
# Other apps (ArgoCD, backend, frontend) continue using localhost:9000.
run "k3d cluster create dev --port '9000:80@loadbalancer' --port '80:80@loadbalancer'"
echo "Waiting for API server to stabilize..."
sleep 20
run "kubectl wait --for=condition=Ready nodes --all --timeout=60s"
# Wait for default service account to ensure namespace controller is up
run "kubectl wait --for=jsonpath='{.metadata.name}'=default serviceaccount/default --timeout=60s"

log_step "Pre-caching container images"
# Read image list from image-list.txt (skip comments and blank lines),
# pull via Docker (cached in Colima VM across cluster recreations),
# then pipe directly into containerd inside the k3d node.
# This bypasses k3d's built-in import which has digest bugs on ARM64/M1.
IMAGE_LIST="$SCRIPT_DIR/image-list.txt"
if [ -f "$IMAGE_LIST" ]; then
    IMAGES=()
    while IFS= read -r line; do
        # Skip comments and blank lines
        line=$(echo "$line" | sed 's/#.*//' | xargs)
        [ -z "$line" ] && continue
        IMAGES+=("$line")
    done < "$IMAGE_LIST"

    echo "Pulling ${#IMAGES[@]} images (cached locally, skips already-pulled)..."
    PULLED=()
    for img in "${IMAGES[@]}"; do
        if [ "$VERBOSE" = true ]; then
            echo "  Pulling: $img"
        fi
        if eval "docker pull '$img'" 2>/dev/null; then
            PULLED+=("$img")
        else
            echo "  ⚠️  Skipped (not found): $img"
        fi
    done

    if [ ${#PULLED[@]} -gt 0 ]; then
        echo "Importing ${#PULLED[@]} images into k3d node via ctr..."
        IMPORTED=0
        FAILED_IMPORTS=()
        for img in "${PULLED[@]}"; do
            if [ "$VERBOSE" = true ]; then
                echo "  Importing: $img"
            fi
            if docker save "$img" | docker exec -i k3d-dev-server-0 ctr --namespace k8s.io images import - >/dev/null 2>&1; then
                IMPORTED=$((IMPORTED + 1))
            else
                echo "  ❌ Failed to import: $img"
                FAILED_IMPORTS+=("$img")
            fi
        done

        # Verify images are available inside the cluster
        echo "Verifying images in k3d cluster..."
        AVAILABLE=$(docker exec k3d-dev-server-0 crictl images -o json 2>/dev/null \
            | python3 -c "import sys,json; imgs=json.load(sys.stdin).get('images',[]); [print(t) for i in imgs for t in i.get('repoTags',[])]" 2>/dev/null)

        VERIFIED=0
        MISSING=()
        for img in "${PULLED[@]}"; do
            # crictl normalizes names (e.g. redis:7 → docker.io/library/redis:7)
            # so check if the image name appears anywhere in the tag list
            IMG_NAME=$(echo "$img" | sed 's|^docker.io/||')
            if echo "$AVAILABLE" | grep -q "$IMG_NAME"; then
                VERIFIED=$((VERIFIED + 1))
            else
                MISSING+=("$img")
            fi
        done

        if [ ${#MISSING[@]} -gt 0 ]; then
            echo "  ⚠️  ${#MISSING[@]} image(s) not verified in cluster: ${MISSING[*]}"
            echo "  These will be pulled from the network during deployment."
        fi
        echo "✅ ${VERIFIED}/${#PULLED[@]} images verified in k3d cluster."

        if [ ${#FAILED_IMPORTS[@]} -gt 0 ]; then
            echo "⚠️  ${#FAILED_IMPORTS[@]} image(s) failed to import (possible disk space issue)."
            echo "  Run 'docker system prune -a --volumes -f' to free space and retry."
        fi
    fi
else
    echo "⚠️  No image-list.txt found, skipping pre-cache."
fi

log_step "Tuning local-path provisioner"
# Increase helper pod timeout from 120s (default) to 300s.
# On a loaded node, image pulls saturate the runtime and the helper pod
# can't start within the default window.
PATCH_FILE=$(mktemp)
cat > "$PATCH_FILE" <<'PATCH'
data:
  config.json: |
    {
      "nodePathMap": [
        {
          "node": "DEFAULT_PATH_FOR_NON_LISTED_NODES",
          "paths": ["/var/lib/rancher/k3s/storage"]
        }
      ],
      "cmdTimeoutSeconds": 300
    }
PATCH
run "kubectl patch configmap local-path-config -n kube-system --type merge --patch-file '$PATCH_FILE'"
rm -f "$PATCH_FILE"

run "kubectl rollout restart deployment/local-path-provisioner -n kube-system"
run "kubectl rollout status deployment/local-path-provisioner -n kube-system --timeout=60s"

log_step "Installing ArgoCD"
run "helm repo add argo https://argoproj.github.io/argo-helm"
run "helm repo add cowboysysop https://cowboysysop.github.io/charts"
run "helm repo update"

# Read ArgoCD chart version from the app manifest (single source of truth)
ARGOCD_CHART_VERSION=$(grep 'targetRevision:' "$SCRIPT_DIR/apps/dev/0-platform/argocd.yaml" | head -1 | awk '{print $2}')
echo "Installing ArgoCD chart version: $ARGOCD_CHART_VERSION"

run "helm install argocd argo/argo-cd \
  --namespace argocd \
  --create-namespace \
  --version '$ARGOCD_CHART_VERSION' \
  -f '$SCRIPT_DIR/platform/argocd/values.yaml'"

log_step "Waiting for ArgoCD"
run "kubectl wait --for=condition=available deployment/argocd-server -n argocd --timeout=300s"
run "kubectl -n argocd rollout status deployment argocd-server"

# --- Argo Workflows (DISABLED — frontend build not needed locally) ---
# log_step "Installing Argo Workflows"
# run "kubectl create namespace argo || true"
# run "kubectl apply -n argo -f https://github.com/argoproj/argo-workflows/releases/download/v4.0.0/install.yaml --server-side --force-conflicts"

# log_step "Waiting for Argo Workflows"
# run "kubectl -n argo rollout status deployment/argo-server"
# run "kubectl -n argo rollout status deployment/workflow-controller"

# log_step "Installing Argo Events"
# run "kubectl create namespace argo-events"
# run "kubectl apply -f https://raw.githubusercontent.com/argoproj/argo-events/stable/manifests/install.yaml"
# run "kubectl apply -n argo -f https://raw.githubusercontent.com/argoproj/argo-events/stable/examples/eventbus/native.yaml"

# log_step "Waiting for Argo Events"
# run "kubectl -n argo-events rollout status deployment/controller-manager"

log_step "Configuring Secrets"
# GitHub Access Token (still needed for ArgoCD private repo access)
run "kubectl create namespace argo || true"
run "kubectl create secret generic github-access \
  -n argo \
  --from-literal=token='$GITHUB_TOKEN'"

# --- Docker Registry Credentials (DISABLED — frontend build not needed locally) ---
# run "kubectl create secret docker-registry docker-credentials \
#   --docker-server='$DOCKER_REGISTRY_SERVER' \
#   --docker-username='$DOCKER_USERNAME' \
#   --docker-password='$DOCKER_PASSWORD' \
#   --docker-email='$DOCKER_EMAIL' \
#   -n argo"

log_step "Initializing Dev Environment"
# Create namespace early (ArgoCD might do it, but we need it for secrets)
run "kubectl create namespace dev || true"

# Initialize Database Secret (Required for backend-db)
run "kubectl create secret generic backend-db-secret \
  --namespace dev \
  --from-literal=POSTGRES_PASSWORD='$POSTGRES_PASSWORD'"

log_step "Initializing Monitoring Environment"
run "kubectl create namespace monitoring || true"


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
run "kubectl apply -f '$SCRIPT_DIR/bootstrap/dev.yaml'"

log_step "Waiting for ArgoCD to be fully ready"
# After password reset, ArgoCD restarts. Wait for it to stabilize
# before declaring the cluster ready, so users don't see errors.
run "kubectl wait --for=condition=available deployment/argocd-server -n argocd --timeout=120s"
run "kubectl wait --for=condition=available deployment/argocd-repo-server -n argocd --timeout=120s"
run "kubectl wait --for=condition=ready pod -l app.kubernetes.io/component=application-controller -n argocd --timeout=120s"

log_step "Done! Cluster is ready."
echo ""
echo "  ArgoCD UI:    http://localhost:9000/argocd"
echo "  Frontend:     http://localhost:9000/web"
echo "  Backend API:  http://localhost:9000/api"
echo "  Radar:        http://radar.localhost"
echo "  ClickStack:   http://clickstack.localhost"
echo ""
echo "  ArgoCD Password: $(kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath='{.data.password}' 2>/dev/null | base64 --decode 2>/dev/null || echo 'see previous output')"
echo ""
