# Pipeline Flow Dashboard - Metrics Audit

**Dashboard:** Pipeline Flow (`pipeline-flow`)  
**Audit Date:** 2025-06-13  
**Validated Against:** Local Grafana MCP  
**Status:** ✅ All issues resolved

---

## Summary

| Category | Count |
|----------|-------|
| Total Panels with Queries | 15 |
| ✅ Correct | 15 |
| ⚠️ Minor Issues | 0 |
| ❌ Incorrect | 0 |

---

## Panel-by-Panel Audit

### Section: Metrics Pipeline Flow

#### Panel 5: ① Raw Scraped by Job (samples)
- **Type:** barchart
- **Description:** Total samples scraped from each job BEFORE scrape-level metric_relabel_configs. This is the raw volume from targets.
- **Expression:** `sum by (job) (scrape_samples_scraped)`
- **Metric Used:** `scrape_samples_scraped` (gauge - samples per scrape)
- **Audit:** ✅ **CORRECT**
  - Title correctly says "samples" (not "samples/s")
  - `scrape_samples_scraped` is a gauge showing samples per scrape

---

#### Panel 6: ② After Scrape Filter by Receiver (pts/s)
- **Type:** barchart
- **Description:** Metric points accepted by OTel Prometheus receivers (after Prometheus metric_relabel_configs, before OTel processor filters).
- **Expression:** `sum by (receiver) (rate(otelcol_receiver_accepted_metric_points_total{service_name="otel-collector", receiver=~"prometheus.*"}[$__rate_interval]))`
- **Metric Used:** `otelcol_receiver_accepted_metric_points_total`
- **Audit:** ✅ **CORRECT**
  - Query filters to `receiver=~"prometheus.*"` only
  - Correctly compares with Panel 5 (Prometheus scrape → Prometheus receivers)

---

#### Panel 7: ③ After Processor Filter (pts/s)
- **Type:** barchart
- **Description:** Final output of OTel processor filters: what reaches Gigapipe vs what gets discarded.
- **Expression:** 
  ```promql
  label_replace(sum(rate(otelcol_exporter_sent_metric_points_total{...}[...])), "outcome", "→ gigapipe", "", "") 
  or 
  label_replace(clamp_min(sum(rate(otelcol_receiver_accepted_metric_points_total{...}[...])) - sum(rate(otelcol_exporter_sent_metric_points_total{...}[...])), 0), "outcome", "→ discarded", "", "")
  ```
- **Metrics Used:** 
  - `otelcol_exporter_sent_metric_points_total` (exported to Gigapipe)
  - `otelcol_receiver_accepted_metric_points_total` (received by OTel)
- **Audit:** ✅ **CORRECT**
  - Gigapipe = exporter sent metric points
  - Discarded = received - sent
  - `clamp_min(..., 0)` handles timing edge cases

---

### Section: Filter Efficiency

#### Panel 10: Scrape Filter Efficiency (Metrics)
- **Type:** gauge
- **Description:** How much Prometheus metric_relabel_configs drops at scrape time. Compares raw scraped samples vs samples after relabeling.
- **Expression:** `clamp_min(1 - (sum(scrape_samples_post_metric_relabeling) / sum(scrape_samples_scraped)), 0)`
- **Metrics Used:**
  - `scrape_samples_scraped` (raw samples - gauge)
  - `scrape_samples_post_metric_relabeling` (after relabeling - gauge)
- **Audit:** ✅ **CORRECT**
  - Both metrics are gauges from the same scrape cycle
  - Directly comparable: `1 - (after/before)` = drop percentage

---

#### Panel 11: Processor Filter Efficiency (Metrics)
- **Type:** gauge
- **Description:** How much OTel processor filters drop. Compares what enters processors vs what gets exported.
- **Expression:** `clamp_min(1 - (sum(rate(otelcol_exporter_sent_metric_points_total{...}[...])) / sum(rate(otelcol_receiver_accepted_metric_points_total{...}[...]))), 0)`
- **Metrics Used:**
  - `otelcol_receiver_accepted_metric_points_total` (into processors)
  - `otelcol_exporter_sent_metric_points_total` (out of processors)
- **Audit:** ✅ **CORRECT**
  - `1 - (exported/received)` = processor drop percentage
  - Both use `rate()` consistently

---

#### Panel 12: Total Raw Scraped (Metrics)
- **Type:** stat
- **Description:** Sum of all raw samples scraped from all targets (before any filtering).
- **Expression:** `sum(scrape_samples_scraped)`
- **Metric Used:** `scrape_samples_scraped`
- **Audit:** ✅ **CORRECT**

---

