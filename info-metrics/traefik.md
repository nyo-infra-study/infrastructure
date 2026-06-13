# traefik — Metric Filter Decisions

> Version: 3.4.1
> Docs: https://doc.traefik.io/traefik/v3.4/observability/metrics/overview/
> Generated from: `output/*/parsed/traefik.csv`

---

| Use | Reason | component | metric_name | metric_type | description |
| --- | --- | --- | --- | --- | --- |
| ✅ | Tracks config reload frequency — spikes indicate config churn or errors | Global | `traefik_config_reloads_total` | Counter | Total count of configuration reloads |
| ✅ | Detects stale config — alert if reload hasn't succeeded recently | Global | `traefik_config_last_reload_success` | Gauge | Timestamp of last configuration reload success |
| ✅ | Connection saturation monitoring per entrypoint | Global | `traefik_open_connections` | Gauge | Current count of open connections by entrypoint and protocol |
| ✅ | Certificate expiry alerting — critical for avoiding outages | Global | `traefik_tls_certs_not_after` | Gauge | Expiration date of certificates |
| ✅ | Top-level request rate per entrypoint — primary traffic metric | EntryPoint | `traefik_entrypoint_requests_total` | Counter | Total count of HTTP requests received by entrypoint |
| ✅ | TLS vs non-TLS traffic split visibility | EntryPoint | `traefik_entrypoint_requests_tls_total` | Counter | Total count of HTTPS requests received by entrypoint |
| ✅ | Entrypoint-level latency percentiles (p50/p95/p99) | EntryPoint | `traefik_entrypoint_request_duration_seconds` | Histogram | Request processing duration on entrypoint |
| ✅ | Inbound bandwidth per entrypoint | EntryPoint | `traefik_entrypoint_requests_bytes_total` | Counter | Total size of HTTP requests in bytes by entrypoint |
| ✅ | Outbound bandwidth per entrypoint | EntryPoint | `traefik_entrypoint_responses_bytes_total` | Counter | Total size of HTTP responses in bytes by entrypoint |
| ✅ | Per-route request rate — identifies hot routes | Router | `traefik_router_requests_total` | Counter | Total count of HTTP requests handled by router |
| ✅ | TLS traffic per route | Router | `traefik_router_requests_tls_total` | Counter | Total count of HTTPS requests handled by router |
| ✅ | Per-route latency — pinpoints slow routes | Router | `traefik_router_request_duration_seconds` | Histogram | Request processing duration on router |
| ✅ | Inbound bandwidth per route | Router | `traefik_router_requests_bytes_total` | Counter | Total size of HTTP requests in bytes by router |
| ✅ | Outbound bandwidth per route | Router | `traefik_router_responses_bytes_total` | Counter | Total size of HTTP responses in bytes by router |
| ✅ | Per-backend request rate — key for service-level monitoring | Service | `traefik_service_requests_total` | Counter | Total count of HTTP requests processed by service |
| ✅ | TLS traffic per backend service | Service | `traefik_service_requests_tls_total` | Counter | Total count of HTTPS requests processed by service |
| ✅ | Backend latency — isolates slow services from proxy overhead | Service | `traefik_service_request_duration_seconds` | Histogram | Request processing duration on service |
| ✅ | Retry storms indicate unhealthy backends | Service | `traefik_service_retries_total` | Counter | Count of request retries on service |
| ✅ | Backend health — alert on server_up == 0 | Service | `traefik_service_server_up` | Gauge | Current server status 0=down 1=up |
| ✅ | Inbound bandwidth per backend | Service | `traefik_service_requests_bytes_total` | Counter | Total size of requests in bytes by service |
| ✅ | Outbound bandwidth per backend | Service | `traefik_service_responses_bytes_total` | Counter | Total size of responses in bytes by service |
