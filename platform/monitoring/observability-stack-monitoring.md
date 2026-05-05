# Observability Stack Monitoring — Dashboard Widgets

Guide for building a OneUptime dashboard to monitor the monitoring stack itself.
Use these widgets to understand resource usage, detect OOM/throttle issues, and
decide when to enable more metric sources.

---

## 1. OTel Collector Health

Metrics from the `otel-collector-self` service.

| Widget | Metric | Type | Purpose |
|--------|--------|------|---------|
| Collector CPU | `otelcol_process_cpu_seconds_total` | Rate/Line | Is the collector under CPU pressure? |
| Collector Memory (RSS) | `otelcol_process_memory_rss_bytes` | Line | Memory trend — approaching limit? |
| Metrics Received | `otelcol_receiver_accepted_metric_points_total` | Rate/Line | Ingest throughput per receiver |
| Metrics Exported | `otelcol_exporter_sent_metric_points_total` | Rate/Line | Export throughput — should match received |
| Metrics Dropped | `otelcol_exporter_send_failed_metric_points_total` | Rate/Line | Non-zero = export failures |
| Spans Received | `otelcol_receiver_accepted_spans_total` | Rate/Line | Trace ingest rate |
| Spans Exported | `otelcol_exporter_sent_spans_total` | Rate/Line | Trace export rate |
| Logs Received | `otelcol_receiver_accepted_log_records_total` | Rate/Line | Log ingest rate |
| Batch Send Size | `otelcol_processor_batch_batch_send_size` | Line | Are batches filling up or timing out? |
| Queue Length | `otelcol_exporter_queue_size` | Line | Backpressure indicator |
| Filter Drop Ratio | `otelcol_processor_filter_datapoints_filtered_ratio_total` | Counter | How much is being filtered out |

---

## 2. Container Resource Usage (cAdvisor)

Metrics from `prometheus/cadvisor`. Filter by `namespace="monitoring"`.

| Widget | Metric | Type | Purpose |
|--------|--------|------|---------|
| CPU Usage by Pod | `container_cpu_usage_seconds_total` | Rate/Stacked | Which pod eats the most CPU |
| Memory Usage by Pod | `container_memory_working_set_bytes` | Line/Stacked | Actual memory (what OOM killer looks at) |
| OOM Kill Events | `container_oom_events_total` | Counter/Table | Any pod getting OOM killed? |
| CPU Throttle Rate | `container_cpu_cfs_throttled_periods_total / container_cpu_cfs_periods_total` | Line (%) | % of periods throttled — >25% means limit too low |
| CPU Throttled Periods | `container_cpu_cfs_throttled_periods_total` | Rate/Line | Raw throttle count per pod |

---

## 3. Resource Requests vs Actual Usage (KSM + cAdvisor)

Compare what's allocated vs what's actually used. Key for right-sizing.

| Widget | Metric(s) | Type | Purpose |
|--------|-----------|------|---------|
| Memory: Usage vs Request | `container_memory_working_set_bytes` vs `kube_pod_container_resource_requests{resource="memory"}` | Dual-line per pod | Over-provisioned? Under-provisioned? |
| CPU: Usage vs Request | `rate(container_cpu_usage_seconds_total)` vs `kube_pod_container_resource_requests{resource="cpu"}` | Dual-line per pod | CPU headroom or starvation |
| Memory: Usage vs Limit | `container_memory_working_set_bytes` vs `kube_pod_container_resource_limits{resource="memory"}` | Dual-line per pod | How close to OOM? |
| CPU: Usage vs Limit | `rate(container_cpu_usage_seconds_total)` vs `kube_pod_container_resource_limits{resource="cpu"}` | Dual-line per pod | How close to throttle ceiling? |

---

## 4. Pod Health (KSM)

| Widget | Metric | Type | Purpose |
|--------|--------|------|---------|
| Pod Restarts | `kube_pod_container_status_restarts_total` | Counter/Table | Frequent restarts = crash loop |
| Last Termination Reason | `kube_pod_container_status_last_terminated_reason` | Table | OOMKilled? Error? Evicted? |
| Pod Phase | `kube_pod_status_phase` | Table/Status | How many Running vs Pending vs Failed |
| Container Waiting Reason | `kube_container_status_waiting_reason` | Table | CrashLoopBackOff? ImagePullBackOff? |

---

## 5. Suggested Dashboard Layout

```
┌─────────────────────────────────────────────────────────────┐
│ Row 1: Overview                                             │
│ [Total Metrics/s] [Total Spans/s] [Total Logs/s] [OOM Count]│
├─────────────────────────────────────────────────────────────┤
│ Row 2: Collector Internals                                  │
│ [Collector CPU] [Collector Memory] [Queue Length]            │
├─────────────────────────────────────────────────────────────┤
│ Row 3: Resource Usage                                       │
│ [CPU by Pod - stacked] [Memory by Pod - stacked]            │
├─────────────────────────────────────────────────────────────┤
│ Row 4: Usage vs Requests                                    │
│ [CPU usage vs request] [Memory usage vs request]            │
├─────────────────────────────────────────────────────────────┤
│ Row 5: Throttle & OOM                                       │
│ [CPU Throttle %] [OOM Events] [Pod Restarts]                │
├─────────────────────────────────────────────────────────────┤
│ Row 6: Pod Health Table                                     │
│ [Pod | Status | Restarts | Last Terminated Reason]          │
└─────────────────────────────────────────────────────────────┘
```

---

## 6. Key Alerts to Set Up

| Alert | Condition | Severity |
|-------|-----------|----------|
| Collector export failures | `otelcol_exporter_send_failed_metric_points_total > 0` for 5m | Warning |
| OOM Kill detected | `increase(container_oom_events_total[5m]) > 0` | Critical |
| High CPU throttle | Throttle ratio > 50% for 5m | Warning |
| Memory near limit | `working_set_bytes / limit > 0.85` for 5m | Warning |
| Pod crash loop | `increase(restarts_total[10m]) > 3` | Critical |
| Collector queue backing up | `otelcol_exporter_queue_size > 100` for 2m | Warning |

---

## Notes

- All cAdvisor/KSM metrics are filtered to only the allowlisted set in the collector config.
- The collector scrapes itself, cAdvisor, and KSM every 30s.
- VPA is managing resource requests automatically — the "usage vs request" widgets will show VPA's effectiveness over time.
- If you enable more sources (kubelet, node-exporter, filelog), watch the collector's CPU/memory widgets first to gauge impact.
