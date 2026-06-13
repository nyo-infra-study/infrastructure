# cert-manager — Metric Filter Decisions

> Version: 1.16.4
> Docs: https://github.com/cert-manager/cert-manager/blob/v1.16.4/pkg/metrics/metrics.go
> Generated from: `output/*/parsed/cert-manager.csv`

---

| Use | Reason | metric_name | metric_type | description |
| --- | --- | --- | --- | --- |
| ❌ | Deprecated | `certmanager_clock_time_seconds` | Counter | DEPRECATED: use clock_time_seconds_gauge instead. The clock time given in sec... |
| ❌ | Niche, not useful for monitoring | `certmanager_clock_time_seconds_gauge` | Gauge | The clock time given in seconds (from 1970/01/01 UTC). |
| ✅ | Core, alert before cert expiry | `certmanager_certificate_expiration_timestamp_seconds` | Gauge | The date after which the certificate expires. Expressed as a Unix Epoch Time. |
| ✅ | Core, track renewal timing | `certmanager_certificate_renewal_timestamp_seconds` | Gauge | The number of seconds before expiration time the certificate should renew. |
| ✅ | Core, alert on not-ready certs | `certmanager_certificate_ready_status` | Gauge | The ready status of the certificate. |
| ✅ | Track Let's Encrypt API usage | `certmanager_http_acme_client_request_count` | Counter | The number of requests made by the ACME client. |
| ✅ | Detect slow ACME responses | `certmanager_http_acme_client_request_duration_seconds` | Summary | The HTTP request latencies in seconds for the ACME client. |
| ❌ | Not using Venafi | `certmanager_http_venafi_client_request_duration_seconds` | Summary | ALPHA: The HTTP request latencies in seconds for the Venafi client. This metr... |
| ✅ | Reconciliation rate baseline | `certmanager_controller_sync_call_count` | Counter | The number of sync() calls made by a controller. |
| ✅ | Alert on sustained errors | `certmanager_controller_sync_error_count` | Counter | The number of errors encountered during controller sync(). |
