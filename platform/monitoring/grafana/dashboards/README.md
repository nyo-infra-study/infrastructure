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

Visualizes the OTel Collector pipeline: Receivers → Filter → Gigapipe + Discarded.

Uses the `netsage-sankey-panel` plugin for a Sankey flow diagram showing scrape volume,
filter pass-through, and discard volume.

**Critical: Never use `instant: true` with `format: table` in this dashboard.**

Instant queries break ALL panel types (Sankey, bar chart, stat, gauge) because
Prometheus instant vectors with mixed label sets produce sparse tables that Grafana
panels can't parse. Use `range: true` with `groupBy` transformations or `reduceOptions`
instead.

See [full analysis](../../docs/monitoring/gigapipe/PIPELINE-FLOW-DASHBOARD.md) for:
- Root cause: how Grafana serializes instant vectors with heterogeneous labels
- Per-panel-type symptoms and failure modes
- The fix pattern for each panel type
- Correct filter efficiency metrics (`processor_incoming` vs `processor_outgoing`)

