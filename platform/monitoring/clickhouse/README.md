# ClickHouse — Example Queries

Open the Play UI at: **http://clickhouse.localhost/play**

---

## Users

| User | Password | Metrics | Traces | Logs |
|------|----------|---------|--------|------|
| `default` | `clickhouse123` | All | All | All (admin) |
| `user_all` | `all_pass` | All | All | All (including PCI) |
| `user_nonpci` | `nonpci_pass` | All | All | Non-PCI only (PCI logs hidden) |

---

## Sanity Check — Verify PCI Log Filtering

The only restriction for `user_nonpci` is on **logs** (samples_v3). Metrics and traces are fully visible.

```sql
-- As user_all: should see PCI log entries
SELECT count() FROM otel.samples_v3 WHERE tenant_scope = 'pci';

-- As user_nonpci: should return 0 (PCI logs filtered by row policy)
SELECT count() FROM otel.samples_v3 WHERE tenant_scope = 'pci';

-- As user_nonpci: metrics should be fully visible (no restriction)
SELECT count() FROM otel.time_series WHERE tenant_scope = 'pci';
-- ^ This SHOULD return >0 (metrics are NOT filtered for user_nonpci)

-- As user_nonpci: traces should be fully visible (no restriction)
SELECT count() FROM otel.tempo_traces WHERE tenant_scope = 'pci';
-- ^ This SHOULD return >0 (traces are NOT filtered for user_nonpci)
```

Quick test from CLI:

```bash
# user_all — should see PCI logs
kubectl exec -n monitoring dev-monitoring-clickhouse-0 -- \
  clickhouse-client --user user_all --password all_pass \
  --query "SELECT count() FROM otel.samples_v3 WHERE tenant_scope = 'pci'"

# user_nonpci — PCI logs should return 0
kubectl exec -n monitoring dev-monitoring-clickhouse-0 -- \
  clickhouse-client --user user_nonpci --password nonpci_pass \
  --query "SELECT count() FROM otel.samples_v3 WHERE tenant_scope = 'pci'"

# user_nonpci — metrics should still be visible (returns >0)
kubectl exec -n monitoring dev-monitoring-clickhouse-0 -- \
  clickhouse-client --user user_nonpci --password nonpci_pass \
  --query "SELECT count() FROM otel.time_series WHERE tenant_scope = 'pci'"

# user_nonpci — traces should still be visible (returns >0)
kubectl exec -n monitoring dev-monitoring-clickhouse-0 -- \
  clickhouse-client --user user_nonpci --password nonpci_pass \
  --query "SELECT count() FROM otel.tempo_traces WHERE tenant_scope = 'pci'"
```

---

## Table Names (Gigapipe Schema)

### Core tables (database: `otel`)

| Table | Signal | Description |
|-------|--------|-------------|
| `time_series` | Metrics | Label sets (fingerprint → labels JSON) |
| `samples_v3` | Metrics | Metric sample values (fingerprint + timestamp + value) |
| `metrics_15s` | Metrics | Downsampled metrics (15s resolution) |
| `tempo_traces` | Traces | Span data |
| `tempo_traces_kv` | Traces | Span attributes (key-value pairs) |
| `tempo_traces_attrs_gin` | Traces | Span attribute index (GIN-style) |
| `fingerprint_tenant_map` | Internal | Fingerprint → tenant_scope mapping |

### List all tables

```sql
SELECT name, engine, total_rows, formatReadableSize(total_bytes) AS size
FROM system.tables
WHERE database = 'otel'
ORDER BY total_bytes DESC;
```

---

## Useful Queries

### Check what's being ingested

```sql
-- Row counts per table
SELECT name, total_rows
FROM system.tables
WHERE database = 'otel' AND total_rows > 0
ORDER BY total_rows DESC;
```

### Recent metrics (last 5 minutes)

```sql
SELECT fingerprint, timestamp_ns, value
FROM otel.samples_v3
WHERE timestamp_ns > now64(9) - INTERVAL 5 MINUTE
ORDER BY timestamp_ns DESC
LIMIT 20;
```

### List all metric names (labels)

```sql
SELECT DISTINCT JSONExtractString(labels, '__name__') AS metric_name
FROM otel.time_series
WHERE metric_name != ''
ORDER BY metric_name
LIMIT 50;
```

### Check tenant_scope distribution

```sql
SELECT tenant_scope, count() AS series_count
FROM otel.time_series
GROUP BY tenant_scope
ORDER BY series_count DESC;
```

### Recent traces

```sql
SELECT trace_id, span_id, name, duration_ns / 1e6 AS duration_ms
FROM otel.tempo_traces
WHERE timestamp_ns > now64(9) - INTERVAL 5 MINUTE
ORDER BY timestamp_ns DESC
LIMIT 20;
```

### Row policies status

```sql
SELECT * FROM system.row_policies WHERE database = 'otel';
```

### Storage usage per table

```sql
SELECT
    table,
    formatReadableSize(sum(bytes_on_disk)) AS disk_size,
    sum(rows) AS rows,
    count() AS parts
FROM system.parts
WHERE database = 'otel' AND active
GROUP BY table
ORDER BY sum(bytes_on_disk) DESC;
```

---

## ClickHouse System Health

```sql
-- Current queries running
SELECT query_id, user, elapsed, query
FROM system.processes;

-- Memory usage
SELECT formatReadableSize(sum(value))
FROM system.metrics
WHERE metric = 'MemoryTracking';

-- Uptime
SELECT uptime();
```
