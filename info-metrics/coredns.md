# coredns — Metric Filter Decisions

> Version: 1.40.0
> Docs: https://github.com/coredns/coredns/blob/master/plugin/metrics/README.md
> Generated from: `output/*/parsed/coredns.csv`

---

| Use | Reason | metric_name | metric_type | labels | description |
| --- | --- | --- | --- | --- | --- |
| ✅ | Version tracking — correlate DNS issues with rollouts | `coredns_build_info` | Gauge | version, revision, goversion | info about CoreDNS itself |
| ✅ | Critical — any panic means DNS instability, alert on > 0 | `coredns_panics_total` | Counter |  | total number of panics |
| ✅ | Primary DNS throughput metric — rate() gives QPS | `coredns_dns_requests_total` | Counter | server, zone, view, proto, family, type | total query count |
| ✅ | DNS latency percentiles — slow DNS cascades to all services | `coredns_dns_request_duration_seconds` | Histogram | server, zone, view, type | duration to process each query |
| ✅ | Detects unusually large queries (potential abuse or misconfiguration) | `coredns_dns_request_size_bytes` | Histogram | server, zone, view, proto | size of the request in bytes. Uses the original size before any plugin rewrites |
| ✅ | DNSSEC-aware query volume — useful for security posture | `coredns_dns_do_requests_total` | Counter | server, view, zone | queries that have the DO bit set |
| ✅ | Detects large responses (NXDOMAIN storms, record bloat) | `coredns_dns_response_size_bytes` | Histogram | server, zone, view, proto | response size in bytes |
| ✅ | Response codes (NXDOMAIN, SERVFAIL, NOERROR) — key for error rate | `coredns_dns_responses_total` | Counter | server, zone, view, rcode, plugin | response per zone, rcode and plugin |
| ✅ | DoH response tracking — keep for completeness | `coredns_dns_https_responses_total` | Counter | server, status | responses per server and http status code |
| ✅ | DoQ response tracking — keep for completeness | `coredns_dns_quic_responses_total` | Counter | server, status | responses per server and QUIC application code |
| ✅ | Plugin inventory — verify expected plugins are active | `coredns_plugin_enabled` | Gauge | server, zone, view, name | indicates whether a plugin is enabled on per server, zone and view basis |
