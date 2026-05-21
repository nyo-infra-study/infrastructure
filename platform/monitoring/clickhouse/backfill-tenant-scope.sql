-- ============================================================
-- Backfill tenant_scope for unmapped rows
-- ============================================================
-- Run periodically (every 5 min) to fix rows that were inserted
-- before their fingerprint appeared in the dictionary.
--
-- Usage (CronJob or manual):
--   kubectl exec -n monitoring dev-monitoring-clickhouse-0 -- \
--     clickhouse-client --password clickhouse123 --multiquery \
--     < infrastructure/platform/monitoring/clickhouse/backfill-tenant-scope.sql
--
-- This is a lightweight mutation — only rewrites parts that have
-- tenant_scope = '' AND the fingerprint now exists in the mapping.
-- If no rows match, it's a no-op (no parts rewritten).
-- ============================================================

-- Only update rows where:
-- 1. tenant_scope is empty (wasn't resolved at insert time)
-- 2. The fingerprint now exists in the mapping table (dictionary has it)
ALTER TABLE otel.samples_v3
  UPDATE tenant_scope = dictGetOrDefault('otel.fingerprint_scope_dict', 'tenant_scope', fingerprint, '')
  WHERE tenant_scope = ''
    AND dictHas('otel.fingerprint_scope_dict', fingerprint);

SELECT 'Backfill mutation submitted (runs asynchronously).';
