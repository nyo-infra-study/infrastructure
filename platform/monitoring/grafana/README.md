# Grafana (Unified)

Single Grafana deployment, independent of any backend. Swap datasources by overlaying a file.

## File Layout

```
grafana/
├── grafana-base-values.yaml           # Shared: resources, ingress, sidecar, plugins
├── datasources-gigapipe.yaml          # Datasources for Gigapipe/ClickHouse backend
├── datasources-victoriametrics.yaml   # Datasources for VictoriaMetrics backend
├── datasources-lgtm.yaml             # Datasources for Prometheus + Loki + Tempo
├── vpa.yaml                           # VerticalPodAutoscaler for Grafana
└── dashboards/                        # Dashboard JSON files + kustomization.yaml
```

## Usage

Pick ONE datasource file to overlay on top of the base:

```bash
# Gigapipe backend
helm upgrade --install dev-grafana grafana/grafana \
  -n monitoring \
  -f grafana-base-values.yaml \
  -f datasources-gigapipe.yaml

# VictoriaMetrics backend
helm upgrade --install dev-grafana grafana/grafana \
  -n monitoring \
  -f grafana-base-values.yaml \
  -f datasources-victoriametrics.yaml

# LGTM backend (Prometheus + Loki + Tempo)
helm upgrade --install dev-grafana grafana/grafana \
  -n monitoring \
  -f grafana-base-values.yaml \
  -f datasources-lgtm.yaml
```

## Dashboards

Dashboards are provisioned via ConfigMaps (kustomize generates them from JSON files).
Apply separately:

```bash
kubectl apply -k dashboards/
```

## Migration from old folders

The old `grafana-gigapipe/`, `grafana-lgtm/`, `grafana-clickhouse/` folders are deprecated.
Backend services (Loki, Prometheus, Tempo) moved to `../lgtm/`.
