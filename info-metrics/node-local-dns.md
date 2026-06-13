# node-local-dns — Metric Filter Decisions

> Version: 1.23.0
> Docs: https://github.com/coredns/coredns/tree/master/plugin
> Generated from: `output/*/parsed/node-local-dns.csv`

---

| Use | Reason | component | metric_name | description |
| --- | --- | --- | --- | --- |
| ❌ | Static — check once | node-local-dns-2-README | `coredns_build_info` | {version, revision, goversion} - info about CoreDNS itself |
| ❌ | Niche — rare edge case | node-local-dns-README | `coredns_cache_drops_total` | {server, zones, view} - Counter of responses excluded from the cache due to r... |
| ✅ | Cache size monitoring | node-local-dns-README | `coredns_cache_entries` | {server, type, zones, view} - Total elements in the cache by cache type |
| ❌ | Niche — cache_entries is sufficient for sizing | node-local-dns-README | `coredns_cache_evictions_total` | {server, type, zones, view} - Counter of cache evictions |
| ✅ | Core — cache effectiveness | node-local-dns-README | `coredns_cache_hits_total` | {server, type, zones, view} - Counter of cache hits by cache type |
| ✅ | Core — miss rate = upstream load | node-local-dns-README | `coredns_cache_misses_total` | {server, zones, view} - Counter of cache misses. - Deprecated, derive misses ... |
| ❌ | Niche — optimization detail | node-local-dns-README | `coredns_cache_prefetch_total` | {server, zones, view} - Counter of times the cache has prefetched a cached item |
| ✅ | Core — total cache lookups | node-local-dns-README | `coredns_cache_requests_total` | {server, zones, view} - Counter of cache requests |
| ❌ | Niche — unless serve_stale is configured | node-local-dns-README | `coredns_cache_served_stale_total` | {server, zones, view} - Counter of requests served from stale cache entries |
| ❌ | Niche | node-local-dns-2-README | `coredns_dns_do_requests_total` | {server, view, zone} -  queries that have the DO bit set |
| ❌ | Not using DoH on local cache | node-local-dns-2-README | `coredns_dns_https_responses_total` | {server, status} - responses per server and http status code |
| ❌ | Not using DoQ on local cache | node-local-dns-2-README | `coredns_dns_quic_responses_total` | {server, status} - responses per server and QUIC application code |
| ✅ | Core — local cache latency (should be sub-ms) | node-local-dns-2-README | `coredns_dns_request_duration_seconds` | {server, zone, view, type} - duration to process each query |
| ❌ | Niche — not useful for a cache layer | node-local-dns-2-README | `coredns_dns_request_size_bytes` | {server, zone, view, proto} - size of the request in bytes. Uses the original... |
| ✅ | Core — cache QPS per node | node-local-dns-2-README | `coredns_dns_requests_total` | {server, zone, view, proto, family, type} - total query count |
| ❌ | Niche — not useful for a cache layer | node-local-dns-2-README | `coredns_dns_response_size_bytes` | {server, zone, view, proto} - response size in bytes |
| ✅ | Core — response code distribution | node-local-dns-2-README | `coredns_dns_responses_total` | {server, zone, view, rcode, plugin} - response per zone, rcode and plugin |
| ✅ | Core — alert on total upstream failure | node-local-dns-1-README | `coredns_forward_healthcheck_broken_total` | {} - count of when all upstreams are unhealthy, |
| ❌ | Niche — broken_total is the actionable one | node-local-dns-1-README | `coredns_forward_healthcheck_failures_total` | {to, rcode} |
| ❌ | Niche — rare unless misconfigured | node-local-dns-1-README | `coredns_forward_max_concurrent_rejects_total` | {} - count of queries rejected because the |
| ✅ | Core — upstream CoreDNS latency as seen from node | node-local-dns-1-README | `coredns_forward_request_duration_seconds` | {to, rcode} |
| ✅ | Core — upstream forwarding rate | node-local-dns-1-README | `coredns_forward_requests_total` | Can be replaced with sum(coredns_proxy_request_duration_seconds_count{proxy_n... |
| ✅ | Core — upstream response rate | node-local-dns-1-README | `coredns_forward_responses_total` | {to, rcode} |
| ❌ | Rare — alert from upstream CoreDNS is sufficient | node-local-dns-2-README | `coredns_panics_total` | {} - total number of panics |
| ❌ | Static — check once | node-local-dns-2-README | `coredns_plugin_enabled` | {server, zone, view, name} - indicates whether a plugin is enabled on per ser... |
| ❌ | Niche — connection pooling detail | node-local-dns-1-README | `coredns_proxy_conn_cache_hits_total` | {proxy_name="forward", to, proto}- count of connection cache hits per upstrea... |
| ❌ | Niche — connection pooling detail | node-local-dns-1-README | `coredns_proxy_conn_cache_misses_total` | {proxy_name="forward", to, proto} - count of connection cache misses per upst... |
| ❌ | Redundant — forward_healthcheck covers this | node-local-dns-1-README | `coredns_proxy_healthcheck_failures_total` | {proxy_name="forward", to, rcode}- count of failed health checks per upstream |
| ❌ | Redundant — forward_request_duration covers this | node-local-dns-1-README | `coredns_proxy_request_duration_seconds` | {proxy_name="forward", to, rcode} - histogram per upstream, RCODE |
| ❌ | Redundant — forward_requests_total covers this | node-local-dns-1-README | `coredns_proxy_request_duration_seconds_count` | {proxy_name="forward", to, rcode} |
