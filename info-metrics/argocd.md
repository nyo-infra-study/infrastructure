# argocd — Metric Filter Decisions

> Version: 2.14.5
> Docs: https://argo-cd.readthedocs.io/en/release-2.14/operator-manual/metrics/
> Generated from: `output/*/parsed/argocd.csv`

---

| Use | Reason | component | metric_name | metric_type | description |
| --- | --- | --- | --- | --- | --- |
| ✅ | Primary app health/sync status — the most important ArgoCD metric | Application Controller Metrics&para; | `argocd_app_info` | Gauge | Information about Applications. It contains labels such as sync_status and he... |
| ✅ | App error conditions — surfaces degraded/invalid states | Application Controller Metrics&para; | `argocd_app_condition` | Gauge | Report Applications conditions. It contains the conditions currently present ... |
| ✅ | Core — K8s API call volume during reconciliation | Application Controller Metrics&para; | `argocd_app_k8s_request_total` | Counter | Number of Kubernetes requests executed during application reconciliation |
| ❌ | Disabled by default; high cardinality label mirror — use app_info instead | Application Controller Metrics&para; | `argocd_app_labels` | Gauge | Argo Application labels converted to Prometheus labels. Disabled by default. ... |
| ✅ | Drift detection — orphaned resources indicate manual changes | Application Controller Metrics&para; | `argocd_app_orphaned_resources_count` | Gauge | Number of orphaned resources per application. |
| ✅ | Reconciliation latency — slow reconciles delay sync convergence | Application Controller Metrics&para; | `argocd_app_reconcile` | Histogram | Application reconciliation performance in seconds. |
| ✅ | Sync frequency and success/failure rate per app | Application Controller Metrics&para; | `argocd_app_sync_total` | Counter | Counter for application sync history |
| ✅ | Cache size — growing objects may cause memory pressure | Application Controller Metrics&para; | `argocd_cluster_api_resource_objects` | Gauge | Number of k8s resource objects in the cache. |
| ✅ | Scope of monitoring — correlate with controller load | Application Controller Metrics&para; | `argocd_cluster_api_resources` | Gauge | Number of monitored Kubernetes API resources. |
| ✅ | Stale cache detection — old cache means delayed drift detection | Application Controller Metrics&para; | `argocd_cluster_cache_age_seconds` | Gauge | Cluster cache age in seconds. |
| ✅ | Cluster reachability — alert on disconnected clusters | Application Controller Metrics&para; | `argocd_cluster_connection_status` | Gauge | The k8s cluster current connection status. |
| ✅ | Event processing rate — baseline for cluster activity | Application Controller Metrics&para; | `argocd_cluster_events_total` | Counter | Number of processes k8s resource events. |
| ✅ | Cluster metadata — version, server URL for inventory | Application Controller Metrics&para; | `argocd_cluster_info` | Gauge | Information about cluster. |
| ✅ | Kubectl exec queue depth — detect backpressure in app controller sync operations. Used in dashboard | Application Controller Metrics&para; | `argocd_kubectl_exec_pending` | Gauge | Number of pending kubectl executions |
| ✅ | Kubectl exec rate — track volume of kubectl calls during reconciliation. Used in dashboard | Application Controller Metrics&para; | `argocd_kubectl_exec_total` | Counter | Number of kubectl executions |
| ✅ | Redis latency (app controller) — slow Redis degrades all operations | Application Controller Metrics&para; | `argocd_redis_request_duration` | Histogram | Redis requests duration. |
| ✅ | Redis call volume (app controller) — detect excessive cache calls | Application Controller Metrics&para; | `argocd_redis_request_total` | Counter | Number of redis requests executed during application reconciliation |
| ❌ | Internal event processing — covered by app_reconcile latency | Application Controller Metrics&para; | `argocd_resource_events_processing` | Histogram | Time to process resource events in batch in seconds |
| ❌ | Internal batch size detail — not actionable for operators | Application Controller Metrics&para; | `argocd_resource_events_processed_in_batch` | Gauge | Number of resource events processed in batch |
| ✅ | ApplicationSet inventory and status | Application Set Controller metrics&para; | `argocd_appset_info` | Gauge | Information about Application Sets. It contains labels for the name and names... |
| ✅ | AppSet reconciliation latency — slow reconciles delay app generation | Application Set Controller metrics&para; | `argocd_appset_reconcile` | Histogram | Application reconciliation performance in seconds. It contains labels for the... |
| ❌ | Disabled by default; high cardinality — use appset_info instead | Application Set Controller metrics&para; | `argocd_appset_labels` | Gauge | Applicationset labels translated to Prometheus labels. Disabled by default |
| ✅ | AppSet fan-out count — detect unexpected app count changes | Application Set Controller metrics&para; | `argocd_appset_owned_applications` | Gauge | Number of applications owned by the applicationset. It contains labels for th... |
| ✅ | Redis latency (app controller) — slow Redis degrades all operations | API Server Metrics&para; | `argocd_redis_request_duration` | Histogram | Redis requests duration. |
| ✅ | Redis call volume (app controller) — detect excessive cache calls | API Server Metrics&para; | `argocd_redis_request_total` | Counter | Number of Kubernetes requests executed during application reconciliation. |
| ❌ | Niche — gRPC internals | API Server Metrics&para; | `grpc_server_handled_total` | Counter | Total number of RPCs completed on the server, regardless of success or failure. |
| ❌ | Niche — gRPC internals | API Server Metrics&para; | `grpc_server_msg_sent_total` | Counter | Total number of gRPC stream messages sent by the server. |
| ❌ | Proxy extension traffic — niche feature, not commonly used | API Server Metrics&para; | `argocd_proxy_extension_request_total` | Counter | Number of requests sent to the configured proxy extensions. |
| ❌ | Proxy extension latency — niche feature | API Server Metrics&para; | `argocd_proxy_extension_request_duration_seconds` | Histogram | Request duration in seconds between the Argo CD API server and the proxy exte... |
| ✅ | Git fetch latency — slow git = slow syncs | Repo Server Metrics&para; | `argocd_git_request_duration_seconds` | Histogram | Git requests duration seconds. |
| ✅ | Git request volume — baseline for failure rate | Repo Server Metrics&para; | `argocd_git_request_total` | Counter | Number of git requests performed by repo server |
| ✅ | Git fetch failures — alert on rising failures | Repo Server Metrics&para; | `argocd_git_fetch_fail_total` | Counter | Number of git fetch requests failures by repo server |
| ✅ | Redis latency (repo server) — slow Redis degrades manifest generation | Repo Server Metrics&para; | `argocd_redis_request_duration_seconds` | Histogram | Redis requests duration seconds. |
| ✅ | Redis call volume (app controller) — detect excessive cache calls | Repo Server Metrics&para; | `argocd_redis_request_total` | Counter | Number of Kubernetes requests executed during application reconciliation. |
| ✅ | Repo lock contention — high pending = bottleneck | Repo Server Metrics&para; | `argocd_repo_pending_request_total` | Gauge | Number of pending requests requiring repository lock |
| ❌ | Commit server internals — niche feature (write-back) | Commit Server Metrics&para; | `argocd_commitserver_commit_pending_request_total` | Guage | Number of pending commit requests. |
| ❌ | Commit server git latency — niche feature | Commit Server Metrics&para; | `argocd_commitserver_git_request_duration_seconds` | Histogram | Git requests duration seconds. |
| ❌ | Commit server git calls — niche feature | Commit Server Metrics&para; | `argocd_commitserver_git_request_total` | Counter | Number of git requests performed by commit server |
| ❌ | Commit server commit latency — niche feature | Commit Server Metrics&para; | `argocd_commitserver_commit_request_duration_seconds` | Histogram | Commit requests duration seconds. |
| ❌ | Commit server userinfo latency — niche feature | Commit Server Metrics&para; | `argocd_commitserver_userinfo_request_duration_seconds` | Histogram | Userinfo requests duration seconds. |
| ❌ | Commit server commit calls — niche feature | Commit Server Metrics&para; | `argocd_commitserver_commit_request_total` | Counter | Number of commit requests performed by commit server |
