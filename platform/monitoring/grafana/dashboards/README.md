# Grafana Dashboards

Organized by backend. Flip which sets are active in `kustomization.yaml`.

## Folder Structure

```
dashboards/
├── kustomization.yaml       # Top-level — comment/uncomment to flip sets
├── shared/                  # Backend-agnostic (PromQL, always on)
│   ├── argocd.json
│   ├── kubernetes.json
│   ├── node.json
│   └── pipeline-flow.json
├── gigapipe/                # Gigapipe-specific (Loki/Tempo/Prometheus UIDs)
│   ├── clickhouse.json      # ClickHouse metrics via Gigapipe's Prometheus API
│   └── monitoring-meta.json # Monitoring pipeline health
├── clickhouse/              # ClickHouse native (grafana-clickhouse-datasource)
│   ├── backend-server.json
│   ├── clickhouse---cluster-analysis.json
│   ├── clickhouse---data-analysis.json
│   ├── clickhouse---query-analysis.json
│   ├── infrastructure-overview.json
│   └── simple-clickhouse-otel-dashboard.json
└── victoriametrics/         # (future) VM-specific dashboards
```

## How to Flip

Edit `kustomization.yaml`:

```yaml
resources:
  - shared/          # Always on
  - gigapipe/        # ← active backend
  # - clickhouse/    # ← commented out
```

Switch to ClickHouse native:

```yaml
resources:
  - shared/
  # - gigapipe/
  - clickhouse/      # ← now active
```

## Adding a New Dashboard

1. Drop the `.json` file in the appropriate subfolder
2. Add a `configMapGenerator` entry in that folder's `kustomization.yaml`
3. Apply: `kubectl apply -k .`

## Dashboard-Specific Notes

### Pipeline Flow (`shared/pipeline-flow.json`)

Visualizes the OTel Collector pipeline volumes using bar charts and stat panels.
Shows per-receiver scrape volume, filter efficiency, and per-processor drop rates.

Previously used a Sankey diagram but replaced with bar charts because the discard
volume (~75%) dominated the flow making receiver bands unreadable, and with only
one exporter (gigapipe) there was no meaningful branching to visualize.

**Critical: Never use `instant: true` with `format: table` in this dashboard.**

Instant queries break ALL panel types (bar chart, stat, gauge) because Prometheus
instant vectors with mixed label sets produce sparse tables that Grafana panels
can't parse. Use `range: true` with `groupBy` transformations or `reduceOptions`
instead.

See [full analysis](../../docs/monitoring/gigapipe/PIPELINE-FLOW-DASHBOARD.md) for details.

