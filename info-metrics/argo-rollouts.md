# argo-rollouts — Metric Filter Decisions

> Version: 1.8.2
> Docs: https://argo-rollouts.readthedocs.io/en/release-1.8/features/controller-metrics/
> Generated from: `output/*/parsed/argo-rollouts.csv`

---

| Use | Reason | component | metric_name | description |
| --- | --- | --- | --- | --- |
| ✅ | Core — rollout state visibility | rollout | `rollout_info` | Information about rollout. |
| ✅ | Core — track rollout progress | rollout | `rollout_info_replicas_available` | The number of available replicas per rollout. |
| ✅ | Core — detect stuck rollouts | rollout | `rollout_info_replicas_unavailable` | The number of unavailable replicas per rollout. |
| ✅ | Core — compare desired vs available | rollout | `rollout_info_replicas_desired` | The number of desired replicas per rollout. |
| ✅ | Core — track canary/blue-green progress | rollout | `rollout_info_replicas_updated` | The number of updated replicas per rollout. |
| ❌ | Deprecated — use rollout_info instead | rollout | `rollout_phase` | DEPRECATED - use rollout_info |
| ✅ | Core — detect slow reconciliation | rollout | `rollout_reconcile` | Rollout reconciliation performance. |
| ✅ | Core — alert on reconciliation failures | rollout | `rollout_reconcile_error` | Error occurring during the rollout. |
| ✅ | Core — experiment state visibility | rollout | `experiment_info` | Information about Experiment. |
| ❌ | Redundant — experiment_info covers this | rollout | `experiment_phase` | Information on the state of the experiment. |
| ✅ | Core — detect slow experiments | rollout | `experiment_reconcile` | Experiments reconciliation performance. |
| ✅ | Core — alert on experiment failures | rollout | `experiment_reconcile_error` | Error occurring during the experiment. |
| ✅ | Core — analysis run state | rollout | `analysis_run_info` | Information about analysis run. |
| ✅ | Core — track individual metric results | rollout | `analysis_run_metric_phase` | Information on the duration of a specific metric in the Analysis Run. |
| ❌ | Static info — type doesn't change | rollout | `analysis_run_metric_type` | Information on the type of a specific metric in the Analysis Runs. |
| ✅ | Core — detect failed analysis runs | rollout | `analysis_run_phase` | Information on the state of the Analysis Run. |
| ✅ | Core — detect slow analysis | rollout | `analysis_run_reconcile` | Analysis Run reconciliation performance. |
| ✅ | Core — alert on analysis failures | rollout | `analysis_run_reconcile_error` | Error occurring during the analysis run. |
| ✅ | Core — API call volume and error rate | controller | `controller_clientset_k8s_request_total` | Number of kubernetes requests executed during application reconciliation. |
| ✅ | Incoming work rate | controller | `workqueue_adds_total` | Total number of adds handled by workqueue |
| ✅ | Core — growing depth means controller can't keep up | controller | `workqueue_depth` | Current depth of workqueue |
| ❌ | Niche — depth is sufficient for backlog detection | controller | `workqueue_queue_duration_seconds` | How long in seconds an item stays in workqueue before being requested. |
| ❌ | Niche — reconcile histogram covers this | controller | `workqueue_work_duration_seconds` | How long in seconds processing an item from workqueue takes. |
| ❌ | Niche — reconcile metrics are more specific | controller | `workqueue_unfinished_work_seconds` | How many seconds of work has done that is in progress and hasn't been observe... |
| ❌ | Niche — reconcile metrics are more specific | controller | `workqueue_longest_running_processor_seconds` | How many seconds has the longest running processor for workqueue been running |
| ❌ | Niche — reconcile_error is more actionable | controller | `workqueue_retries_total` | Total number of retries handled by workqueue |
