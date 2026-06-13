# otel-collector — Metric Filter Decisions

> Version: 0.150.1
> Docs: https://opentelemetry.io/docs/collector/internal-telemetry
> Generated from: `output/*/parsed/otel-collector.csv`

---

| Use | Reason | metric_name | metric_type | description |
| --- | --- | --- | --- | --- |
| ✅ | Core — queue overflow detection | `otelcol_exporter_enqueue_failed_spans` | Counter | Number of logs that exporter(s) failed to enqueue. |
| ✅ | Core — queue overflow detection | `otelcol_exporter_enqueue_failed_metric_points` | Counter | Number of logs that exporter(s) failed to enqueue. |
| ✅ | Core — queue overflow detection | `otelcol_exporter_enqueue_failed_log_records` | Counter | Number of logs that exporter(s) failed to enqueue. |
| ✅ | Core — queue saturation = capacity vs size | `otelcol_exporter_queue_capacity` | Gauge | Fixed capacity of the sending queue, in batches. |
| ✅ | Core — growing queue = backpressure | `otelcol_exporter_queue_size` | Gauge | Current size of the sending queue, in batches. |
| ✅ | Core — alert on export failures | `otelcol_exporter_send_failed_spans` | Counter | Number of logs that exporter(s) failed to send to destination. |
| ✅ | Core — alert on export failures | `otelcol_exporter_send_failed_metric_points` | Counter | Number of logs that exporter(s) failed to send to destination. |
| ✅ | Core — alert on export failures | `otelcol_exporter_send_failed_log_records` | Counter | Number of logs that exporter(s) failed to send to destination. |
| ✅ | Core — data egress monitoring | `otelcol_exporter_sent_log_records` | Counter | Number of logs successfully sent to destination. |
| ✅ | Core — data egress monitoring | `otelcol_exporter_sent_metric_points` | Counter | Number of metric points successfully sent to destination. |
| ✅ | Core — data egress monitoring | `otelcol_exporter_sent_spans` | Counter | Number of spans successfully sent to destination. |
| ✅ | Resource usage monitoring | `otelcol_process_cpu_seconds` | Counter | Total CPU user and system time in seconds. |
| ✅ | Resource usage — detect memory leaks | `otelcol_process_memory_rss` | Gauge | Total physical memory (resident set size) in bytes. |
| ✅ | Go heap monitoring — detect memory pressure | `otelcol_process_runtime_heap_alloc_bytes` | Gauge | Bytes of allocated heap objects (see &lsquo;go doc runtime.MemStats.HeapAlloc... |
| ❌ | Niche — heap_alloc is sufficient for monitoring | `otelcol_process_runtime_total_alloc_bytes` | Counter | Cumulative bytes allocated for heap objects (see &lsquo;go doc runtime.MemSta... |
| ❌ | Niche — RSS is the useful memory metric | `otelcol_process_runtime_total_sys_memory_bytes` | Counter | Cumulative bytes allocated for heap objects (see &lsquo;go doc runtime.MemSta... |
| ✅ | Core — detect restarts | `otelcol_process_uptime` | Counter | Uptime of the process in seconds. |
| ❌ | Redundant — covered by receiver_accepted + exporter_sent | `otelcol_processor_incoming_items` | Counter | Number of items passed to the processor. |
| ❌ | Redundant — covered by receiver_accepted + exporter_sent | `otelcol_processor_outgoing_items` | Counter | Number of items emitted from the processor. |
| ✅ | Core — data flow monitoring | `otelcol_receiver_accepted_spans` | Counter | Number of logs successfully ingested and pushed into the pipeline. |
| ✅ | Core — data flow monitoring | `otelcol_receiver_accepted_metric_points` | Counter | Number of logs successfully ingested and pushed into the pipeline. |
| ✅ | Core — data flow monitoring | `otelcol_receiver_accepted_log_records` | Counter | Number of logs successfully ingested and pushed into the pipeline. |
| ✅ | Core — alert on sustained refusals | `otelcol_receiver_refused_spans` | Counter | Number of logs that could not be pushed into the pipeline. |
| ✅ | Core — alert on sustained refusals | `otelcol_receiver_refused_metric_points` | Counter | Number of logs that could not be pushed into the pipeline. |
| ✅ | Core — alert on sustained refusals | `otelcol_receiver_refused_log_records` | Counter | Number of logs that could not be pushed into the pipeline. |
| ❌ | Niche — scrape errors are rare | `otelcol_scraper_errored_metric_points` | Counter | Number of metric points the Collector failed to scrape. |
| ❌ | Niche — only relevant for prometheus self-scrape | `otelcol_scraper_scraped_metric_points` | Counter | Number of metric points scraped by the Collector. |
| ✅ | Batch efficiency — detect undersized batches | `otelcol_processor_batch_batch_send_size` | Histogram | Number of units in the batch that was sent. |
| ✅ | Batch behavior — size vs timeout ratio | `otelcol_processor_batch_batch_size_trigger_send` | Counter | Number of times the batch was sent due to a size trigger. |
| ❌ | Niche — only relevant for metadata-keyed batching | `otelcol_processor_batch_metadata_cardinality` | Counter | Number of distinct metadata value combinations being processed. |
| ✅ | Batch behavior — high timeout ratio = low throughput | `otelcol_processor_batch_timeout_trigger_send` | Counter | Number of times the batch was sent due to a timeout trigger. |
| ❌ | Detailed — too granular for production | `http.client.request.body.size` | Counter | Measures the size of HTTP client request bodies. |
| ❌ | Detailed — covered by exporter send metrics | `http.client.request.duration` | Histogram | Measures the duration of HTTP client requests. |
| ❌ | Detailed — too granular for production | `http.server.request.body.size` | Counter | Measures the size of HTTP server request bodies. |
| ❌ | Detailed — covered by receiver accepted metrics | `http.server.request.duration` | Histogram | Measures the duration of HTTP server requests. |
| ❌ | Detailed — too granular for production | `http.server.response.body.size` | Counter | Measures the size of HTTP server response bodies. |
| ❌ | Detailed — covered by exporter send metrics | `rpc.client.call.duration` | Histogram | Measures the duration of outbound remote procedure calls (RPC). |
| ❌ | Detailed — covered by receiver accepted metrics | `rpc.server.call.duration` | Histogram | Measures the duration of inbound remote procedure calls (RPC). |
