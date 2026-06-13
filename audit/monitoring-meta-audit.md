# Monitoring Stack Dashboard - Metrics Audit

**Dashboard:** Monitoring Stack (`monitoring-meta`)  
**Audit Date:** 2025-06-13  
**Validated Against:** Local Grafana MCP  
**Status:** ✅ All issues resolved

---

## Summary

| Category | Count |
|----------|-------|
| Total Panels with Queries | 44 |
| ✅ Correct | 44 |
| ⚠️ Minor Issues | 0 |
| ❌ Incorrect | 0 |

---

## Issues Found and Fixed

### Issue 1: Panel 4 (① Scraped) - Misleading title ❌→✅

**Panel:** ① Scraped (raw/s) → ① Scraped (samples)  
**Problem:** Title said "raw/s" implying a rate, but `scrape_samples_scraped` is a gauge showing samples per scrape, not a rate.  
**Evidence:** `scrape_samples_scraped` is a gauge (confirmed via pipeline-flow audit)

**Fix:** 
- Changed title from "① Scraped (raw/s)" to "① Scraped (samples)"
- Added description: "Total samples scraped per scrape from selected jobs. This is a gauge showing samples per scrape, not a rate."

### Issue 2: Panel 7 (Scrape Filter) - Wrong calculation ❌→✅

**Panel:** Scrape Filter (gauge)  
**Problem:** Expression compared `rate(otelcol_receiver_accepted_metric_points_total)` (pts/s) with `scrape_samples_scraped` (samples/scrape) - comparing different units!

**Old Expression:**
```promql
1 - (sum(rate(otelcol_receiver_accepted_metric_points_total{...}[5m])) / sum(scrape_samples_scraped{job=~"$job"}))
```

**Fix:** Changed to compare two gauges from the same scrape cycle:
```promql
clamp_min(1 - (sum(scrape_samples_post_metric_relabeling{job=~"$job"}) / sum(scrape_samples_scraped{job=~"$job"})), 0)
```

**Rationale:** `scrape_samples_scraped` and `scrape_samples_post_metric_relabeling` are both gauges from the same Prometheus scrape cycle, making them directly comparable.

### Issue 3: Hardcoded [5m] rate intervals ⚠️→✅

**Problem:** Several panels used hardcoded `[5m]` instead of `$__rate_interval`.

**Panels fixed:**
- Panel 5 (② Stored): `rate(...[5m])` → `rate(...[$__rate_interval])`
- Panel 77 (Processor Filter): `rate(...[5m])` → `rate(...[$__rate_interval])`
- Panel 6 (③ Queried): `rate(...[5m])` → `rate(...[$__rate_interval])`
- Panel 23 (CH — Queries/s): `rate(...[5m])` → `rate(...[$__rate_interval])`
- Panel 24 (CH — Inserted Rows/s): `rate(...[5m])` → `rate(...[$__rate_interval])`

---

## Panel-by-Panel Audit

### Section: Summary

#### Panel 73: Monitoring Stack (text)
- **Type:** text
- **Content:** Flow diagram and legend explanation
- **Audit:** ✅ **CORRECT** - Informational text, no queries

#### Panels 63-72: CPU/Memory Summary Grid
- **Type:** timeseries (10 panels)
- **Components:** OTel, Writer, Readers, CH, Grafana (CPU + Mem each)
- **Expressions:**
  - CPU: `avg(rate(container_cpu_usage_seconds_total{...}[$__rate_interval]))` ✅
  - Mem: `avg(container_memory_working_set_bytes{...})` ✅
  - Requests/Limits: `kube_pod_container_resource_*` ✅
- **Audit:** ✅ **CORRECT** - All use correct metrics and `$__rate_interval`

---

### Section: Pipeline Overview

#### Panel 2: Data Volume by Signal
- **Type:** marcusolsson-treemap-panel
- **Expression:** `sum by (namespace, service) (sent_bytes_total{job=~"$instance"})`
- **Query Type:** instant (appropriate for treemap)
- **Audit:** ✅ **CORRECT**

#### Panel 3: Component Health
- **Type:** grafana-polystat-panel
- **Expression:** `up{job=~"otel-collector|clickhouse|gigapipe.*"}`
- **Query Type:** instant (appropriate for health status)
- **Audit:** ✅ **CORRECT**

#### Panel 4: ① Scraped (samples)
- **Type:** stat
- **Description:** Total samples scraped per scrape from selected jobs.
- **Expression:** `sum(scrape_samples_scraped{job=~"$job"})`
- **Metric Used:** `scrape_samples_scraped` (gauge) ✅
- **Audit:** ✅ **CORRECT** (after fix)

