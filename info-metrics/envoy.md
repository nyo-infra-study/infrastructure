# envoy — Metric Filter Decisions

> Version: 1.34.7
> Docs: https://www.envoyproxy.io/docs/envoy/v1.34.7/configuration/upstream/cluster_manager/cluster_stats
> Generated from: `output/*/parsed/envoy.csv`

---

| Use | Reason | component | metric_name | metric_type | description |
| --- | --- | --- | --- | --- | --- |
| ❌ | Total clusters added (either via static config or CDS) |  | `cluster_added` | Counter | Total clusters added (either via static config or CDS) |
| ❌ | Total clusters modified (via CDS) |  | `cluster_modified` | Counter | Total clusters modified (via CDS) |
| ❌ | Total clusters removed (via CDS) |  | `cluster_removed` | Counter | Total clusters removed (via CDS) |
| ❌ | Total cluster updates |  | `cluster_updated` | Counter | Total cluster updates |
| ❌ | Total cluster updates applied as merged updates |  | `cluster_updated_via_merge` | Counter | Total cluster updates applied as merged updates |
| ❌ | Total merged updates that got cancelled and delivered early |  | `update_merge_cancelled` | Counter | Total merged updates that got cancelled and delivered early |
| ❌ | Total updates which arrived out of a merge window |  | `update_out_of_merge_window` | Counter | Total updates which arrived out of a merge window |
| ❌ | Number of currently active (warmed) clusters |  | `active_clusters` | Gauge | Number of currently active (warmed) clusters |
| ❌ | Number of currently warming (not active) clusters In addi... |  | `warming_clusters` | Gauge | Number of currently warming (not active) clusters In addition to the cluster ... |
| ❌ | Number of clusters the worker has initialized. If using c... |  | `clusters_inflated` | Gauge | Number of clusters the worker has initialized. If using cluster deferral this... |
| ✅ | Total connections — capacity monitoring |  | `upstream_cx_total` | Counter | Total connections |
| ✅ | Active connections |  | `upstream_cx_active` | Gauge | Total active connections |
| ❌ | Total HTTP/1.1 connections |  | `upstream_cx_http1_total` | Counter | Total HTTP/1.1 connections |
| ❌ | Total HTTP/2 connections |  | `upstream_cx_http2_total` | Counter | Total HTTP/2 connections |
| ❌ | Total HTTP/3 connections |  | `upstream_cx_http3_total` | Counter | Total HTTP/3 connections |
| ✅ | Connection failures — core health |  | `upstream_cx_connect_fail` | Counter | Total connection failures |
| ✅ | Connection timeouts |  | `upstream_cx_connect_timeout` | Counter | Total connection connect timeouts |
| ❌ | Total connections able to send 0-rtt requests (early data). |  | `upstream_cx_connect_with_0_rtt` | Counter | Total connections able to send 0-rtt requests (early data). |
| ❌ | Total connection idle timeouts |  | `upstream_cx_idle_timeout` | Counter | Total connection idle timeouts |
| ❌ | Total connections closed due to max duration reached |  | `upstream_cx_max_duration_reached` | Counter | Total connections closed due to max duration reached |
| ❌ | Total consecutive connection failures exceeding configure... |  | `upstream_cx_connect_attempts_exceeded` | Counter | Total consecutive connection failures exceeding configured connection attempts |
| ✅ | Circuit breaker — connection overflow |  | `upstream_cx_overflow` | Counter | Total times that the cluster’s connection circuit breaker overflowed |
| ✅ | Connection establishment latency |  | `upstream_cx_connect_ms` | Histogram | Connection establishment milliseconds |
| ❌ | Connection length milliseconds |  | `upstream_cx_length_ms` | Histogram | Connection length milliseconds |
| ❌ | Total destroyed connections |  | `upstream_cx_destroy` | Counter | Total destroyed connections |
| ❌ | Total connections destroyed locally |  | `upstream_cx_destroy_local` | Counter | Total connections destroyed locally |
| ❌ | Total connections destroyed remotely |  | `upstream_cx_destroy_remote` | Counter | Total connections destroyed remotely |
| ✅ | Connections killed with in-flight requests |  | `upstream_cx_destroy_with_active_rq` | Counter | Total connections destroyed with 1+ active request |
| ❌ | Total connections destroyed locally with 1+ active request |  | `upstream_cx_destroy_local_with_active_rq` | Counter | Total connections destroyed locally with 1+ active request |
| ❌ | Total connections destroyed remotely with 1+ active request |  | `upstream_cx_destroy_remote_with_active_rq` | Counter | Total connections destroyed remotely with 1+ active request |
| ❌ | Total connections closed via HTTP/1.1 connection close he... |  | `upstream_cx_close_notify` | Counter | Total connections closed via HTTP/1.1 connection close header or HTTP/2 or HT... |
| ❌ | Total received connection bytes |  | `upstream_cx_rx_bytes_total` | Counter | Total received connection bytes |
| ❌ | Received connection bytes currently buffered |  | `upstream_cx_rx_bytes_buffered` | Gauge | Received connection bytes currently buffered |
| ❌ | Total sent connection bytes |  | `upstream_cx_tx_bytes_total` | Counter | Total sent connection bytes |
| ❌ | Send connection bytes currently buffered |  | `upstream_cx_tx_bytes_buffered` | Gauge | Send connection bytes currently buffered |
| ✅ | Circuit breaker — pool overflow |  | `upstream_cx_pool_overflow` | Counter | Total times that the cluster’s connection pool circuit breaker overflowed |
| ✅ | Protocol errors |  | `upstream_cx_protocol_error` | Counter | Total connection protocol errors |
| ❌ | Total connections closed due to maximum requests |  | `upstream_cx_max_requests` | Counter | Total connections closed due to maximum requests |
| ✅ | No healthy hosts available — critical |  | `upstream_cx_none_healthy` | Counter | Total times connection not established due to no healthy hosts |
| ✅ | Request rate and error rate per cluster |  | `upstream_rq_total` | Counter | Total requests |
| ✅ | Active requests — capacity monitoring |  | `upstream_rq_active` | Gauge | Total active requests |
| ✅ | Pending requests — connection pool pressure |  | `upstream_rq_pending_total` | Counter | Total requests pending a connection pool connection |
| ✅ | Circuit breaker — pending overflow |  | `upstream_rq_pending_overflow` | Counter | Total requests that overflowed connection pool or requests (mainly for HTTP/2... |
| ❌ | Total requests that were failed due to a connection pool ... |  | `upstream_rq_pending_failure_eject` | Counter | Total requests that were failed due to a connection pool connection failure o... |
| ❌ | Total active requests pending a connection pool connection |  | `upstream_rq_pending_active` | Gauge | Total active requests pending a connection pool connection |
| ✅ | Requests cancelled before getting a connection |  | `upstream_rq_cancelled` | Counter | Total requests cancelled before obtaining a connection pool connection |
| ✅ | Requests 503d due to maintenance mode |  | `upstream_rq_maintenance_mode` | Counter | Total requests that resulted in an immediate 503 due to maintenance mode |
| ✅ | Requests that timed out — latency issues |  | `upstream_rq_timeout` | Counter | Total requests that timed out waiting for a response |
| ✅ | Requests closed due to max duration |  | `upstream_rq_max_duration_reached` | Counter | Total requests closed due to max duration reached |
| ✅ | Per-try timeouts (hedging excluded) |  | `upstream_rq_per_try_timeout` | Counter | Total requests that hit the per try timeout (except when request hedging is e... |
| ✅ | Requests reset remotely — upstream issues |  | `upstream_rq_rx_reset` | Counter | Total requests that were reset remotely |
| ✅ | Requests reset locally — client/proxy issues |  | `upstream_rq_tx_reset` | Counter | Total requests that were reset locally |
| ✅ | Total retries — high rate = something wrong |  | `upstream_rq_retry` | Counter | Total request retries |
| ❌ | Total retries using the exponential backoff strategy |  | `upstream_rq_retry_backoff_exponential` | Counter | Total retries using the exponential backoff strategy |
| ✅ | Retries rate-limited by backoff |  | `upstream_rq_retry_backoff_ratelimited` | Counter | Total retries using the ratelimited backoff strategy |
| ✅ | Retries exhausted — gave up |  | `upstream_rq_retry_limit_exceeded` | Counter | Total requests not retried due to exceeding the configured number of maximum ... |
| ✅ | Retries that succeeded |  | `upstream_rq_retry_success` | Counter | Total request retry successes |
| ✅ | Circuit breaker — retry overflow |  | `upstream_rq_retry_overflow` | Counter | Total requests not retried due to circuit breaking or exceeding the retry budget |
| ❌ | Total number of times flow control paused reading from up... |  | `upstream_flow_control_paused_reading_total` | Counter | Total number of times flow control paused reading from upstream |
| ❌ | Total number of times flow control resumed reading from u... |  | `upstream_flow_control_resumed_reading_total` | Counter | Total number of times flow control resumed reading from upstream |
| ❌ | Total number of times the upstream connection backed up a... |  | `upstream_flow_control_backed_up_total` | Counter | Total number of times the upstream connection backed up and paused reads from... |
| ❌ | Total number of times the upstream connection drained and... |  | `upstream_flow_control_drained_total` | Counter | Total number of times the upstream connection drained and resumed reads from ... |
| ❌ | Total number of times failed internal redirects resulted ... |  | `upstream_internal_redirect_failed_total` | Counter | Total number of times failed internal redirects resulted in redirects being p... |
| ❌ | Total number of times internal redirects resulted in a se... |  | `upstream_internal_redirect_succeeded_total` | Counter | Total number of times internal redirects resulted in a second upstream request. |
| ❌ | Total cluster membership changes |  | `membership_change` | Counter | Total cluster membership changes |
| ✅ | Healthy backends in cluster |  | `membership_healthy` | Gauge | Current cluster healthy total (inclusive of both health checking and outlier ... |
| ✅ | Degraded backends |  | `membership_degraded` | Gauge | Current cluster |
| ❌ | Current cluster |  | `membership_excluded` | Gauge | Current cluster |
| ✅ | Total backends in cluster |  | `membership_total` | Gauge | Current cluster membership total |
| ❌ | Total number of times shadowing or retry buffering was ca... |  | `retry_or_shadow_abandoned` | Counter | Total number of times shadowing or retry buffering was canceled due to buffer... |
| ❌ | Total API fetches that resulted in a config reload due to... |  | `config_reload` | Counter | Total API fetches that resulted in a config reload due to a different config |
| ❌ | Total attempted cluster membership updates by service dis... |  | `update_attempt` | Counter | Total attempted cluster membership updates by service discovery |
| ❌ | Total successful cluster membership updates by service di... |  | `update_success` | Counter | Total successful cluster membership updates by service discovery |
| ❌ | Total failed cluster membership updates by service discovery |  | `update_failure` | Counter | Total failed cluster membership updates by service discovery |
| ❌ | Amount of time in milliseconds spent updating configs |  | `update_duration` | Histogram | Amount of time spent updating configs |
| ❌ | Total cluster membership updates ending with empty cluste... |  | `update_empty` | Counter | Total cluster membership updates ending with empty cluster load assignment an... |
| ❌ | Total successful cluster membership updates that didn’t r... |  | `update_no_rebuild` | Counter | Total successful cluster membership updates that didn’t result in any cluster... |
| ❌ | Hash of the contents from the last successful API fetch |  | `version` | Gauge | Hash of the contents from the last successful API fetch |
| ❌ | Current cluster warming state |  | `warming_state` | Gauge | Current cluster warming state |
| ❌ | Maximum weight of any host in the cluster |  | `max_host_weight` | Gauge | Maximum weight of any host in the cluster |
| ❌ | Total errors binding the socket to the configured source ... |  | `bind_errors` | Counter | Total errors binding the socket to the configured source address |
| ❌ | Total assignments received with endpoint lease information. |  | `assignment_timeout_received` | Counter | Total assignments received with endpoint lease information. |
| ❌ | Number of times the received assignments went stale befor... |  | `assignment_stale` | Counter | Number of times the received assignments went stale before new assignments ar... |
| ✅ | Health check attempts | HTTP/3 protocol stats are global with the following statistics: | `attempt` | Counter | Number of health checks |
| ✅ | Successful health checks | HTTP/3 protocol stats are global with the following statistics: | `success` | Counter | Number of successful health checks |
| ✅ | Failed health checks | HTTP/3 protocol stats are global with the following statistics: | `failure` | Counter | Number of immediately failed health checks (e.g. HTTP 503) as well as network... |
| ❌ | Number of health check failures due to passive events (e.... | HTTP/3 protocol stats are global with the following statistics: | `passive_failure` | Counter | Number of health check failures due to passive events (e.g. x-envoy-immediate... |
| ❌ | Number of health check failures due to network error | HTTP/3 protocol stats are global with the following statistics: | `network_failure` | Counter | Number of health check failures due to network error |
| ❌ | Number of health checks that attempted cluster name verif... | HTTP/3 protocol stats are global with the following statistics: | `verify_cluster` | Counter | Number of health checks that attempted cluster name verification |
| ✅ | Number of healthy members | HTTP/3 protocol stats are global with the following statistics: | `healthy` | Gauge | Number of healthy members Outlier detection statistics  If outlier detection... |
| ✅ | Total enforced ejections | HTTP/3 protocol stats are global with the following statistics: | `ejections_enforced_total` | Counter | Number of enforced ejections due to any outlier type |
| ✅ | Currently ejected hosts — outlier detection | HTTP/3 protocol stats are global with the following statistics: | `ejections_active` | Gauge | Number of currently ejected hosts |
| ✅ | Ejections aborted due to max ejection % | HTTP/3 protocol stats are global with the following statistics: | `ejections_overflow` | Counter | Number of ejections aborted due to the max ejection % |
| ❌ | Number of enforced consecutive 5xx ejections | HTTP/3 protocol stats are global with the following statistics: | `ejections_enforced_consecutive_5xx` | Counter | Number of enforced consecutive 5xx ejections |
| ❌ | Number of detected consecutive 5xx ejections (even if une... | HTTP/3 protocol stats are global with the following statistics: | `ejections_detected_consecutive_5xx` | Counter | Number of detected consecutive 5xx ejections (even if unenforced) |
| ❌ | Number of enforced success rate outlier ejections. Exact ... | HTTP/3 protocol stats are global with the following statistics: | `ejections_enforced_success_rate` | Counter | Number of enforced success rate outlier ejections. Exact meaning of this coun... |
| ❌ | Number of detected success rate outlier ejections (even i... | HTTP/3 protocol stats are global with the following statistics: | `ejections_detected_success_rate` | Counter | Number of detected success rate outlier ejections (even if unenforced). Exact... |
| ❌ | Number of enforced consecutive gateway failure ejections | HTTP/3 protocol stats are global with the following statistics: | `ejections_enforced_consecutive_gateway_failure` | Counter | Number of enforced consecutive gateway failure ejections |
| ❌ | Number of detected consecutive gateway failure ejections ... | HTTP/3 protocol stats are global with the following statistics: | `ejections_detected_consecutive_gateway_failure` | Counter | Number of detected consecutive gateway failure ejections (even if unenforced) |
| ❌ | Number of enforced consecutive local origin failure eject... | HTTP/3 protocol stats are global with the following statistics: | `ejections_enforced_consecutive_local_origin_failure` | Counter | Number of enforced consecutive local origin failure ejections |
| ❌ | Number of detected consecutive local origin failure eject... | HTTP/3 protocol stats are global with the following statistics: | `ejections_detected_consecutive_local_origin_failure` | Counter | Number of detected consecutive local origin failure ejections (even if unenfo... |
| ❌ | Number of enforced success rate outlier ejections for loc... | HTTP/3 protocol stats are global with the following statistics: | `ejections_enforced_local_origin_success_rate` | Counter | Number of enforced success rate outlier ejections for locally originated fail... |
| ❌ | Number of detected success rate outlier ejections for loc... | HTTP/3 protocol stats are global with the following statistics: | `ejections_detected_local_origin_success_rate` | Counter | Number of detected success rate outlier ejections for locally originated fail... |
| ❌ | Number of enforced failure percentage outlier ejections. ... | HTTP/3 protocol stats are global with the following statistics: | `ejections_enforced_failure_percentage` | Counter | Number of enforced failure percentage outlier ejections. Exact meaning of thi... |
| ❌ | Number of detected failure percentage outlier ejections (... | HTTP/3 protocol stats are global with the following statistics: | `ejections_detected_failure_percentage` | Counter | Number of detected failure percentage outlier ejections (even if unenforced).... |
| ❌ | Number of enforced failure percentage outlier ejections f... | HTTP/3 protocol stats are global with the following statistics: | `ejections_enforced_failure_percentage_local_origin` | Counter | Number of enforced failure percentage outlier ejections for locally originate... |
| ❌ | Number of detected failure percentage outlier ejections f... | HTTP/3 protocol stats are global with the following statistics: | `ejections_detected_failure_percentage_local_origin` | Counter | Number of detected failure percentage outlier ejections for locally originate... |
| ❌ | Deprecated. Number of ejections due to any outlier type (... | HTTP/3 protocol stats are global with the following statistics: | `ejections_total` | Counter | Deprecated. Number of ejections due to any outlier type (even if unenforced) |
| ❌ | Deprecated. Number of consecutive 5xx ejections (even if ... | HTTP/3 protocol stats are global with the following statistics: | `ejections_consecutive_5xx` | Counter | Deprecated. Number of consecutive 5xx ejections (even if unenforced) Circuit ... |
| ✅ | Connection circuit breaker tripped (0/1) | HTTP/3 protocol stats are global with the following statistics: | `cx_open` | Gauge | Whether the connection circuit breaker is under its concurrency limit (0) or ... |
| ❌ | Whether the connection pool circuit breaker is under its ... | HTTP/3 protocol stats are global with the following statistics: | `cx_pool_open` | Gauge | Whether the connection pool circuit breaker is under its concurrency limit (0... |
| ✅ | Pending request circuit breaker tripped (0/1) | HTTP/3 protocol stats are global with the following statistics: | `rq_pending_open` | Gauge | Whether the pending requests circuit breaker is under its concurrency limit (... |
| ✅ | Request circuit breaker tripped (0/1) | HTTP/3 protocol stats are global with the following statistics: | `rq_open` | Gauge | Whether the requests circuit breaker is under its concurrency limit (0) or is... |
| ✅ | Retry circuit breaker tripped (0/1) | HTTP/3 protocol stats are global with the following statistics: | `rq_retry_open` | Gauge | Whether the retry circuit breaker is under its concurrency limit (0) or is at... |
| ❌ | Number of remaining connections until the circuit breaker... | HTTP/3 protocol stats are global with the following statistics: | `remaining_cx` | Gauge | Number of remaining connections until the circuit breaker reaches its concurr... |
| ❌ | Number of remaining pending requests until the circuit br... | HTTP/3 protocol stats are global with the following statistics: | `remaining_pending` | Gauge | Number of remaining pending requests until the circuit breaker reaches its co... |
| ❌ | Number of remaining requests until the circuit breaker re... | HTTP/3 protocol stats are global with the following statistics: | `remaining_rq` | Gauge | Number of remaining requests until the circuit breaker reaches its concurrenc... |
| ❌ | Number of remaining retries until the circuit breaker rea... | HTTP/3 protocol stats are global with the following statistics: | `remaining_retries` | Gauge | Number of remaining retries until the circuit breaker reaches its concurrency... |
| ❌ | What percentage of the global timeout was used waiting fo... | HTTP/3 protocol stats are global with the following statistics: | `upstream_rq_timeout_budget_percent_used` | Histogram | What percentage of the global timeout was used waiting for a response |
| ❌ | What percentage of the per try timeout was used waiting f... | HTTP/3 protocol stats are global with the following statistics: | `upstream_rq_timeout_budget_per_try_percent_used` | Histogram | What percentage of the per try timeout was used waiting for a response Dynami... |
| ✅ | Total completed requests | HTTP/3 protocol stats are global with the following statistics: | `upstream_rq_completed` | Counter | Total upstream requests completed upstream_rq_&lt;*xx&gt; |
| ✅ | Request time histogram | HTTP/3 protocol stats are global with the following statistics: | `upstream_rq_time` | Histogram | Request time milliseconds |
| ❌ | Total upstream canary requests completed canary.upstream_... | HTTP/3 protocol stats are global with the following statistics: | `canary.upstream_rq_completed` | Counter | Total upstream canary requests completed canary.upstream_rq_&lt;*xx&gt; |
| ❌ | Upstream canary request time milliseconds | HTTP/3 protocol stats are global with the following statistics: | `canary.upstream_rq_time` | Histogram | Upstream canary request time milliseconds |
| ❌ | Total internal origin requests completed internal.upstrea... | HTTP/3 protocol stats are global with the following statistics: | `internal.upstream_rq_completed` | Counter | Total internal origin requests completed internal.upstream_rq_&lt;*xx&gt; |
| ❌ | Internal origin request time milliseconds | HTTP/3 protocol stats are global with the following statistics: | `internal.upstream_rq_time` | Histogram | Internal origin request time milliseconds |
| ❌ | Total external origin requests completed external.upstrea... | HTTP/3 protocol stats are global with the following statistics: | `external.upstream_rq_completed` | Counter | Total external origin requests completed external.upstream_rq_&lt;*xx&gt; |
| ❌ | External origin request time milliseconds | HTTP/3 protocol stats are global with the following statistics: | `external.upstream_rq_time` | Histogram | External origin request time milliseconds TLS statistics  If TLS is used by ... |
| ✅ | TLS connection errors | HTTP/3 protocol stats are global with the following statistics: | `connection_error` | Counter | Total TLS connection errors not including failed certificate verifications |
| ✅ | Successful TLS handshakes | HTTP/3 protocol stats are global with the following statistics: | `handshake` | Counter | Total successful TLS connection handshakes |
| ❌ | Total successful TLS session resumptions | HTTP/3 protocol stats are global with the following statistics: | `session_reused` | Counter | Total successful TLS session resumptions |
| ❌ | Total successful TLS connections with no client certificate | HTTP/3 protocol stats are global with the following statistics: | `no_certificate` | Counter | Total successful TLS connections with no client certificate |
| ✅ | TLS security — missing client cert | HTTP/3 protocol stats are global with the following statistics: | `fail_verify_no_cert` | Counter | Total TLS connections that failed because of missing client certificate |
| ✅ | TLS security — CA verification failure | HTTP/3 protocol stats are global with the following statistics: | `fail_verify_error` | Counter | Total TLS connections that failed CA verification |
| ✅ | TLS security — SAN mismatch | HTTP/3 protocol stats are global with the following statistics: | `fail_verify_san` | Counter | Total TLS connections that failed SAN verification |
| ✅ | TLS security — cert pinning failure | HTTP/3 protocol stats are global with the following statistics: | `fail_verify_cert_hash` | Counter | Total TLS connections that failed certificate pinning verification |
| ❌ | Total TLS connections that failed compliance with the OCS... | HTTP/3 protocol stats are global with the following statistics: | `ocsp_staple_failed` | Counter | Total TLS connections that failed compliance with the OCSP policy |
| ❌ | Total TLS connections that succeeded without stapling an ... | HTTP/3 protocol stats are global with the following statistics: | `ocsp_staple_omitted` | Counter | Total TLS connections that succeeded without stapling an OCSP response |
| ❌ | Total TLS connections where a valid OCSP response was ava... | HTTP/3 protocol stats are global with the following statistics: | `ocsp_staple_responses` | Counter | Total TLS connections where a valid OCSP response was available (irrespective... |
| ❌ | Total TLS connections where the client requested an OCSP ... | HTTP/3 protocol stats are global with the following statistics: | `ocsp_staple_requests` | Counter | Total TLS connections where the client requested an OCSP staple ciphers.&lt;c... |
| ❌ | Total successful TLS connections that used an invalid key... | HTTP/3 protocol stats are global with the following statistics: | `was_key_usage_invalid` | Counter | Total successful TLS connections that used an invalid keyUsage extension . (T... |
| ❌ | Total TCP segments transmitted | HTTP/3 protocol stats are global with the following statistics: | `cx_tx_segments` | Counter | Total TCP segments transmitted |
| ❌ | Total TCP segments received | HTTP/3 protocol stats are global with the following statistics: | `cx_rx_segments` | Counter | Total TCP segments received |
| ❌ | Total TCP segments with a non-zero data length transmitted | HTTP/3 protocol stats are global with the following statistics: | `cx_tx_data_segments` | Counter | Total TCP segments with a non-zero data length transmitted |
| ❌ | Total TCP segments with a non-zero data length received | HTTP/3 protocol stats are global with the following statistics: | `cx_rx_data_segments` | Counter | Total TCP segments with a non-zero data length received |
| ❌ | Total TCP segments retransmitted | HTTP/3 protocol stats are global with the following statistics: | `cx_tx_retransmitted_segments` | Counter | Total TCP segments retransmitted |
| ❌ | Total payload bytes received for which TCP acknowledgment... | HTTP/3 protocol stats are global with the following statistics: | `cx_rx_bytes_received` | Counter | Total payload bytes received for which TCP acknowledgments have been sent. |
| ❌ | Total payload bytes transmitted (including retransmitted ... | HTTP/3 protocol stats are global with the following statistics: | `cx_tx_bytes_sent` | Counter | Total payload bytes transmitted (including retransmitted bytes). |
| ❌ | Bytes which Envoy has sent to the operating system which ... | HTTP/3 protocol stats are global with the following statistics: | `cx_tx_unsent_bytes` | Gauge | Bytes which Envoy has sent to the operating system which have not yet been sent |
| ❌ | Segments which have been transmitted that have not yet be... | HTTP/3 protocol stats are global with the following statistics: | `cx_tx_unacked_segments` | Gauge | Segments which have been transmitted that have not yet been acknowledged |
| ❌ | Percent of segments on a connection which were retransmitted | HTTP/3 protocol stats are global with the following statistics: | `cx_tx_percent_retransmitted_segments` | Histogram | Percent of segments on a connection which were retransmistted |
| ❌ | Smoothed round trip time estimate in microseconds | HTTP/3 protocol stats are global with the following statistics: | `cx_rtt_us` | Histogram | Smoothed round trip time estimate in microseconds |
| ❌ | Estimated variance in microseconds of the round trip time... | HTTP/3 protocol stats are global with the following statistics: | `cx_rtt_variance_us` | Histogram | Estimated variance in microseconds of the round trip time. Higher values indi... |
| ❌ | The number of times locality aware routing structures are... | HTTP/3 protocol stats are global with the following statistics: | `lb_recalculate_zone_structures` | Counter | The number of times locality aware routing structures are regenerated for fas... |
| ❌ | Total requests load balanced with the load balancer in pa... | HTTP/3 protocol stats are global with the following statistics: | `lb_healthy_panic` | Counter | Total requests load balanced with the load balancer in panic mode |
| ❌ | No zone aware routing because of small upstream cluster size | HTTP/3 protocol stats are global with the following statistics: | `lb_zone_cluster_too_small` | Counter | No zone aware routing because of small upstream cluster size |
| ❌ | Sending all requests directly to the same zone | HTTP/3 protocol stats are global with the following statistics: | `lb_zone_routing_all_directly` | Counter | Sending all requests directly to the same zone |
| ❌ | Sending some requests to the same zone | HTTP/3 protocol stats are global with the following statistics: | `lb_zone_routing_sampled` | Counter | Sending some requests to the same zone |
| ❌ | Zone aware routing mode but have to send cross zone | HTTP/3 protocol stats are global with the following statistics: | `lb_zone_routing_cross_zone` | Counter | Zone aware routing mode but have to send cross zone |
| ❌ | Local host set is not set or it is panic mode for local c... | HTTP/3 protocol stats are global with the following statistics: | `lb_local_cluster_not_ok` | Counter | Local host set is not set or it is panic mode for local cluster |
| ❌ | Niche — zone-aware routing internals | HTTP/3 protocol stats are global with the following statistics: | `lb_zone_number_differs` | Counter | No zone aware routing because the feature flag is disabled and the number of ... |
| ❌ | Total number of times ended with random zone selection du... | HTTP/3 protocol stats are global with the following statistics: | `lb_zone_no_capacity_left` | Counter | Total number of times ended with random zone selection due to rounding error |
| ❌ | Total number of invalid hosts passed to original destinat... | HTTP/3 protocol stats are global with the following statistics: | `original_dst_host_invalid` | Counter | Total number of invalid hosts passed to original destination load balancer Lo... |
| ❌ | Number of currently available subsets | HTTP/3 protocol stats are global with the following statistics: | `lb_subsets_active` | Gauge | Number of currently available subsets |
| ❌ | Number of subsets created | HTTP/3 protocol stats are global with the following statistics: | `lb_subsets_created` | Counter | Number of subsets created |
| ❌ | Number of subsets removed due to no hosts | HTTP/3 protocol stats are global with the following statistics: | `lb_subsets_removed` | Counter | Number of subsets removed due to no hosts |
| ❌ | Number of times any subset was selected for load balancing | HTTP/3 protocol stats are global with the following statistics: | `lb_subsets_selected` | Counter | Number of times any subset was selected for load balancing |
| ❌ | Number of times the fallback policy was invoked | HTTP/3 protocol stats are global with the following statistics: | `lb_subsets_fallback` | Counter | Number of times the fallback policy was invoked |
| ❌ | Number of times the subset panic mode triggered | HTTP/3 protocol stats are global with the following statistics: | `lb_subsets_fallback_panic` | Counter | Number of times the subset panic mode triggered |
| ❌ | Number of duplicate (unused) hosts when using | HTTP/3 protocol stats are global with the following statistics: | `lb_subsets_single_host_per_subset_duplicate` | Gauge | Number of duplicate (unused) hosts when using |
| ❌ | Total number of host hashes on the ring | HTTP/3 protocol stats are global with the following statistics: | `size` | Gauge | Total number of host hashes on the ring |
| ❌ | Minimum number of hashes for a single host | HTTP/3 protocol stats are global with the following statistics: | `min_hashes_per_host` | Gauge | Minimum number of hashes for a single host |
| ❌ | Maximum number of hashes for a single host Maglev load ba... | HTTP/3 protocol stats are global with the following statistics: | `max_hashes_per_host` | Gauge | Maximum number of hashes for a single host Maglev load balancer statistics  ... |
| ❌ | Minimum number of entries for a single host | HTTP/3 protocol stats are global with the following statistics: | `min_entries_per_host` | Gauge | Minimum number of entries for a single host |
| ❌ | Maximum number of entries for a single host Request Respo... | HTTP/3 protocol stats are global with the following statistics: | `max_entries_per_host` | Gauge | Maximum number of entries for a single host Request Response Size statistics ... |
| ❌ | Request headers size in bytes per upstream | HTTP/3 protocol stats are global with the following statistics: | `upstream_rq_headers_size` | Histogram | Request headers size in bytes per upstream |
| ❌ | Request header count per upstream | HTTP/3 protocol stats are global with the following statistics: | `upstream_rq_headers_count` | Histogram | Request header count per upstream |
| ❌ | Request body size in bytes per upstream | HTTP/3 protocol stats are global with the following statistics: | `upstream_rq_body_size` | Histogram | Request body size in bytes per upstream |
| ❌ | Response headers size in bytes per upstream | HTTP/3 protocol stats are global with the following statistics: | `upstream_rs_headers_size` | Histogram | Response headers size in bytes per upstream |
| ❌ | Response header count per upstream | HTTP/3 protocol stats are global with the following statistics: | `upstream_rs_headers_count` | Histogram | Response header count per upstream |
| ❌ | Response body size in bytes per upstream Previous Next &#... | HTTP/3 protocol stats are global with the following statistics: | `upstream_rs_body_size` | Histogram | Response body size in bytes per upstream Previous Next &#169; Copyright 2016-... |
