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
-- ════════════════════════════════════════════════════════════════
-- HOW THIS WORKS
-- ════════════════════════════════════════════════════════════════
--
-- Problem:
--   Gigapipe stores logs in samples_v3 as (fingerprint, timestamp, value).
--   The fingerprint is just a hash — it doesn't contain labels like
--   compliance_scope. So we can't filter PCI logs directly.
--
-- How Gigapipe queries logs (e.g. {service_name="backend-server"}):
--   1. Query time_series: labels JSON → find matching fingerprints
--   2. Query samples_v3:  WHERE fingerprint IN (...) AND timestamp BETWEEN ...
--   (Two-step: resolve labels first, then fetch data by fingerprint)
--
-- How we add tenant scoping for PCI log filtering:
--
--   ┌──────────────────────────────────────────────────────────┐
--   │ App sets OTEL_RESOURCE_ATTRIBUTES=compliance.scope=pci   │
--   └────────────────────────┬─────────────────────────────────┘
--                            ▼
--   ┌──────────────────────────────────────────────────────────┐
--   │ Gigapipe writes to time_series:                          │
--   │   fingerprint=123, labels={"compliance_scope":"pci",...}  │
--   └────────────────────────┬─────────────────────────────────┘
--                            ▼
--   ┌──────────────────────────────────────────────────────────┐
--   │ Step 1: MATERIALIZED column extracts from labels JSON    │
--   │   time_series.tenant_scope = "pci" (stored on disk)      │
--   └────────────────────────┬─────────────────────────────────┘
--                            ▼
--   ┌──────────────────────────────────────────────────────────┐
--   │ Step 2: Materialized View copies to mapping table        │
--   │   fingerprint_tenant_map: 123 → "pci"                    │
--   └────────────────────────┬─────────────────────────────────┘
--                            ▼
--   ┌──────────────────────────────────────────────────────────┐
--   │ Step 3: Dictionary loads mapping into RAM (hash table)   │
--   │   fingerprint_scope_dict: {123: "pci", 456: "non-pci"}  │
--   │   Refreshes every 30-60s                                 │
--   └────────────────────────┬─────────────────────────────────┘
--                            ▼
--   ┌──────────────────────────────────────────────────────────┐
--   │ Step 4: When a log row is INSERT'd into samples_v3:      │
--   │   MATERIALIZED column does:                              │
--   │   tenant_scope = dictGet(dict, fingerprint) → "pci"      │
--   │   (O(1) hash lookup, stored on disk, never recomputed)   │
--   └────────────────────────┬─────────────────────────────────┘
--                            ▼
--   ┌──────────────────────────────────────────────────────────┐
--   │ Step 5-6: Row policy on samples_v3:                      │
--   │   user_nonpci → USING tenant_scope != 'pci'             │
--   │   (filters on stored column — no computation at read)    │
--   └──────────────────────────────────────────────────────────┘
--
-- Race condition:
--   If a log row arrives before the dictionary has its fingerprint
--   (dict refreshes every 30-60s), tenant_scope = '' (unmapped).
--   Step 7 backfill mutation fixes these rows periodically.
--
-- ════════════════════════════════════════════════════════════════
-- ACCESS MODEL
-- ════════════════════════════════════════════════════════════════
--   user_all       → Full access to everything (PCI + non-PCI)
--   user_nonpci    → Full access to metrics + traces,
--                    but CANNOT read PCI logs (samples_v3 where scope=pci)
--
-- Performance:
--   - Dictionary lookup at insert: O(1) hash, no disk I/O
--   - Row policy at query: filters stored LowCardinality column
--   - No subqueries, no JOINs at read time
--   - Only samples_v3 is affected. Metrics/traces have zero overhead.
-- ============================================================

-- ═══════════════════════════════════════════════════════════════
-- Step 1: Materialized column on time_series
-- ═══════════════════════════════════════════════════════════════
-- time_series has the labels JSON — extract compliance_scope from it.
-- This is the source of truth for the fingerprint → scope mapping.

ALTER TABLE otel.time_series
  ADD COLUMN IF NOT EXISTS `tenant_scope` LowCardinality(String)
  MATERIALIZED JSONExtractString(labels, 'compliance_scope');

ALTER TABLE otel.time_series MATERIALIZE COLUMN tenant_scope;