#### Panel 7: Scrape Filter
- **Type:** gauge
- **Description:** How much Prometheus metric_relabel_configs drops at scrape time.
- **Expression:** `clamp_min(1 - (sum(scrape_samples_post_metric_relabeling{...}) / sum(scrape_samples_scraped{...})), 0)`
- **Metrics Used:**
  - `scrape_samples_scraped` (gauge) ✅
  - `scrape_samples_post_metric_relabeling` (gauge) ✅
- **Audit:** ✅ **CORRECT** (after fix) - Both gauges from same scrape cycle

#### Panel 5: ② Stored (rate/s)
- **Type:** stat
- **Description:** Metric points exported by OTel Collector to Gigapipe per second.
- **Expression:** `sum(rate(otelcol_exporter_sent_metric_points_total{...}[$__rate_interval]))`
- **Audit:** ✅ **CORRECT** (after fix)

#### Panel 77: Processor Filter
- **Type:** gauge
- **Description:** How much OTel processor filters drop.
- **Expression:** `clamp_min(1 - (sum(rate(otelcol_exporter_sent_metric_points_total{...}[$__rate_interval])) / sum(rate(otelcol_receiver_accepted_metric_points_total{...}[$__rate_interval]))), 0)`
- **Audit:** ✅ **CORRECT** (after fix) - Both use rate() consistently

#### Panel 6: ③ Queried (queries/s)
- **Type:** stat
- **Description:** ClickHouse SELECT queries per second.
- **Expression:** `rate(ClickHouseProfileEvents_SelectQuery_total{...}[$__rate_interval])`
- **Audit:** ✅ **CORRECT** (after fix)

#### Panel 8: CH Active Parts
- **Type:** stat
- **Expression:** `ClickHouseMetrics_PartsActive{job="clickhouse"}`
- **Audit:** ✅ **CORRECT** - Gauge, no rate needed

#### Panel 9: CH Memory
- **Type:** stat
- **Expression:** `ClickHouseMetrics_MemoryTracking{job="clickhouse"}`
- **Audit:** ✅ **CORRECT** - Gauge, no rate needed

---

### Section: OTel Collector

#### Panel 11: OTel — Exported by Signal
- **Type:** timeseries
- **Expressions:**
  - `rate(otelcol_exporter_sent_metric_points_total{...}[$__rate_interval])` ✅
  - `rate(otelcol_exporter_sent_log_records_total{...}[$__rate_interval])` ✅
  - `rate(otelcol_exporter_sent_spans_total{...}[$__rate_interval])` ✅
- **Audit:** ✅ **CORRECT**

#### Panel 12: OTel — Failed & Dropped
- **Type:** timeseries
- **Expressions:** `rate(otelcol_exporter_send_failed_*_total{...}[$__rate_interval])` ✅
- **Audit:** ✅ **CORRECT**

#### Panel 13: OTel — Queue Usage %
- **Type:** timeseries
- **Expression:** `max by (exporter) (otelcol_exporter_queue_size / otelcol_exporter_queue_capacity)`
- **Audit:** ✅ **CORRECT** - Ratio of gauges

#### Panel 14: OTel — Data Dropped by Filter
- **Type:** timeseries
- **Expression:** `sum by (processor) (rate(incoming_items_total) - rate(outgoing_items_total)) > 0`
- **Audit:** ✅ **CORRECT**

#### Panels 57-58: OTel CPU/Memory
- **Type:** timeseries
- **Audit:** ✅ **CORRECT** - Same pattern as Summary section

---

### Section: Gigapipe

#### Panel 17: Gigapipe — Rows Written/s
- **Type:** timeseries
- **Expression:** `rate(sent_rows_total{job=~"$instance"}[$__rate_interval])`
- **Audit:** ✅ **CORRECT**

#### Panel 18: Gigapipe — Bytes Written/s
- **Type:** timeseries
- **Expression:** `rate(sent_bytes_total{job=~"$instance"}[$__rate_interval])`
- **Audit:** ✅ **CORRECT**

#### Panel 19: Gigapipe — Send Time (ms)
- **Type:** timeseries
- **Expression:** `rate(send_time_ms_sum) / rate(send_time_ms_count)`
- **Audit:** ✅ **CORRECT** - Standard histogram average calculation

#### Panel 20: Gigapipe — Memory (RSS)
- **Type:** timeseries
- **Expression:** `process_resident_memory_bytes{job=~"$instance"}`
- **Audit:** ✅ **CORRECT** - Gauge

