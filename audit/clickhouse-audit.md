# ClickHouse Dashboard - Metrics Audit

**Dashboard:** ClickHouse (`clickhouse`)  
**Audit Date:** 2025-06-13  
**Validated Against:** Local Grafana MCP  
**Status:** ✅ All issues resolved

---

## Summary

| Category | Count |
|----------|-------|
| Total Panels with Queries | 19 |
| ✅ Correct | 19 |
| ⚠️ Minor Issues | 0 |
| ❌ Incorrect | 0 |

---

## Issues Found and Fixed

### Issue 1: Queries/s - Non-existent metric ❌→✅

**Panel:** Queries/s  
**Problem:** Query A used `ClickHouseProfileEvents_Query_total` which does NOT exist in Prometheus.  
**Evidence:** MCP query returned empty result for `ClickHouseProfileEvents_Query_total{job="clickhouse"}`  
**Available metrics:** Only `ClickHouseProfileEvents_SelectQuery_total` and `ClickHouseProfileEvents_InsertQuery_total` exist.

**Fix:** Changed query A from:
```promql
rate(ClickHouseProfileEvents_Query_total{job="clickhouse"}[5m])
```
To:
```promql
rate(ClickHouseProfileEvents_SelectQuery_total{job="clickhouse"}[$__rate_interval]) + rate(ClickHouseProfileEvents_InsertQuery_total{job="clickhouse"}[$__rate_interval])
```

### Issue 2: Hardcoded rate intervals ⚠️→✅

**Problem:** Multiple panels used hardcoded `[5m]` rate intervals instead of `[$__rate_interval]`.  
**Fix:** Updated all rate() calls to use `[$__rate_interval]` for better Grafana compatibility.

**Panels updated:**
- Queries/s (all 3 queries)
- Failed Queries/s (all 3 queries)
- Inserted Rows/s
- Inserted Bytes/s
- Merged Rows/s
- Merged Bytes/s
- Read/Write Bytes/s
- ZooKeeper Requests/s (both queries)
- ZooKeeper Wait Time

### Issue 3: Missing descriptions ⚠️→✅

**Problem:** Many panels lacked descriptions.  
**Fix:** Added descriptions to all panels for better clarity.

### Issue 4: ZooKeeper Wait Time confusing legend ⚠️→✅

**Problem:** Legend said "wait µs/s" which is confusing.  
**Fix:** Changed to "wait time rate" and added description explaining the metric.

---

## Panel-by-Panel Audit

### Section: Storage

#### Total Data Size
- **Type:** stat
- **Description:** Actual compressed data stored in all MergeTree tables (user data, not filesystem).
- **Expression:** `ClickHouseAsyncMetrics_TotalBytesOfMergeTreeTables - ClickHouseAsyncMetrics_TotalBytesOfMergeTreeTablesSystem`
- **Metrics Used:**
  - `ClickHouseAsyncMetrics_TotalBytesOfMergeTreeTables` (gauge) ✅
  - `ClickHouseAsyncMetrics_TotalBytesOfMergeTreeTablesSystem` (gauge) ✅
- **Audit:** ✅ **CORRECT** - Subtracting system tables from total gives user data size.

#### Total Parts
- **Type:** stat
- **Description:** Number of active data parts. High count may indicate merge pressure.
- **Expression:** `ClickHouseMetrics_PartsActive`
- **Metric Used:** `ClickHouseMetrics_PartsActive` (gauge) ✅
- **Audit:** ✅ **CORRECT**

#### Total Rows
- **Type:** stat
- **Description:** Total rows stored across all tables.
- **Expression:** `ClickHouseAsyncMetrics_TotalRowsOfMergeTreeTables`
- **Metric Used:** `ClickHouseAsyncMetrics_TotalRowsOfMergeTreeTables` (gauge) ✅
- **Audit:** ✅ **CORRECT**

#### Memory Tracking
- **Type:** stat
- **Description:** Current memory used by ClickHouse server.
- **Expression:** `ClickHouseMetrics_MemoryTracking`
- **Metric Used:** `ClickHouseMetrics_MemoryTracking` (gauge) ✅
- **Audit:** ✅ **CORRECT**

#### Data Size Over Time
- **Type:** timeseries
- **Description:** User data vs system data size over time.
- **Expressions:**
  - A: User data = `TotalBytesOfMergeTreeTables - TotalBytesOfMergeTreeTablesSystem`
  - B: System data = `TotalBytesOfMergeTreeTablesSystem`
