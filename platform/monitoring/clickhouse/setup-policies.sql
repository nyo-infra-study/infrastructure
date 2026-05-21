-- ============================================================
-- ClickHouse Row Policies Setup (Gigapipe Schema)
-- ============================================================
-- Run this AFTER Gigapipe has written its first batch of data
-- (which triggers auto-creation of tables).
--
-- Usage:
--   kubectl exec -n monitoring dev-monitoring-clickhouse-0 -- \
--     clickhouse-client --password clickhouse123 --multiquery \
--     < infrastructure/platform/monitoring/clickhouse/setup-policies.sql
--
-- Access Model:
--   user_all       → Full access to everything (PCI + non-PCI)
--   user_nonpci    → Full access to metrics + traces,
--                    but CANNOT read PCI logs (samples_v3 where scope=pci)
--
-- In Grafana terms:
--   "Prometheus (PCI)" / "Loki (PCI)" / "Tempo (PCI)"
--       → Gigapipe Writer (user=default) → sees all
--   "Prometheus (Non-PCI)" / "Loki (Non-PCI)" / "Tempo (Non-PCI)"
--       → Gigapipe Reader (user=user_nonpci) → all metrics/traces,
--         but PCI logs are filtered out
-- ============================================================

-- ═══════════════════════════════════════════════════════════════
-- Step 1: Materialized column on time_series
-- ═══════════════════════════════════════════════════════════════
-- time_series has the labels JSON — extract compliance_scope from it.
-- This is the source of truth for tenant scoping.

ALTER TABLE otel.time_series
  ADD COLUMN IF NOT EXISTS `tenant_scope` LowCardinality(String)
  MATERIALIZED JSONExtractString(labels, 'compliance_scope');

-- Backfill existing rows
ALTER TABLE otel.time_series MATERIALIZE COLUMN tenant_scope;

-- ═══════════════════════════════════════════════════════════════
-- Step 2: Materialized view — fingerprint → tenant_scope mapping
-- ═══════════════════════════════════════════════════════════════
-- samples_v3 stores both metrics and logs (Gigapipe uses it for Loki push).
-- We need the fingerprint → tenant_scope mapping to filter log samples.

CREATE TABLE IF NOT EXISTS otel.fingerprint_tenant_map (
  fingerprint UInt64,
  tenant_scope LowCardinality(String)
) ENGINE = ReplacingMergeTree()
ORDER BY fingerprint;

-- Populate from existing time_series data
INSERT INTO otel.fingerprint_tenant_map
SELECT DISTINCT fingerprint, JSONExtractString(labels, 'compliance_scope') AS tenant_scope
FROM otel.time_series
WHERE tenant_scope != '';

-- MV to keep it updated as new time_series rows arrive
CREATE MATERIALIZED VIEW IF NOT EXISTS otel.fingerprint_tenant_map_mv
TO otel.fingerprint_tenant_map AS
SELECT fingerprint, JSONExtractString(labels, 'compliance_scope') AS tenant_scope
FROM otel.time_series
WHERE JSONExtractString(labels, 'compliance_scope') != '';

-- ═══════════════════════════════════════════════════════════════
-- Step 3: Materialized column on samples_v3 (LOGS)
-- ═══════════════════════════════════════════════════════════════
-- samples_v3 is used by Gigapipe for log entries (Loki push path).
-- This is the ONLY table where PCI filtering applies for user_nonpci.

ALTER TABLE otel.samples_v3
  ADD COLUMN IF NOT EXISTS `tenant_scope` LowCardinality(String)
  DEFAULT (SELECT tenant_scope FROM otel.fingerprint_tenant_map WHERE fingerprint = otel.samples_v3.fingerprint LIMIT 1);

-- ═══════════════════════════════════════════════════════════════
-- Step 4: Materialized column on metrics_15s
-- ═══════════════════════════════════════════════════════════════
-- Kept for reference/future use, but NO row policy restricts this table.

