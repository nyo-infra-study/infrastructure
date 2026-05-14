-- ============================================================
-- ClickHouse Row Policies Setup
-- ============================================================
-- Run this AFTER the OTel collector has written its first batch
-- (which triggers auto-creation of otel_logs, otel_traces, etc.)
--
-- Usage:
--   kubectl exec -n monitoring dev-monitoring-clickhouse-0 -- \
--     clickhouse-client --multiquery < setup-policies.sql
--
-- Or via a Kubernetes Job targeting the ClickHouse pod.
-- ============================================================

-- ═══════════════════════════════════════════════════════════════
-- Step 1: Materialize tenant_scope from ResourceAttributes Map
-- ═══════════════════════════════════════════════════════════════
-- This extracts compliance.scope into a top-level LowCardinality column.
-- New rows get it automatically. Existing rows need MATERIALIZE COLUMN.

ALTER TABLE otel.otel_logs
  ADD COLUMN IF NOT EXISTS `tenant_scope` LowCardinality(String)
  MATERIALIZED ResourceAttributes['compliance.scope'];

ALTER TABLE otel.otel_traces
  ADD COLUMN IF NOT EXISTS `tenant_scope` LowCardinality(String)
  MATERIALIZED ResourceAttributes['compliance.scope'];

ALTER TABLE otel.otel_metrics_gauge
  ADD COLUMN IF NOT EXISTS `tenant_scope` LowCardinality(String)
  MATERIALIZED ResourceAttributes['compliance.scope'];

ALTER TABLE otel.otel_metrics_sum
  ADD COLUMN IF NOT EXISTS `tenant_scope` LowCardinality(String)
  MATERIALIZED ResourceAttributes['compliance.scope'];

ALTER TABLE otel.otel_metrics_histogram
  ADD COLUMN IF NOT EXISTS `tenant_scope` LowCardinality(String)
  MATERIALIZED ResourceAttributes['compliance.scope'];

-- Backfill existing rows (optional, only needed if data was written before this script)
-- ALTER TABLE otel.otel_logs MATERIALIZE COLUMN tenant_scope;
-- ALTER TABLE otel.otel_traces MATERIALIZE COLUMN tenant_scope;
-- ALTER TABLE otel.otel_metrics_gauge MATERIALIZE COLUMN tenant_scope;
-- ALTER TABLE otel.otel_metrics_sum MATERIALIZE COLUMN tenant_scope;
-- ALTER TABLE otel.otel_metrics_histogram MATERIALIZE COLUMN tenant_scope;

-- ═══════════════════════════════════════════════════════════════
-- Step 2: Row policies — unrestricted user (sees everything)
-- ═══════════════════════════════════════════════════════════════

CREATE ROW POLICY IF NOT EXISTS all_access ON otel.otel_logs USING 1=1 TO user_all;
CREATE ROW POLICY IF NOT EXISTS all_access ON otel.otel_traces USING 1=1 TO user_all;
CREATE ROW POLICY IF NOT EXISTS all_access ON otel.otel_metrics_gauge USING 1=1 TO user_all;
CREATE ROW POLICY IF NOT EXISTS all_access ON otel.otel_metrics_sum USING 1=1 TO user_all;
CREATE ROW POLICY IF NOT EXISTS all_access ON otel.otel_metrics_histogram USING 1=1 TO user_all;

-- ═══════════════════════════════════════════════════════════════
-- Step 3: Row policies — non-PCI user (sees only non-pci data)
-- ═══════════════════════════════════════════════════════════════

CREATE ROW POLICY IF NOT EXISTS nonpci_only ON otel.otel_logs
  USING tenant_scope = 'non-pci' TO user_nonpci;
CREATE ROW POLICY IF NOT EXISTS nonpci_only ON otel.otel_traces
  USING tenant_scope = 'non-pci' TO user_nonpci;
CREATE ROW POLICY IF NOT EXISTS nonpci_only ON otel.otel_metrics_gauge
  USING tenant_scope = 'non-pci' TO user_nonpci;
CREATE ROW POLICY IF NOT EXISTS nonpci_only ON otel.otel_metrics_sum
  USING tenant_scope = 'non-pci' TO user_nonpci;
CREATE ROW POLICY IF NOT EXISTS nonpci_only ON otel.otel_metrics_histogram
  USING tenant_scope = 'non-pci' TO user_nonpci;

SELECT 'Done. Row policies applied successfully.';
