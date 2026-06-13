# clickhouse-operator — Metric Filter Decisions

> Version: 0.25.2
> Docs: https://github.com/Altinity/clickhouse-operator/blob/0.25.2/pkg/controller/chi/metrics/metrics.go
> Generated from: `output/*/parsed/clickhouse-operator.csv`

---

| Use | Reason | metric_name | description |
| --- | --- | --- | --- |
| ✅ | Core, reconciliation rate | `clickhouse_operator_chi_reconciles_started` | number of CHI reconciles started |
| ✅ | Core, compare with started for error rate | `clickhouse_operator_chi_reconciles_completed` | number of CHI reconciles completed successfully |
| ✅ | Core, alert on aborted reconciles | `clickhouse_operator_chi_reconciles_aborted` | number of CHI reconciles aborted |
| ✅ | Core, detect slow reconciliation | `clickhouse_operator_chi_reconciles_timings` | timings of CHI reconciles completed successfully |
| ✅ | Inventory, track ClickHouse installations | `clickhouse_operator_chi` | number of CHI available |
| ✅ | Core, per-host reconciliation rate | `clickhouse_operator_host_reconciles_started` | number of host reconciles started |
| ✅ | Core | `clickhouse_operator_host_reconciles_completed` | number of host reconciles completed successfully |
| ✅ | Core, alert on unexpected restarts | `clickhouse_operator_host_reconciles_restarts` | number of host restarts during reconciles |
| ✅ | Core, alert on errors | `clickhouse_operator_host_reconciles_errors` | number of host reconciles errors |
| ✅ | Core, detect slow host operations | `clickhouse_operator_host_reconciles_timings` | timings of host reconciles completed successfully |
| ❌ | Niche, K8s event detail | `clickhouse_operator_pod_add_events` | number PodAdd events |
| ❌ | Niche, K8s event detail | `clickhouse_operator_pod_update_events` | number PodUpdate events |
| ❌ | Niche, K8s event detail | `clickhouse_operator_pod_delete_events` | number PodDelete events |
