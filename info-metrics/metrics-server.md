# metrics-server — Metric Filter Decisions

> Version: 3.8.3
> Docs: https://github.com/kubernetes-sigs/metrics-server
> Generated from: `output/*/parsed/metrics-server.csv`

---

| Use | Reason | metric_name | metric_type | description |
| --- | --- | --- | --- | --- |
| ✅ | Core — detect slow kubelet scrapes that delay HPA decisions | `metrics_server_kubelet_request_duration_seconds` | Histogram | Duration of requests to Kubelet API in seconds |
| ✅ | Core — request rate and error rate baseline | `metrics_server_kubelet_request_total` | Counter | Number of requests sent to Kubelet API |
| ✅ | Core — detect stale kubelet data | `metrics_server_kubelet_last_request_time_seconds` | Gauge | Time of last request performed to Kubelet API since unix epoch in seconds |
| ✅ | Core — API data staleness, alert if metrics are too old | `metrics_server_api_metric_freshness_seconds` | Histogram | Freshness of metrics exported |
