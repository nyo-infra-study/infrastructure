# kyverno — Metric Filter Decisions

> Version: 3.1.3
> Docs: https://kyverno.io/docs/reference/metrics/
> Generated from: `output/*/parsed/kyverno.csv`

---

| Use | Reason | metric_name | metric_type | description |
| --- | --- | --- | --- | --- |
| ✅ | Policy inventory — verify expected rules are loaded | `kyverno_policy_rule_info_total` | Gauge | 1 for rules currently actively present in the cluster. Metric Labels Section ... |
| ✅ | Primary enforcement metric — pass/fail/warn counts per policy | `kyverno_policy_results` | Counter | An only-increasing integer representing the number of results/executions asso... |
| ✅ | Rule execution latency — slow rules delay admission | `kyverno_policy_execution_duration_seconds_sum` | Histogram | A float value representing the latency of the rule’s execution in seconds. |
| ✅ | Histogram buckets for rule execution latency percentiles | `kyverno_policy_execution_duration_seconds_bucket` | Histogram | A float value representing the latency of the rule’s execution in seconds. |
| ✅ | Validation-specific latency — most common policy type | `kyverno_validating_policy_execution_duration_seconds_sum` | Histogram | A float value representing the latency of the validating policy’s execution i... |
| ✅ | Histogram buckets for validation latency percentiles | `kyverno_validating_policy_execution_duration_seconds_bucket` | Histogram | A float value representing the latency of the validating policy’s execution i... |
| ✅ | Mutation-specific latency — mutations add webhook overhead | `kyverno_mutating_policy_execution_duration_seconds_sum` | Histogram | A float value representing the latency of the mutating policy’s execution in ... |
| ✅ | Histogram buckets for mutation latency percentiles | `kyverno_mutating_policy_execution_duration_seconds_bucket` | Histogram | A float value representing the latency of the mutating policy’s execution in ... |
| ✅ | Generate-policy latency — tracks resource creation overhead | `kyverno_generating_policy_execution_duration_seconds_sum` | Histogram | A float value representing the latency of the generating policy’s execution i... |
| ✅ | Histogram buckets for generate-policy latency percentiles | `kyverno_generating_policy_execution_duration_seconds_bucket` | Histogram | A float value representing the latency of the generating policy’s execution i... |
| ✅ | Image verification latency — can be slow due to registry calls | `kyverno_image_validating_policy_execution_duration_seconds_sum` | Histogram | A float value representing the latency of the image validating policy’s execu... |
| ✅ | Histogram buckets for image validation latency percentiles | `kyverno_image_validating_policy_execution_duration_seconds_bucket` | Histogram | A float value representing the latency of the image validating policy’s execu... |
| ✅ | Policy churn — correlate with enforcement changes | `kyverno_policy_changes_total` | Counter | An only-increasing integer representing the total number of policy-level chan... |
| ✅ | Admission webhook throughput — rate of requests hitting Kyverno | `kyverno_admission_requests_total` | Counter | An only-increasing integer representing the count of admission requests assoc... |
| ✅ | End-to-end admission latency — impacts all K8s API writes | `kyverno_admission_review_duration_seconds_sum` | Histogram | A float value representing the latency of the admission review in seconds. |
| ✅ | Histogram buckets for admission review latency percentiles | `kyverno_admission_review_duration_seconds_bucket` | Histogram | A float value representing the latency of the admission review in seconds. |
| ✅ | HTTP request volume to Kyverno webhook server | `kyverno_http_requests_total` | Counter | An only-increasing integer representing the count of http requests associated... |
| ✅ | HTTP handler latency — includes serialization overhead | `kyverno_http_requests_duration_seconds_sum` | Histogram | A float value representing the latency of the HTTP request processing in seco... |
| ✅ | Histogram buckets for HTTP handler latency percentiles | `kyverno_http_requests_duration_seconds_bucket` | Histogram | A float value representing the latency of the HTTP request processing in seco... |
| ✅ | Controller reconciliation throughput — baseline for error rate | `kyverno_controller_reconcile_total` | Counter | An only-increasing integer representing the count of reconciliations performed. |
| ✅ | Requeue pressure — high requeues indicate transient failures | `kyverno_controller_requeue_total` | Counter | An only-increasing integer representing the number of items requeued. |
| ✅ | Dropped items — critical, means policies may not be enforced | `kyverno_controller_drop_total` | Counter | An only-increasing integer representing the number of items dropped. |
| ✅ | Cleanup activity — tracks automated resource cleanup | `kyverno_cleanup_controller_deletedobjects_total` | Counter | An only-increasing integer representing the number of objects deleted by the ... |
| ✅ | Cleanup failures — resources may not be cleaned up | `kyverno_cleanup_controller_errors_total` | Counter | An only-increasing integer representing the number of errors encountered by t... |
| ✅ | TTL-based cleanup activity — tracks expiry-driven deletions | `kyverno_ttl_controller_deletedobjects` | Counter | An only-increasing integer representing the number of objects deleted by the ... |
| ✅ | TTL cleanup failures — expired resources may linger | `kyverno_ttl_controller_errors` | Counter | An only-increasing integer representing the number of errors encountered by t... |
| ✅ | Deletion policy activity — tracks policy-driven deletions | `kyverno_deleting_controller_deletedobjects_total` | Counter | An only-increasing integer representing the number of objects deleted by dele... |
| ✅ | Deletion policy failures — resources may not be removed | `kyverno_deleting_controller_errors_total` | Counter | An only-increasing integer representing the number of errors encountered by t... |
| ✅ | K8s API client call volume — detect excessive API calls | `kyverno_client_queries_total` | Counter | An only-increasing integer representing the total number of policy-level chan... |
| ✅ | Version/build info — correlate issues with Kyverno releases | `kyverno_info` | Gauge | A constant value of 1 with labels to include relevant information |