- **Audit:** ✅ **CORRECT**

#### Active Parts Over Time
- **Type:** timeseries
- **Description:** Number of active data parts over time.
- **Expression:** `ClickHouseMetrics_PartsActive`
- **Audit:** ✅ **CORRECT**

---

### Section: Queries

#### Queries/s
- **Type:** timeseries
- **Description:** Query throughput: selects, inserts, and total (sum of both).
- **Expressions:**
  - A: `rate(SelectQuery_total + InsertQuery_total)` - all queries ✅ (FIXED)
  - B: `rate(SelectQuery_total)` - selects ✅
  - C: `rate(InsertQuery_total)` - inserts ✅
- **Audit:** ✅ **CORRECT** - All ProfileEvents are counters, rate() is appropriate.

#### Failed Queries/s
- **Type:** timeseries
- **Description:** Rate of failed queries.
- **Expressions:**
  - A: `rate(FailedQuery_total)` ✅
  - B: `rate(FailedSelectQuery_total)` ✅
  - C: `rate(FailedInsertQuery_total)` ✅
- **Audit:** ✅ **CORRECT** - All ProfileEvents are counters, rate() is appropriate.

#### Current Running Queries
- **Type:** stat
- **Description:** Number of queries currently being executed.
- **Expression:** `ClickHouseMetrics_Query`
- **Metric Used:** `ClickHouseMetrics_Query` (gauge) ✅
- **Audit:** ✅ **CORRECT** - This is a gauge showing concurrent queries.

---

### Section: Inserts

#### Inserted Rows/s
- **Type:** timeseries
- **Description:** Rate of rows inserted into ClickHouse tables.
- **Expression:** `rate(ClickHouseProfileEvents_InsertedRows_total)`
- **Metric Used:** `ClickHouseProfileEvents_InsertedRows_total` (counter) ✅
- **Audit:** ✅ **CORRECT**

#### Inserted Bytes/s
- **Type:** timeseries
- **Description:** Rate of bytes inserted into ClickHouse tables.
- **Expression:** `rate(ClickHouseProfileEvents_InsertedBytes_total)`
- **Metric Used:** `ClickHouseProfileEvents_InsertedBytes_total` (counter) ✅
- **Audit:** ✅ **CORRECT**

---

### Section: Merges & Background

#### Background Merges Running
- **Type:** timeseries
- **Description:** Number of concurrent merge operations.
- **Expression:** `ClickHouseMetrics_Merge`
- **Metric Used:** `ClickHouseMetrics_Merge` (gauge) ✅
- **Audit:** ✅ **CORRECT** - Gauge showing current merge count.

#### Merged Rows/s
- **Type:** timeseries
- **Description:** Rate of rows processed by background merge operations.
- **Expression:** `rate(ClickHouseProfileEvents_MergedRows_total)`
- **Metric Used:** `ClickHouseProfileEvents_MergedRows_total` (counter) ✅
- **Audit:** ✅ **CORRECT**

#### Merged Bytes/s
- **Type:** timeseries
- **Description:** Rate of uncompressed bytes processed by background merge operations.
- **Expression:** `rate(ClickHouseProfileEvents_MergedUncompressedBytes_total)`
- **Metric Used:** `ClickHouseProfileEvents_MergedUncompressedBytes_total` (counter) ✅
- **Audit:** ✅ **CORRECT**

---

### Section: Connections & Resources

#### TCP Connections
- **Type:** timeseries
- **Description:** Current active TCP and HTTP connections to ClickHouse.
- **Expressions:**
  - A: `ClickHouseMetrics_TCPConnection` (gauge) ✅
  - B: `ClickHouseMetrics_HTTPConnection` (gauge) ✅
- **Audit:** ✅ **CORRECT** - Gauges showing current connection counts.

#### Memory Over Time
- **Type:** timeseries
- **Description:** ClickHouse memory usage tracked by the server.
- **Expression:** `ClickHouseMetrics_MemoryTracking`
- **Audit:** ✅ **CORRECT**

