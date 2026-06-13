# descheduler — Metric Filter Decisions

> Version: 0.32.2
> Docs: https://github.com/kubernetes-sigs/descheduler/blob/v0.32.2/metrics/metrics.go
> Generated from: `output/*/parsed/descheduler.csv`

---

| Use | Reason | metric_name | metric_type | description |
| --- | --- | --- | --- | --- |
| ✅ | Core — track eviction activity, alert on unexpected evictions | `descheduler_pods_evicted` | Counter | Number of evicted pods, by the result, by the strategy, by the namespace, by ... |
| ✅ | Version tracking | `descheduler_build_info` | Gauge | Build info about descheduler, including Go version, Descheduler version, Git ... |
| ✅ | Core — detect slow descheduling cycles | `descheduler_descheduler_loop_duration_seconds` | Histogram | Time taken to complete a full descheduling cycle |
| ✅ | Core — identify slow strategies | `descheduler_descheduler_strategy_duration_seconds` | Histogram | Time taken to complete Each strategy of the descheduling operation |
