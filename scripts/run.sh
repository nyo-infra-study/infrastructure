#!/bin/bash
set -e

# ============================================================
# Infrastructure Deployment Script
# ============================================================
# Usage: ./run.sh [-vvv]
# ============================================================

# --- Configuration ---
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
ENV_FILE="$REPO_ROOT/config.env"
EXAMPLE_FILE="$REPO_ROOT/config.example.env"

# Default verbose to false
VERBOSE=false

# Check for -vvv flag
if [[ "$1" == "-vvv" ]]; then
    VERBOSE=true
fi

# --- Colors ---
C_RESET="\033[0m"
C_BOLD="\033[1m"
C_DIM="\033[2m"
C_CYAN="\033[36m"
C_GREEN="\033[32m"
C_RED="\033[31m"
C_YELLOW="\033[33m"

# Function to log steps — always visible, bold cyan
log_step() {
    echo ""
    printf "${C_BOLD}${C_CYAN}━━━ %s${C_RESET}\n" "$1"
}

# Function to run commands
run() {
    local cmd="$@"
    if [ "$VERBOSE" = true ]; then
        printf "${C_DIM}  ▶ %s${C_RESET}\n" "$cmd"
        eval "$cmd" 2>&1 | sed "s/^/$(printf "${C_DIM}")  /;s/$/$(printf "${C_RESET}")/"
        local exit_code=${PIPESTATUS[0]}
        if [ $exit_code -ne 0 ]; then
            printf "${C_RED}  ✗ Command failed (exit %d)${C_RESET}\n" "$exit_code"
            exit $exit_code
        fi
    else
        OUTPUT=$(eval "$cmd" 2>&1)
        EXIT_CODE=$?
        if [ $EXIT_CODE -ne 0 ]; then
            printf "${C_RED}Error running: %s${C_RESET}\n" "$cmd"
            echo "$OUTPUT"
            exit $EXIT_CODE
        fi
    fi
}

# --- Load Environment ---
if [ ! -f "$ENV_FILE" ]; then
    printf "${C_YELLOW}⚠️  Configuration file not found: %s${C_RESET}\n" "$ENV_FILE"
    printf "${C_DIM}  Using defaults from %s${C_RESET}\n" "$EXAMPLE_FILE"
    if [ -f "$EXAMPLE_FILE" ]; then
        source "$EXAMPLE_FILE"
    else
        printf "${C_RED}❌ Error: Neither config.env nor config.example.env found.${C_RESET}\n"
        exit 1
    fi
else
    if [ "$VERBOSE" = true ]; then printf "${C_DIM}  Loading: %s${C_RESET}\n" "$ENV_FILE"; fi
    source "$ENV_FILE"
fi

# --- Validate Required Variables ---
: "${GITHUB_TOKEN:?Variable GITHUB_TOKEN not set}"
: "${DOCKER_USERNAME:?Variable DOCKER_USERNAME not set}"
: "${DOCKER_PASSWORD:?Variable DOCKER_PASSWORD not set}"
: "${POSTGRES_PASSWORD:?Variable POSTGRES_PASSWORD not set}"

# --- OS Detection & Docker Check ---
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
        printf "${C_RED}❌ Error: colima is not installed.${C_RESET}\n"
        exit 1
    fi
    log_step "Starting Colima (if needed)"
    colima status >/dev/null 2>&1 || run "colima start --cpu 6 --memory 10"
elif [ "$DOCKER_RUNTIME" == "docker" ]; then
    if ! docker info >/dev/null 2>&1; then
        printf "${C_RED}❌ Error: Docker daemon is not running.${C_RESET}\n"
        exit 1
    fi
else
    printf "${C_YELLOW}⚠️ Unknown runtime '%s', proceeding...${C_RESET}\n" "$DOCKER_RUNTIME"
fi

log_step "Recreating k3d Cluster"
run "k3d cluster delete dev || true"
sleep 10
run "k3d cluster create dev --port '80:80@loadbalancer'"
printf "${C_DIM}  Waiting for API server to stabilize...${C_RESET}\n"
sleep 20
run "kubectl wait --for=condition=Ready nodes --all --timeout=60s"
run "kubectl wait --for=jsonpath='{.metadata.name}'=default serviceaccount/default --timeout=60s"