#### Panel 21: Gigapipe — Connection Resets
- **Type:** timeseries
- **Expression:** `rate(connection_reset_by_peer_count_total{...}[$__rate_interval])`
- **Audit:** ✅ **CORRECT**

#### Panels 59-62: Writer/Readers CPU/Memory
- **Type:** timeseries
- **Audit:** ✅ **CORRECT** - Same pattern as Summary section

---

### Section: ClickHouse (Summary)

#### Panel 23: CH — Queries/s
- **Type:** timeseries
- **Expressions:**
  - `rate(ClickHouseProfileEvents_SelectQuery_total{...}[$__rate_interval])` ✅
  - `rate(ClickHouseProfileEvents_InsertQuery_total{...}[$__rate_interval])` ✅
- **Audit:** ✅ **CORRECT** (after fix)

#### Panel 24: CH — Inserted Rows/s
- **Type:** timeseries
- **Expression:** `rate(ClickHouseProfileEvents_InsertedRows_total{...}[$__rate_interval])`
- **Audit:** ✅ **CORRECT** (after fix)

#### Panel 25: CH — Active Parts & Merges
- **Type:** timeseries
- **Expressions:**
  - `ClickHouseMetrics_PartsActive` (gauge) ✅
  - `ClickHouseMetrics_Merge` (gauge) ✅
- **Audit:** ✅ **CORRECT**

#### Panel 26: CH — Memory & Disk I/O
- **Type:** timeseries
- **Expression:** `ClickHouseMetrics_MemoryTracking` (gauge)
- **Audit:** ✅ **CORRECT**

#### Panel 27: CH — Failed Queries/s
- **Type:** timeseries
- **Expressions:**
  - `rate(ClickHouseProfileEvents_FailedSelectQuery_total[$__rate_interval])` ✅
  - `rate(ClickHouseProfileEvents_FailedInsertQuery_total[$__rate_interval])` ✅
- **Audit:** ✅ **CORRECT**

#### Panel 74: CH — Recent Failed Queries
- **Type:** table (ClickHouse SQL)
- **Query:** SQL against system.query_log
- **Audit:** ✅ **CORRECT** - Direct ClickHouse query

#### Panels 47-48: CH CPU/Memory
- **Type:** timeseries
- **Audit:** ✅ **CORRECT**

---

### Section: PCI Log Sanity Check

#### Panel 29: PCI Log Lines
- **Type:** stat (Loki)
- **Expression:** `sum(count_over_time({compliance_scope="pci"}[$__range]))`
- **Audit:** ✅ **CORRECT** - Uses `$__range` for full dashboard range

#### Panel 30: Non-PCI Log Lines
- **Type:** stat (Loki)
- **Expression:** `sum(count_over_time({compliance_scope!="pci",compliance_scope!=""}[$__range]))`
- **Audit:** ✅ **CORRECT**

#### Panel 31: PCI Filter Status
- **Type:** stat (Loki)
- **Description:** PASS if selected Loki datasource correctly hides PCI logs.
- **Audit:** ✅ **CORRECT** - Compliance validation panel

---

## Metrics Reference

| Metric | Type | Source | Description |
|--------|------|--------|-------------|
| `scrape_samples_scraped` | gauge | Prometheus | Raw samples per scrape before relabeling |
| `scrape_samples_post_metric_relabeling` | gauge | Prometheus | Samples after metric_relabel_configs |
| `otelcol_receiver_accepted_metric_points_total` | counter | OTel | Metric points accepted by receivers |
| `otelcol_exporter_sent_metric_points_total` | counter | OTel | Metric points exported |
| `otelcol_exporter_queue_size` | gauge | OTel | Current queue size |
| `otelcol_exporter_queue_capacity` | gauge | OTel | Queue capacity |
| `container_cpu_usage_seconds_total` | counter | cAdvisor | Container CPU usage |
| `container_memory_working_set_bytes` | gauge | cAdvisor | Container memory usage |
| `kube_pod_container_resource_requests` | gauge | kube-state-metrics | Pod resource requests |
| `kube_pod_container_resource_limits` | gauge | kube-state-metrics | Pod resource limits |
| `sent_rows_total` | counter | Gigapipe | Rows written to ClickHouse |
| `sent_bytes_total` | counter | Gigapipe | Bytes written to ClickHouse |
| `send_time_ms_sum/count` | histogram | Gigapipe | Send time histogram |
| `ClickHouseMetrics_*` | gauge | ClickHouse | Current state metrics |
| `ClickHouseProfileEvents_*_total` | counter | ClickHouse | Cumulative event counters |
