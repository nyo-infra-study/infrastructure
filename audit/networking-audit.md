# Networking Stack Dashboard - Metrics Audit

**Dashboard:** Networking Stack (`networking-stack`)  
**Audit Date:** 2026-06-13  
**Validated Against:** Local Grafana MCP  
**Status:** ✅ All panels validated (minor improvements recommended)

---

## Summary

| Category | Count |
|----------|-------|
| Total Panels with Queries | 19 |
| ✅ Correct | 19 |
| ⚠️ Minor Issues | 1 |
| ❌ Incorrect | 0 |

---

## Panel-by-Panel Audit

### Section: Traefik — Ingress Overview

#### Request Rate
- **Type:** stat
- **Expression:** `sum(rate(traefik_entrypoint_requests_total{entrypoint=~"$entrypoint"}[$__rate_interval]))`
- **Unit:** reqps
- **Audit:** ✅ **CORRECT**
  - Uses `$__rate_interval` ✓
  - Range query ✓
  - Metric exists and returns data ✓

#### Error Rate (4xx+5xx)
- **Type:** stat
- **Expression:** `sum(rate(traefik_entrypoint_requests_total{entrypoint=~"$entrypoint",code=~"4..|5.."}[$__rate_interval]))`
- **Audit:** ✅ **CORRECT**
  - Correctly filters HTTP error codes with regex

#### P50 / P95 / P99 / Avg Latency
- **Type:** stat (4 panels)
- **Expressions:** 
  - `histogram_quantile(0.50/0.95/0.99, sum(rate(..._bucket{...}[$__rate_interval])) by (le))`
  - Avg: `sum(rate(..._sum))` / `sum(rate(..._count))`
- **Unit:** s (seconds)
- **Audit:** ✅ **CORRECT**
  - Proper histogram percentile calculations
  - Average latency uses sum/count pattern correctly

#### Request Rate by Entrypoint
- **Type:** timeseries
- **Expression:** `sum by (entrypoint, method) (rate(traefik_entrypoint_requests_total{...}[$__rate_interval]))`
- **Audit:** ✅ **CORRECT**

#### Latency Heatmap (Entrypoint)
- **Type:** heatmap
- **Expression:** `sum(increase(traefik_entrypoint_request_duration_seconds_bucket{...}[$__rate_interval])) by (le)`
- **Audit:** ✅ **CORRECT**
  - Uses `increase()` for heatmap (appropriate for bucket counts)
  - Format set to `heatmap` ✓

---

### Section: Traefik — Services (Backend)

#### Request Rate by Service
- **Type:** timeseries
- **Expression:** `sum by (service) (rate(traefik_service_requests_total[$__rate_interval]))`
- **Audit:** ✅ **CORRECT**

#### Service Error Rate (4xx+5xx)
- **Type:** timeseries
- **Expressions:**
  - A: `sum by (service) (rate(traefik_service_requests_total{code=~"4.."}[$__rate_interval]))`
  - B: `sum by (service) (rate(traefik_service_requests_total{code=~"5.."}[$__rate_interval]))`
- **Audit:** ✅ **CORRECT**
  - Separates 4xx and 5xx for visibility

#### Service P95 / Avg Latency
- **Type:** timeseries (2 panels)
- **Audit:** ✅ **CORRECT**

---

### Section: Slow Traces (> 500ms)

#### Slow Traces
- **Type:** table
- **Datasource:** Tempo
- **Query:** `{duration > 500ms}` (TraceQL)
- **Audit:** ✅ **CORRECT**
  - TraceQL syntax correct
  - Limit of 20 traces reasonable
  - Sorted by duration descending

---

### Section: Traefik Access Logs

#### Access Logs (Traefik)
- **Type:** logs
- **Datasource:** Loki
- **Query:** `{k8s_namespace_name="traefik"} | json`
- **Audit:** ✅ **CORRECT**
  - Verified logs exist and contain structured JSON data
  - Includes Traefik access log fields (ClientAddr, Duration, RequestMethod, etc.)

---

### Section: CoreDNS

#### DNS Request Rate
- **Type:** timeseries
- **Expression:** `sum by (type) (rate(coredns_dns_requests_total[$__rate_interval]))`
- **Audit:** ✅ **CORRECT**
  - Metric exists: verified A, AAAA, TXT query types