#### Panel 13: Into OTel (Metrics pts/s)
- **Type:** stat
- **Description:** Metric points accepted by all OTel receivers (Prometheus, OTLP, etc.).
- **Expression:** `sum(rate(otelcol_receiver_accepted_metric_points_total{...}[$__rate_interval]))`
- **Metric Used:** `otelcol_receiver_accepted_metric_points_total`
- **Audit:** ✅ **CORRECT**
  - Description accurately reflects all receivers

---

#### Panel 14: Exported (Metrics pts/s)
- **Type:** stat
- **Description:** Metric points exported to Gigapipe (after processor filter).
- **Expression:** `sum(rate(otelcol_exporter_sent_metric_points_total{...}[$__rate_interval]))`
- **Metric Used:** `otelcol_exporter_sent_metric_points_total`
- **Audit:** ✅ **CORRECT**

---

### Section: Volume by Signal Type

#### Panel 18: Logs Received vs Exported (count/s)
- **Type:** stat
- **Expressions:**
  - A: `sum(rate(otelcol_receiver_accepted_log_records_total{...}[$__rate_interval]))`
  - B: `sum(rate(otelcol_exporter_sent_log_records_total{...}[$__rate_interval]))`
- **Audit:** ✅ **CORRECT**

---

#### Panel 19: Metrics Received vs Exported (count/s)
- **Type:** stat
- **Expressions:**
  - A: `sum(rate(otelcol_receiver_accepted_metric_points_total{...}[$__rate_interval]))`
  - B: `sum(rate(otelcol_exporter_sent_metric_points_total{...}[$__rate_interval]))`
- **Audit:** ✅ **CORRECT**

---

#### Panel 20: Traces Received vs Exported (count/s)
- **Type:** stat
- **Expressions:**
  - A: `sum(rate(otelcol_receiver_accepted_spans_total{...}[$__rate_interval]))`
  - B: `sum(rate(otelcol_exporter_sent_spans_total{...}[$__rate_interval]))`
- **Audit:** ✅ **CORRECT**

---

#### Panel 22: Logs Bytes (N/A)
- **Type:** stat
- **Description:** Logs bytes not available from gigapipe-writer metrics
- **Expression:** `vector(0)`
- **Audit:** ✅ **CORRECT** (placeholder)

---

#### Panel 23: Metrics Bytes Exported
- **Type:** stat
- **Description:** Bytes sent to ClickHouse for metric samples and time series metadata
- **Expression:** `sum(rate(sent_bytes_total{job="gigapipe-writer", service=~"samples|time_series"}[$__rate_interval]))`
- **Audit:** ✅ **CORRECT**

---

#### Panel 24: Traces Bytes Exported
- **Type:** stat
- **Description:** Bytes sent to ClickHouse for traces and trace tags
- **Expression:** `sum(rate(sent_bytes_total{job="gigapipe-writer", service=~"traces|traces_tags"}[$__rate_interval]))`
- **Audit:** ✅ **CORRECT**

---

#### Panel 25: Intake by Receiver Over Time
- **Type:** timeseries
- **Description:** Rate of metric points per receiver over time.
- **Expression:** `sum by (receiver) (rate(otelcol_receiver_accepted_metric_points_total{...}[$__rate_interval]))`
- **Audit:** ✅ **CORRECT**

---

#### Panel 26: Processor Drop Over Time (All Signals)
- **Type:** timeseries
- **Description:** Items (metrics, logs, traces) dropped by each processor over time.
- **Expression:** `sum by (processor) (rate(otelcol_processor_incoming_items_total{...}[$__rate_interval]) - rate(otelcol_processor_outgoing_items_total{...}[$__rate_interval])) > 0`
- **Audit:** ✅ **CORRECT**
  - Title and description clarify it covers all signal types
  - Uses `_items_total` which includes metrics, logs, and traces

---

## Metrics Reference

| Metric | Source | Description |
|--------|--------|-------------|
| `scrape_samples_scraped` | Prometheus | Raw samples exposed by target before `metric_relabel_configs` |
| `scrape_samples_post_metric_relabeling` | Prometheus | Samples after `metric_relabel_configs` applied |
| `otelcol_receiver_accepted_metric_points_total` | OTel Collector | Metric points accepted by receivers |
| `otelcol_receiver_accepted_log_records_total` | OTel Collector | Log records accepted by receivers |
| `otelcol_receiver_accepted_spans_total` | OTel Collector | Trace spans accepted by receivers |
| `otelcol_processor_incoming_items_total` | OTel Collector | Items entering a processor (all signal types) |
| `otelcol_processor_outgoing_items_total` | OTel Collector | Items leaving a processor (all signal types) |
| `otelcol_exporter_sent_metric_points_total` | OTel Collector | Metric points successfully exported |
| `otelcol_exporter_sent_log_records_total` | OTel Collector | Log records successfully exported |
| `otelcol_exporter_sent_spans_total` | OTel Collector | Trace spans successfully exported |
| `sent_bytes_total` | gigapipe-writer | Bytes written to ClickHouse |