#### Read/Write Bytes/s (Disk I/O)
- **Type:** timeseries
- **Description:** Disk I/O throughput from file descriptor read/write operations.
- **Expressions:**
  - A: `rate(ReadBufferFromFileDescriptorReadBytes_total)` ✅
  - B: `rate(WriteBufferFromFileDescriptorWriteBytes_total)` ✅
- **Audit:** ✅ **CORRECT** - ProfileEvents are counters.

---

### Section: ZooKeeper / Keeper

#### ZooKeeper Requests/s
- **Type:** timeseries
- **Description:** Rate of ZooKeeper operations performed by ClickHouse.
- **Expressions:**
  - A: `rate(ZooKeeperTransactions_total)` ✅
  - B: `rate(ZooKeeperGet_total)` ✅
- **Audit:** ✅ **CORRECT**

#### ZooKeeper Wait Time
- **Type:** timeseries
- **Description:** Total ZooKeeper wait time accumulated per second.
- **Expression:** `rate(ZooKeeperWaitMicroseconds_total)`
- **Metric Used:** `ClickHouseProfileEvents_ZooKeeperWaitMicroseconds_total` (counter) ✅
- **Audit:** ✅ **CORRECT** - This counter accumulates total wait time. Rate gives µs of wait per second, which shows ZK latency impact.

---

### Section: Active Queries (searchable)

#### ClickHouse Metrics Overview
- **Type:** briangann-datatable-panel
- **Description:** All ClickHouse metrics with current values.
- **Expression:** `{__name__=~"ClickHouseMetrics_.+",job="clickhouse"} > 0`
- **Query Type:** instant (table format requires instant)
- **Audit:** ✅ **CORRECT** - For table panels, instant query is appropriate to show current values.

---

## Metrics Reference

| Metric | Type | Source | Description |
|--------|------|--------|-------------|
| `ClickHouseAsyncMetrics_TotalBytesOfMergeTreeTables` | gauge | ClickHouse | Total bytes in all MergeTree tables |
| `ClickHouseAsyncMetrics_TotalBytesOfMergeTreeTablesSystem` | gauge | ClickHouse | Total bytes in system MergeTree tables |
| `ClickHouseAsyncMetrics_TotalRowsOfMergeTreeTables` | gauge | ClickHouse | Total rows in all MergeTree tables |
| `ClickHouseMetrics_PartsActive` | gauge | ClickHouse | Number of active data parts |
| `ClickHouseMetrics_MemoryTracking` | gauge | ClickHouse | Memory used by server |
| `ClickHouseMetrics_Query` | gauge | ClickHouse | Currently running queries |
| `ClickHouseMetrics_Merge` | gauge | ClickHouse | Currently running merges |
| `ClickHouseMetrics_TCPConnection` | gauge | ClickHouse | Active TCP connections |
| `ClickHouseMetrics_HTTPConnection` | gauge | ClickHouse | Active HTTP connections |
| `ClickHouseProfileEvents_SelectQuery_total` | counter | ClickHouse | Total SELECT queries executed |
| `ClickHouseProfileEvents_InsertQuery_total` | counter | ClickHouse | Total INSERT queries executed |
| `ClickHouseProfileEvents_FailedQuery_total` | counter | ClickHouse | Total failed queries |
| `ClickHouseProfileEvents_InsertedRows_total` | counter | ClickHouse | Total rows inserted |
| `ClickHouseProfileEvents_InsertedBytes_total` | counter | ClickHouse | Total bytes inserted |
| `ClickHouseProfileEvents_MergedRows_total` | counter | ClickHouse | Total rows merged |
| `ClickHouseProfileEvents_MergedUncompressedBytes_total` | counter | ClickHouse | Total uncompressed bytes merged |
| `ClickHouseProfileEvents_ZooKeeperTransactions_total` | counter | ClickHouse | Total ZK transactions |
| `ClickHouseProfileEvents_ZooKeeperGet_total` | counter | ClickHouse | Total ZK GET operations |
| `ClickHouseProfileEvents_ZooKeeperWaitMicroseconds_total` | counter | ClickHouse | Total microseconds spent waiting for ZK |

### Note on ClickHouse metric types:
- **ClickHouseMetrics_*** - Gauges showing current state (connections, running queries, etc.)
- **ClickHouseAsyncMetrics_*** - Gauges calculated asynchronously (storage sizes, etc.)
- **ClickHouseProfileEvents_*_total** - Counters tracking cumulative events (queries, bytes, rows, etc.)