#### DNS Response Codes
- **Type:** timeseries
- **Expression:** `sum by (rcode) (rate(coredns_dns_responses_total[$__rate_interval]))`
- **Audit:** ✅ **CORRECT**
  - Returns NOERROR, NXDOMAIN response codes

#### DNS Latency (P50 / P95 / P99)
- **Type:** timeseries
- **Expressions:** `histogram_quantile(0.50/0.95/0.99, sum(rate(coredns_dns_request_duration_seconds_bucket[$__rate_interval])) by (le))`
- **Audit:** ✅ **CORRECT**

#### DNS Cache Hit Rate
- **Type:** timeseries
- **Expression:** `sum(rate(coredns_cache_hits_total[$__rate_interval])) / (sum(rate(coredns_cache_hits_total[$__rate_interval])) + sum(rate(coredns_cache_misses_total[$__rate_interval])))`
- **Unit:** percentunit
- **Audit:** ✅ **CORRECT**
  - Both `coredns_cache_hits_total` and `coredns_cache_misses_total` exist
  - Formula correctly calculates hit/(hit+miss) ratio
  - Currently showing ~69% cache hit rate

---

### Section: Node Network I/O

#### Network Throughput (Receive / Transmit)
- **Type:** timeseries
- **Expressions:**
  - A: `sum(rate(node_network_receive_bytes_total{device!~"lo|veth.*|cali.*|flannel.*"}[$__rate_interval]))`
  - B: `sum(rate(node_network_transmit_bytes_total{device!~"lo|veth.*|cali.*|flannel.*"}[$__rate_interval]))`
- **Unit:** Bps (bytes per second)
- **Audit:** ✅ **CORRECT**
  - Correctly excludes loopback and virtual interfaces

#### Network Errors
- **Type:** timeseries
- **Expressions:**
  - A: `sum(rate(node_network_receive_errs_total{...}[$__rate_interval]))`
  - B: `sum(rate(node_network_transmit_errs_total{...}[$__rate_interval]))`
- **Unit:** short
- **Audit:** ⚠️ **MINOR** - Unit could be `errps` or `cps` for errors/count per second (currently `short`)

---

## Recommendations (Non-Critical)

1. **Add descriptions to panels** - All panels lack descriptions. Adding brief explanations would improve dashboard usability.

2. **Network Errors unit** - Consider changing from `short` to `errps` or `cps` for clarity.

3. **Add panel IDs** - All panels have `null` IDs. While not functionally broken, explicit IDs help with linking and troubleshooting.

---

## Metrics Validated via MCP

| Metric | Source | Status |
|--------|--------|--------|
| `traefik_entrypoint_requests_total` | Traefik | ✅ Returns data |
| `traefik_entrypoint_request_duration_seconds_bucket` | Traefik | ✅ Returns data |
| `traefik_service_requests_total` | Traefik | ✅ Returns data |
| `traefik_service_request_duration_seconds_bucket` | Traefik | ✅ Returns data |
| `coredns_dns_requests_total` | CoreDNS | ✅ Returns data (A, AAAA, TXT, other) |
| `coredns_dns_responses_total` | CoreDNS | ✅ Returns data (NOERROR, NXDOMAIN) |
| `coredns_dns_request_duration_seconds_bucket` | CoreDNS | ✅ Returns data |
| `coredns_cache_hits_total` | CoreDNS | ✅ Returns data |
| `coredns_cache_misses_total` | CoreDNS | ✅ Returns data |
| `node_network_receive_bytes_total` | Node Exporter | ✅ Returns data |
| `node_network_transmit_bytes_total` | Node Exporter | ✅ Returns data |
| `node_network_receive_errs_total` | Node Exporter | ✅ Returns data |
| `node_network_transmit_errs_total` | Node Exporter | ✅ Returns data |

## Datasources Validated

| Datasource | Type | Status |
|------------|------|--------|
| `$ds_prometheus` | Prometheus | ✅ Working |
| `$ds_tempo` | Tempo | ✅ Working |
| `$ds_loki` | Loki | ✅ Working (returns Traefik access logs) |

---

## Conclusion

The Networking Stack dashboard is well-constructed with no critical issues. All queries use proper patterns:
- ✅ `$__rate_interval` used consistently (no hardcoded intervals)
- ✅ Range queries used throughout (no problematic instant queries)
- ✅ All metrics exist and return data
- ✅ All datasources working
- ✅ Histogram calculations correct
- ✅ Counter vs gauge handling appropriate
