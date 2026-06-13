# argo-workflows — Metric Filter Decisions

> Version: 3.7.2
> Docs: https://argo-workflows.readthedocs.io/en/latest/metrics/
> Generated from: `output/*/parsed/argo-workflows.csv`

---

| Use | Reason | metric_name | metric_type | description |
| --- | --- | --- | --- | --- |
| ❌ | Niche — rate limiter not enabled by default | `client_rate_limiter_latency` | Histogram | A histogram of the time spent waiting for the client-side rate limiter. Recor... |
| ✅ | Core — detect concurrency policy activations | `cronworkflows_concurrencypolicy_triggered` | Counter | A counter of the number of times a CronWorkflow has triggered its concurrency... |
| ✅ | Core — cron workflow execution rate | `cronworkflows_triggered_total` | Counter | A counter of the total number of times a CronWorkflow has been triggered. Sup... |
| ✅ | Core — track deprecated feature usage before upgrades | `deprecated_feature` |  | Incidents of deprecated feature being used. Deprecated features are explained... |
| ✅ | Core — controller error rate by cause | `error_count` | Counter | A counter of certain errors incurred by the controller by cause |
| ✅ | Core — workflow count by phase (Running/Pending/Failed) | `gauge` | Gauge | A gauge of the number of workflows currently in the cluster in each phase. Th... |
| ✅ | Core — detect leader election issues | `is_leader` | Gauge | Emits 1 if leader, 0 otherwise. Always 1 if leader election is disabled. A ga... |
| ✅ | Core — K8s API latency from workflow controller | `k8s_request_duration` | Histogram | A histogram recording the API requests sent to the Kubernetes API |
| ❌ | Redundant — calculable from k8s_request_duration | `k8s_request_total` | Counter | A counter of the number of API requests sent to the Kubernetes API |
| ❌ | Niche, use log pipeline instead | `log_messages` |  | A count of log messages emitted by the controller by log level: error , warn ... |
| ✅ | Core — workflow reconciliation loop performance | `operation_duration_seconds` | Histogram | A histogram of durations of operations. An operation is a single workflow rec... |
| ✅ | Core — detect pods deleted unexpectedly under load | `pod_missing` | Counter | Incidents of pod missing. A counter of pods that were not seen - for example ... |
| ✅ | Core — detect scheduling issues | `pod_pending_count` |  | Total number of pods that started pending by reason |
| ✅ | Core — infrastructure failure restarts | `pod_restarts_total` |  | Total number of pods automatically restarted due to infrastructure failures b... |
| ✅ | Core — actual running pods vs workflow phase | `pods_gauge` | Gauge | A gauge of the number of workflow created pods currently in the cluster in ea... |
| ❌ | Niche — pods_gauge is more actionable | `pods_total_count` |  | Total number of pods that have entered each phase |
| ✅ | Incoming work rate | `queue_adds_count` | Counter | A counter of additions to the work queues inside the controller. The rate of ... |
| ✅ | Core — detect backlog | `queue_depth_gauge` | Gauge | A gauge of the current depth of the queues. If these get large then the workf... |
| ❌ | Niche, depth is sufficient | `queue_duration` | Histogram | A histogram of the time events in the queues are taking to be processed |
| ❌ | Niche, depth is sufficient | `queue_latency` | Histogram | A histogram of the time events in the queues are taking before they are proce... |
| ❌ | Niche | `queue_longest_running` | Gauge | A gauge of the number of seconds that this queue's longest running processor ... |
| ❌ | Niche | `queue_retries` | Counter | A counter of the number of times a message has been retried in the queue |
| ❌ | Niche | `queue_unfinished_work` | Gauge | A gauge of the number of queue items that have not been processed yet |
| ❌ | Niche — rate limiter not enabled by default | `resource_rate_limiter_latency` | Histogram | A histogram of the delay duration from the resource creation rate limiter. Re... |
| ✅ | Core — workflow lifecycle tracking by phase | `total_count` | Counter | A counter of workflows that have entered each phase for tracking them through... |
| ❌ | Static — check once | `version` |  | Build metadata for this Controller |
| ✅ | Core — worker saturation | `workers_busy_count` | Gauge | A gauge of queue workers that are busy |
| ✅ | Core — detect unhealthy workflows | `workflow_condition` | Gauge | A gauge of the number of workflows with different conditions. This will tell ... |
| ❌ | High cardinality — per-template name label | `workflowtemplate_runtime` | Histogram | A histogram of the runtime of workflows using workflowTemplateRef only. Count... |
| ❌ | High cardinality — per-template name label | `workflowtemplate_triggered_total` | Counter | A counter of workflows using workflowTemplateRef only, as they enter each pha... |