-- ═══════════════════════════════════════════════════════════════
-- Step 2: Fingerprint → tenant_scope mapping table
-- ═══════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS otel.fingerprint_tenant_map (
  fingerprint UInt64,
  tenant_scope LowCardinality(String),
  updated_at DateTime DEFAULT now()
) ENGINE = ReplacingMergeTree(updated_at)
ORDER BY fingerprint;

-- Populate from existing time_series data
INSERT INTO otel.fingerprint_tenant_map (fingerprint, tenant_scope)
SELECT DISTINCT fingerprint, JSONExtractString(labels, 'compliance_scope') AS tenant_scope
FROM otel.time_series
WHERE JSONExtractString(labels, 'compliance_scope') != '';

-- Keep mapping updated as new time_series rows arrive
CREATE MATERIALIZED VIEW IF NOT EXISTS otel.fingerprint_tenant_map_mv
TO otel.fingerprint_tenant_map AS
SELECT
  fingerprint,
  JSONExtractString(labels, 'compliance_scope') AS tenant_scope,
  now() AS updated_at
FROM otel.time_series
WHERE JSONExtractString(labels, 'compliance_scope') != '';

-- ═══════════════════════════════════════════════════════════════
-- Step 3: In-memory dictionary (O(1) hash lookup)
-- ═══════════════════════════════════════════════════════════════
-- Loads fingerprint_tenant_map into RAM. dictGetOrDefault() is a
-- single hash lookup — no disk I/O, no subquery.
-- Refreshes every 30-60s to pick up new fingerprints.

CREATE DICTIONARY IF NOT EXISTS otel.fingerprint_scope_dict (
  fingerprint UInt64,
  tenant_scope String
)
PRIMARY KEY fingerprint
SOURCE(CLICKHOUSE(
  DB 'otel'
  TABLE 'fingerprint_tenant_map'
  USER 'default'
  PASSWORD 'clickhouse123'
  WHERE 'tenant_scope != \'\''
))
LAYOUT(HASHED())
LIFETIME(MIN 30 MAX 60);

-- ═══════════════════════════════════════════════════════════════
-- Step 4: Materialized column on samples_v3 (LOGS ONLY)
-- ═══════════════════════════════════════════════════════════════
-- This is the ONLY data table with tenant scoping.
-- MATERIALIZED + dictGet = O(1) at insert time, stored on disk.

ALTER TABLE otel.samples_v3
  ADD COLUMN IF NOT EXISTS `tenant_scope` LowCardinality(String)
  MATERIALIZED dictGetOrDefault('otel.fingerprint_scope_dict', 'tenant_scope', fingerprint, '');

-- ═══════════════════════════════════════════════════════════════
-- Step 5: Row policies — user_all (unrestricted)
-- ═══════════════════════════════════════════════════════════════

CREATE ROW POLICY IF NOT EXISTS all_access ON otel.samples_v3 USING 1=1 TO user_all;

-- ═══════════════════════════════════════════════════════════════
-- Step 6: Row policies — user_nonpci (PCI logs blocked)
-- ═══════════════════════════════════════════════════════════════
-- Only samples_v3 has a row policy. All other tables are unrestricted.
--
-- tenant_scope != 'pci' means:
--   '' (unmapped)   → visible (safe default, backfill fixes later)
--   'non-pci'       → visible
--   'pci'           → BLOCKED
--
-- For STRICT mode (also block unmapped), use:
--   USING tenant_scope NOT IN ('pci', '')

CREATE ROW POLICY IF NOT EXISTS nonpci_logs_only ON otel.samples_v3
  USING tenant_scope != 'pci' TO user_nonpci;

-- ═══════════════════════════════════════════════════════════════
-- Step 7: Backfill unmapped rows (race condition fix)
-- ═══════════════════════════════════════════════════════════════
-- Fixes rows inserted before their fingerprint was in the dictionary.
-- Runs as a background mutation. No-op if no rows match.

ALTER TABLE otel.samples_v3
  UPDATE tenant_scope = dictGetOrDefault('otel.fingerprint_scope_dict', 'tenant_scope', fingerprint, '')
  WHERE tenant_scope = ''
    AND dictHas('otel.fingerprint_scope_dict', fingerprint);

SELECT 'Done. Row policy on samples_v3 only. Metrics and traces unrestricted.';
