# Platform Infrastructure

This directory contains platform-level infrastructure and tooling that is **shared across all environments** (dev, staging, production).

## Contents

- **argocd/** - ArgoCD configuration and ingress
  - `values.yaml` - Helm values for ArgoCD server configuration
  - `ingress.yaml` - Ingress resource for ArgoCD UI access

## Why Platform?

Platform resources differ from application resources because they:

- Are environment-agnostic (same config for dev/staging/prod)
- Provide foundational services (GitOps, monitoring, logging, etc.)
- Are managed separately from application deployments