ALTER TABLE otel.metrics_15s
  ADD COLUMN IF NOT EXISTS `tenant_scope` LowCardinality(String)
  DEFAULT (SELECT tenant_scope FROM otel.fingerprint_tenant_map WHERE fingerprint = otel.metrics_15s.fingerprint LIMIT 1);

-- ═══════════════════════════════════════════════════════════════
-- Step 5: Materialized column on tempo_traces
-- ═══════════════════════════════════════════════════════════════
-- Kept for reference/future use, but NO row policy restricts this table.

ALTER TABLE otel.tempo_traces
  ADD COLUMN IF NOT EXISTS `tenant_scope` LowCardinality(String)
  DEFAULT (SELECT val FROM otel.tempo_traces_kv WHERE key = 'compliance.scope' AND oid = otel.tempo_traces.oid LIMIT 1);

-- ═══════════════════════════════════════════════════════════════
-- Step 6: Row policies — user_all (unrestricted, full access)
-- ═══════════════════════════════════════════════════════════════
-- user_all sees everything: all metrics, all traces, all logs (including PCI).

CREATE ROW POLICY IF NOT EXISTS all_access ON otel.time_series USING 1=1 TO user_all;
CREATE ROW POLICY IF NOT EXISTS all_access ON otel.samples_v3 USING 1=1 TO user_all;
CREATE ROW POLICY IF NOT EXISTS all_access ON otel.metrics_15s USING 1=1 TO user_all;
CREATE ROW POLICY IF NOT EXISTS all_access ON otel.tempo_traces USING 1=1 TO user_all;
CREATE ROW POLICY IF NOT EXISTS all_access ON otel.tempo_traces_kv USING 1=1 TO user_all;
CREATE ROW POLICY IF NOT EXISTS all_access ON otel.tempo_traces_attrs_gin USING 1=1 TO user_all;

-- ═══════════════════════════════════════════════════════════════
-- Step 7: Row policies — user_nonpci
-- ═══════════════════════════════════════════════════════════════
-- user_nonpci can read:
--   ✓ ALL metrics (time_series, metrics_15s) — unrestricted
--   ✓ ALL traces (tempo_traces, tempo_traces_kv, tempo_traces_attrs_gin) — unrestricted
--   ✗ PCI logs (samples_v3 where tenant_scope = 'pci') — BLOCKED
--   ✓ Non-PCI logs — allowed
--
-- Only samples_v3 (logs) is restricted. Everything else is open.
-- ═══════════════════════════════════════════════════════════════

-- Metrics: full access (no PCI restriction)
CREATE ROW POLICY IF NOT EXISTS nonpci_access ON otel.time_series USING 1=1 TO user_nonpci;
CREATE ROW POLICY IF NOT EXISTS nonpci_access ON otel.metrics_15s USING 1=1 TO user_nonpci;

-- Traces: full access (no PCI restriction)
CREATE ROW POLICY IF NOT EXISTS nonpci_access ON otel.tempo_traces USING 1=1 TO user_nonpci;
CREATE ROW POLICY IF NOT EXISTS nonpci_access ON otel.tempo_traces_kv USING 1=1 TO user_nonpci;
CREATE ROW POLICY IF NOT EXISTS nonpci_access ON otel.tempo_traces_attrs_gin USING 1=1 TO user_nonpci;

-- Logs (samples_v3): ONLY non-PCI logs visible
-- tenant_scope != 'pci' allows: empty string (unlabeled), 'non-pci', any other value
-- tenant_scope = 'pci' is the ONLY thing blocked
CREATE ROW POLICY IF NOT EXISTS nonpci_logs_only ON otel.samples_v3
  USING tenant_scope != 'pci' OR tenant_scope = '' TO user_nonpci;

SELECT 'Done. Row policies applied. user_nonpci: all metrics + traces, no PCI logs.';
