# aws-lbc — Metric Filter Decisions

> Version: 2.13.4
> Docs: https://github.com/kubernetes-sigs/aws-load-balancer-controller/tree/v2.13.4/pkg/metrics
> Generated from: `output/*/parsed/aws-lbc.csv`

---

| Use | Reason | metric_name | metric_type | description |
| --- | --- | --- | --- | --- |
| ✅ | Core, track LB registration time | `awslbc_readiness_gate_ready_seconds` | Histogram | Latency from pod getting added to the load balancer until the readiness gate ... |
| ✅ | Core, alert on reconcile failures | `awslbc_controller_reconcile_errors_total` | Counter | Counts the number of reconcile error, categorized by error type. |
| ✅ | Core, identify slow stages | `awslbc_controller_reconcile_stage_duration` | Histogram | latencies of different reconcile stages. |
| ❌ | Niche, rare | `awslbc_webhook_validation_failure_total` | Counter | Counts the number of webhook validation failure, categorized by error type. |
| ❌ | Niche, rare | `awslbc_webhook_mutation_failure_total` | Counter | Counts the number of webhook mutation failure, categorized by error type. |
| ❌ | Niche, internal detail | `awslbc_controller_cache_object_total` | Gauge | Counts the number of objects in the controller cache. |
| ❌ | Niche, debugging only | `awslbc_controller_top_talkers` | Gauge | Counts the number of reconciliations triggered per resource |
| ✅ | Core, AWS API call volume | `aws_api_calls_total` | Counter | Total number of SDK API calls from the customer's code to AWS services |
| ✅ | Core, detect slow AWS calls | `aws_api_call_duration_seconds` | Histogram | Perceived latency from when your code makes an SDK call, includes retries |
| ✅ | Core, high retries indicate throttling | `aws_api_call_retries` | Histogram | Number of times the SDK retried requests to AWS services for SDK API calls |
| ❌ | Redundant with api_calls_total | `aws_api_requests_total` | Counter | Total number of HTTP requests that the SDK made |
| ❌ | Redundant with api_call_duration | `aws_api_request_duration_seconds` | Histogram | Latency of an individual HTTP request to the service endpoint |
| ✅ | Core, alert on IAM issues | `aws_api_call_permission_errors_total` | Counter | Number of failed AWS API calls due to auth or authrorization failures |
| ✅ | Core, alert on AWS limits | `aws_api_call_service_limit_exceeded_errors_total` | Counter | Number of failed AWS API calls due to exceeding servce limit |
| ✅ | Core, alert on AWS throttling | `aws_api_call_throttled_errors_total` | Counter | Number of failed AWS API calls due to throtting error |
| ✅ | Core, detect bad configs | `aws_api_call_validation_errors_total` | Counter | Number of failed AWS API calls due to validation error |
