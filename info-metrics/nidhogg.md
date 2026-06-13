# nidhogg — Metric Filter Decisions

> Version: 0.8.1
> Docs: https://github.com/pelotech/nidhogg/blob/v0.8.1/go.mod
> Generated from: `output/*/parsed/nidhogg.csv`

---

| Use | Reason | metric_name | metric_type | description |
| --- | --- | --- | --- | --- |
| ✅ | Core, reconciliation rate | `controller_runtime_reconcile_total` | Counter | Total number of reconciliations per controller |
| ✅ | Core, alert on errors | `controller_runtime_reconcile_errors_total` | Counter | Total number of reconciliation errors per controller |
| ✅ | Core — permanent failures | `controller_runtime_terminal_reconcile_errors_total` | Counter | Total number of terminal reconciliation errors per controller |
| ✅ | Core — any panic means instability | `controller_runtime_reconcile_panics_total` | Counter | Total number of reconciliation panics per controller |
| ✅ | Core, detect slow reconciles | `controller_runtime_reconcile_time_seconds` | Histogram | Length of time per reconciliation per controller |
| ❌ | Static config value | `controller_runtime_max_concurrent_reconciles` | Gauge | Maximum number of concurrent reconciles per controller |
| ❌ | Niche for such a small controller | `controller_runtime_active_workers` | Gauge | Number of currently used workers per controller |
