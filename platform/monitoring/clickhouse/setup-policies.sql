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
-- What this does:
--   1. Adds tenant_scope materialized column to key tables
--   2. Creates a mapping view (fingerprint → tenant_scope)
--   3. Creates row policies so user_nonpci can't see PCI data
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
-- samples_v3 and metrics_15s only have fingerprint (no labels).
-- We create a dictionary/view to resolve fingerprint → tenant_scope
-- so row policies on those tables can use it.

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
-- Step 3: Materialized column on samples_v3
-- ═══════════════════════════════════════════════════════════════
-- Join fingerprint to the mapping table to get tenant_scope.
-- Since MATERIALIZED can't do JOINs, we use DEFAULT with a subquery.
-- New rows will get the value if the fingerprint is already mapped.

ALTER TABLE otel.samples_v3
  ADD COLUMN IF NOT EXISTS `tenant_scope` LowCardinality(String)
  DEFAULT (SELECT tenant_scope FROM otel.fingerprint_tenant_map WHERE fingerprint = otel.samples_v3.fingerprint LIMIT 1);

-- ═══════════════════════════════════════════════════════════════
-- Step 4: Materialized column on metrics_15s
-- ═══════════════════════════════════════════════════════════════

ALTER TABLE otel.metrics_15s
  ADD COLUMN IF NOT EXISTS `tenant_scope` LowCardinality(String)
  DEFAULT (SELECT tenant_scope FROM otel.fingerprint_tenant_map WHERE fingerprint = otel.metrics_15s.fingerprint LIMIT 1);

-- ═══════════════════════════════════════════════════════════════
-- Step 5: Materialized column on tempo_traces
-- ═══════════════════════════════════════════════════════════════
-- Traces store compliance.scope in tempo_traces_kv table.
-- For tempo_traces, we can use a subquery on tempo_traces_kv.

ALTER TABLE otel.tempo_traces
  ADD COLUMN IF NOT EXISTS `tenant_scope` LowCardinality(String)
  DEFAULT (SELECT val FROM otel.tempo_traces_kv WHERE key = 'compliance.scope' AND oid = otel.tempo_traces.oid LIMIT 1);

-- ═══════════════════════════════════════════════════════════════
-- Step 6: Row policies — user_all (unrestricted)
-- ═══════════════════════════════════════════════════════════════

CREATE ROW POLICY IF NOT EXISTS all_access ON otel.time_series USING 1=1 TO user_all;
CREATE ROW POLICY IF NOT EXISTS all_access ON otel.samples_v3 USING 1=1 TO user_all;
CREATE ROW POLICY IF NOT EXISTS all_access ON otel.metrics_15s USING 1=1 TO user_all;
CREATE ROW POLICY IF NOT EXISTS all_access ON otel.tempo_traces USING 1=1 TO user_all;
CREATE ROW POLICY IF NOT EXISTS all_access ON otel.tempo_traces_kv USING 1=1 TO user_all;
CREATE ROW POLICY IF NOT EXISTS all_access ON otel.tempo_traces_attrs_gin USING 1=1 TO user_all;

-- ═══════════════════════════════════════════════════════════════
-- Step 7: Row policies — user_nonpci (no PCI data)
-- ═══════════════════════════════════════════════════════════════
-- Policy: tenant_scope != 'pci' (allows empty string + any non-pci value)

CREATE ROW POLICY IF NOT EXISTS nonpci_only ON otel.time_series
  USING tenant_scope != 'pci' TO user_nonpci;

CREATE ROW POLICY IF NOT EXISTS nonpci_only ON otel.samples_v3
  USING tenant_scope != 'pci' OR tenant_scope = '' TO user_nonpci;

CREATE ROW POLICY IF NOT EXISTS nonpci_only ON otel.metrics_15s
  USING tenant_scope != 'pci' OR tenant_scope = '' TO user_nonpci;

CREATE ROW POLICY IF NOT EXISTS nonpci_only ON otel.tempo_traces
  USING tenant_scope != 'pci' OR tenant_scope = '' TO user_nonpci;

CREATE ROW POLICY IF NOT EXISTS nonpci_only ON otel.tempo_traces_kv
  USING oid NOT IN (SELECT oid FROM otel.tempo_traces WHERE tenant_scope = 'pci') TO user_nonpci;

CREATE ROW POLICY IF NOT EXISTS nonpci_only ON otel.tempo_traces_attrs_gin
  USING oid NOT IN (SELECT oid FROM otel.tempo_traces WHERE tenant_scope = 'pci') TO user_nonpci;

SELECT 'Done. Row policies applied for Gigapipe schema.';
