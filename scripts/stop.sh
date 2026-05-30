#!/bin/bash
set -e

# ============================================================
# Infrastructure Teardown Script
# ============================================================
# Usage: ./stop.sh [options]
#
# Options:
#   (none)        Delete the k3d dev cluster only
#   --prune       Delete cluster + stop Colima (frees CPU/memory)
#   --prune-all   Delete cluster + delete Colima VM entirely (wipes all data)
#   -vvv          Verbose output
# ============================================================

# --- Configuration ---
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

VERBOSE=false
PRUNE=false
PRUNE_ALL=false

# --- Parse Arguments ---
for arg in "$@"; do
    case $arg in
        -vvv)       VERBOSE=true ;;
        --prune)    PRUNE=true ;;
        --prune-all) PRUNE_ALL=true; PRUNE=true ;;
    esac
done

# --- Helpers ---
log_step() {
    echo "============================================================"
    echo "STEP: $1"
    echo "============================================================"
}

run() {
    local cmd="$@"
    if [ "$VERBOSE" = true ]; then
        echo "Running: $cmd"
        eval "$cmd"
    else
        OUTPUT=$(eval "$cmd" 2>&1)
        EXIT_CODE=$?
        if [ $EXIT_CODE -ne 0 ]; then
            echo "Error running command: $cmd"
            echo "$OUTPUT"
            exit $EXIT_CODE
        fi
    fi
}

# --- OS Detection ---
if [ -z "$DOCKER_RUNTIME" ]; then
    if [[ "$OSTYPE" == "darwin"* ]]; then
        DOCKER_RUNTIME="colima"
    else
        DOCKER_RUNTIME="docker"
    fi
fi

# --- Teardown ---
log_step "Deleting k3d Cluster (dev)"
run "k3d cluster delete dev || true"

log_step "Removing k3d Docker volumes"
K3D_VOLUMES=$(docker volume ls -q --filter name=k3d-dev 2>/dev/null || true)
if [ -n "$K3D_VOLUMES" ]; then
    run "docker volume rm $K3D_VOLUMES"
    echo "Removed k3d volumes: $K3D_VOLUMES"
else
    echo "No k3d volumes found."
fi

if [ "$PRUNE_ALL" = true ]; then
    log_step "Deleting Colima VM (removes all data)"
    if command -v colima &> /dev/null; then
        run "colima stop || true"
        run "colima delete --force || true"
        echo "Colima VM deleted. All container/volume data has been wiped."
    else
        echo "⚠️  colima not found, skipping."
    fi

    log_step "Pruning Docker (all images, build cache, volumes)"
    run "docker system prune -a --volumes -f || true"
    echo "Docker fully pruned. All images, build cache, and volumes removed."
elif [ "$PRUNE" = true ]; then
    log_step "Stopping Colima (frees CPU/memory, data preserved)"
    if command -v colima &> /dev/null; then
        if colima status >/dev/null 2>&1; then
            run "colima stop"
            echo "Colima stopped. Data is preserved."
        else
            echo "Colima is not running, nothing to stop."
        fi
    else
        echo "⚠️  colima not found, skipping."
    fi

    log_step "Pruning Docker (dangling images only — tagged images cached)"
    run "docker image prune -f || true"
    run "docker builder prune -f || true"
    echo "Dangling images + build cache removed. Tagged images preserved for faster next start."
fi

log_step "Done!"
if [ "$PRUNE_ALL" = true ]; then
    echo "Cluster deleted + Colima VM wiped."
elif [ "$PRUNE" = true ]; then
    echo "Cluster deleted + Colima stopped."
else
    echo "Cluster deleted. Run './stop.sh --prune' to also stop Colima, or '--prune-all' to delete all Colima data."
fi
