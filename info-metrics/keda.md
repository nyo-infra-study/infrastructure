# keda — Metric Filter Decisions

> Version: 2.17.0
> Docs: https://keda.sh/docs/2.17/integrations/prometheus/
> Generated from: `output/*/parsed/keda.csv`

---

| Use | Reason | component | metric_name | description |
| --- | --- | --- | --- | --- |
| ✅ | Version tracking — correlate issues with rollouts | operator | `keda_build_info` | Info metric, with static information about KEDA build like: version, git comm... |
| ✅ | Core — detect scalers that stopped working | operator | `keda_scaler_active` | This metric marks whether the particular scaler is active (value == 1) or in-... |
| ✅ | Core — detect accidentally paused autoscaling | operator | `keda_scaled_object_paused` | This metric indicates whether a ScaledObject is paused (value == 1) or un-pau... |
| ✅ | Core — observe what KEDA sees vs actual scaling decisions | operator | `keda_scaler_metrics_value` | The current value for each scaler&rsquo;s metric that would be used by the HP... |
| ✅ | Performance — slow scaler queries delay scaling decisions | operator | `keda_scaler_metrics_latency_seconds` | The latency of retrieving current metric from each scaler. |
| ✅ | Core — alert on sustained scaler errors | operator | `keda_scaler_detail_errors_total` | The number of errors encountered for each scaler. |
| ✅ | Core — alert on ScaledObject-level failures | operator | `keda_scaled_object_errors_total` | The number of errors that have occurred for each ScaledObject. |
| ✅ | Core — alert on ScaledJob-level failures | operator | `keda_scaled_job_errors_total` | The number of errors that have occurred for each ScaledJob. |
| ✅ | Inventory — track ScaledObject/ScaledJob count | operator | `keda_resource_registered_total` | Total number of KEDA custom resources per namespace for each custom resource ... |
| ✅ | Inventory — track trigger type distribution | operator | `keda_trigger_registered_total` | Total number of triggers per trigger type handled by the operator. |
| ✅ | Performance — high latency means scaling decisions are delayed | operator | `keda_internal_scale_loop_latency_seconds` | Total deviation (in seconds) between the expected execution time and the actu... |
| ❌ | Not using CloudEvents integration | operator | `keda_cloudeventsource_events_emitted_total` | Measured emitted cloudevents with destination of this emitted event (eventsin... |
| ❌ | Not using CloudEvents integration | operator | `keda_cloudeventsource_events_queued` | The number of events that are in the emitting queue. |
| ❌ | Internal — covered by scaler-level metrics | operator | `keda_internal_metricsservice_grpc_server_started_total` | Total number of RPCs started on the server. |
| ❌ | Internal — covered by scaler-level metrics | operator | `keda_internal_metricsservice_grpc_server_handled_total` | Total number of RPCs completed on the server, regardless of success or failure. |
| ❌ | Internal — too granular | operator | `keda_internal_metricsservice_grpc_server_msg_received_total` | Total number of RPC stream messages received on the server. |
| ❌ | Internal — too granular | operator | `keda_internal_metricsservice_grpc_server_msg_sent_total` | Total number of gRPC stream messages sent by the server. |
| ❌ | Internal — scale_loop_latency is the useful metric | operator | `keda_internal_metricsservice_grpc_server_handling_seconds` | Histogram of response latency (seconds) of gRPC that had been application-lev... |
| ✅ | Track validation activity — baseline for error rate | admission | `keda_webhook_scaled_object_validation_total` | The current value for scaled object validations. |
| ✅ | Alert on validation failures — broken ScaledObject specs | admission | `keda_webhook_scaled_object_validation_errors` | The number of validation errors. |
| ❌ | Internal — deprecated in favor of operator metrics | metrics-server | `keda_internal_metricsservice_grpc_client_started_total` | Total number of RPCs started on the client. |
| ❌ | Internal — deprecated in favor of operator metrics | metrics-server | `keda_internal_metricsservice_grpc_client_handled_total` | Total number of RPCs completed by the client, regardless of success or failure. |
| ❌ | Internal — deprecated in favor of operator metrics | metrics-server | `keda_internal_metricsservice_grpc_client_msg_received_total` | Total number of RPC stream messages received by the client. |
| ❌ | Internal — deprecated in favor of operator metrics | metrics-server | `keda_internal_metricsservice_grpc_client_msg_sent_total` | Total number of gRPC stream messages sent by the client. |
| ❌ | Internal — deprecated in favor of operator metrics | metrics-server | `keda_internal_metricsservice_grpc_client_handling_seconds` | Histogram of response latency (seconds) of the gRPC until it is finished by t... |