log_step "Pre-caching container images"
IMAGE_LIST="$REPO_ROOT/image-list.txt"
if [ -f "$IMAGE_LIST" ]; then
    IMAGES=()
    while IFS= read -r line; do
        line=$(echo "$line" | sed 's/#.*//' | xargs)
        [ -z "$line" ] && continue
        IMAGES+=("$line")
    done < "$IMAGE_LIST"

    printf "${C_DIM}  Pulling %d images...${C_RESET}\n" "${#IMAGES[@]}"

    # Detect platform for single-arch pulls (fixes ctr import on ARM64/M1)
    PLATFORM=$(docker info --format '{{.OSArch}}' 2>/dev/null | sed 's|/|/|') # e.g. linux/arm64
    PLATFORM="${PLATFORM:-linux/arm64}"

    PULLED=()
    for img in "${IMAGES[@]}"; do
        if [ "$VERBOSE" = true ]; then
            printf "${C_DIM}  Pulling: %s${C_RESET}\n" "$img"
        fi
        if docker pull --platform "$PLATFORM" "$img" >/dev/null 2>&1; then
            PULLED+=("$img")
        else
            printf "${C_YELLOW}  ⚠️  Skipped (not found): %s${C_RESET}\n" "$img"
        fi
    done

    if [ ${#PULLED[@]} -gt 0 ]; then
        printf "${C_DIM}  Importing %d images into k3d node...${C_RESET}\n" "${#PULLED[@]}"
        IMPORTED=0
        FAILED_IMPORTS=()
        for img in "${PULLED[@]}"; do
            if [ "$VERBOSE" = true ]; then
                printf "${C_DIM}  Importing: %s${C_RESET}\n" "$img"
            fi
            if docker save "$img" | docker exec -i k3d-dev-server-0 ctr --namespace k8s.io images import - >/dev/null 2>&1; then
                IMPORTED=$((IMPORTED + 1))
            else
                # Fallback: pull directly inside the k3d node (handles OCI index images)
                if docker exec k3d-dev-server-0 crictl pull "$img" >/dev/null 2>&1; then
                    IMPORTED=$((IMPORTED + 1))
                    if [ "$VERBOSE" = true ]; then
                        printf "${C_DIM}  (pulled inside node): %s${C_RESET}\n" "$img"
                    fi
                else
                    printf "${C_RED}  ❌ Failed to import: %s${C_RESET}\n" "$img"
                    FAILED_IMPORTS+=("$img")
                fi
            fi
        done

        printf "${C_DIM}  Verifying images in k3d cluster...${C_RESET}\n"
        AVAILABLE=$(docker exec k3d-dev-server-0 crictl images -o json 2>/dev/null \
            | python3 -c "import sys,json; imgs=json.load(sys.stdin).get('images',[]); [print(t) for i in imgs for t in i.get('repoTags',[])]" 2>/dev/null)

        VERIFIED=0
        MISSING=()
        for img in "${PULLED[@]}"; do
            IMG_NAME=$(echo "$img" | sed 's|^docker.io/||')
            if echo "$AVAILABLE" | grep -q "$IMG_NAME"; then
                VERIFIED=$((VERIFIED + 1))
            else
                MISSING+=("$img")
            fi
        done

        if [ ${#MISSING[@]} -gt 0 ]; then
            printf "${C_YELLOW}  ⚠️  %d image(s) not verified (will pull from network)${C_RESET}\n" "${#MISSING[@]}"
        fi
        printf "${C_GREEN}  ✅ %d/%d images verified in k3d cluster.${C_RESET}\n" "$VERIFIED" "${#PULLED[@]}"

        if [ ${#FAILED_IMPORTS[@]} -gt 0 ]; then
            printf "${C_YELLOW}  ⚠️  %d image(s) failed to import (will pull from network during deploy).${C_RESET}\n" "${#FAILED_IMPORTS[@]}"
        fi
    fi
else
    printf "${C_YELLOW}  ⚠️  No image-list.txt found, skipping pre-cache.${C_RESET}\n"
fi

log_step "Tuning local-path provisioner"
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

ARGOCD_CHART_VERSION=$(grep 'targetRevision:' "$REPO_ROOT/apps/dev/0-platform/argocd.yaml" | head -1 | awk '{print $2}')
printf "${C_DIM}  Chart version: %s${C_RESET}\n" "$ARGOCD_CHART_VERSION"

run "helm install argocd argo/argo-cd \
  --namespace argocd \
  --create-namespace \
  --version '$ARGOCD_CHART_VERSION' \
  -f '$REPO_ROOT/platform/argocd/values.yaml'"

log_step "Waiting for ArgoCD"
run "kubectl wait --for=condition=available deployment/argocd-server -n argocd --timeout=300s"
run "kubectl -n argocd rollout status deployment argocd-server"

log_step "Configuring Secrets"
run "kubectl create namespace argo || true"
run "kubectl create secret generic github-access \
  -n argo \
  --from-literal=token='$GITHUB_TOKEN'"

log_step "Initializing Dev Environment"
run "kubectl create namespace dev || true"
run "kubectl create secret generic backend-db-secret \
  --namespace dev \
  --from-literal=POSTGRES_PASSWORD='$POSTGRES_PASSWORD'"

log_step "Initializing Monitoring Environment"
run "kubectl create namespace monitoring || true"

log_step "Resetting ArgoCD Admin Password"
if [ "$VERBOSE" = true ]; then
    run "kubectl patch secret argocd-secret -p '{\"data\": {\"admin.password\": null, \"admin.passwordMtime\": null}}' -n argocd"
    run "kubectl delete secret argocd-initial-admin-secret -n argocd"
    run "kubectl rollout restart deployment argocd-server -n argocd"
    printf "${C_DIM}  Waiting 30s for restart...${C_RESET}\n"
    sleep 30
    ARGOCD_PW=$(kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 --decode)
    printf "${C_GREEN}  Password: %s${C_RESET}\n" "$ARGOCD_PW"
else
    kubectl patch secret argocd-secret -p '{"data": {"admin.password": null, "admin.passwordMtime": null}}' -n argocd >/dev/null 2>&1
    kubectl delete secret argocd-initial-admin-secret -n argocd >/dev/null 2>&1
    kubectl rollout restart deployment argocd-server -n argocd >/dev/null 2>&1
    sleep 30
    ARGOCD_PW=$(kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" 2>/dev/null | base64 --decode 2>/dev/null || echo "unavailable")
fi

log_step "Deploying App of Apps"
run "kubectl apply -f '$REPO_ROOT/bootstrap/dev.yaml'"

log_step "Waiting for ArgoCD to be fully ready"
run "kubectl wait --for=condition=available deployment/argocd-server -n argocd --timeout=120s"
run "kubectl wait --for=condition=available deployment/argocd-repo-server -n argocd --timeout=120s"
run "kubectl wait --for=condition=ready pod -l app.kubernetes.io/component=application-controller -n argocd --timeout=120s"

log_step "Done! Cluster is ready."
echo ""
printf "${C_GREEN}  ArgoCD UI:    http://argocd.localhost${C_RESET}\n"
printf "${C_GREEN}  Frontend:     http://app.localhost${C_RESET}\n"
printf "${C_GREEN}  Backend API:  http://api.localhost${C_RESET}\n"
printf "${C_GREEN}  Radar:        http://radar.localhost${C_RESET}\n"
printf "${C_GREEN}  Grafana:      http://grafana.localhost (admin/admin)${C_RESET}\n"
echo ""
printf "  ArgoCD Password: ${C_BOLD}${C_YELLOW}%s${C_RESET}\n" "${ARGOCD_PW:-$(kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath='{.data.password}' 2>/dev/null | base64 --decode 2>/dev/null || echo 'see above')}"
echo ""
