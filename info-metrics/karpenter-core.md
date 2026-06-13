# karpenter-core — Metric Filter Decisions

> Version: 1.9.0
> Docs: https://github.com/kubernetes-sigs/karpenter/tree/v1.9.0/pkg/metrics
> Generated from: `output/*/parsed/karpenter-core.csv`

---

| Use | Reason | metric_name | metric_type | description |
| --- | --- | --- | --- | --- |
| ✅ | Core — nodepool resource ceiling, alert when usage approaches limit. Used in EaglePoint dashboard | `karpenter_nodepools_limit` | Gauge | Limits specified on the nodepool that restrict the quantity of resources prov... |
| ✅ | Core — current resource consumption per nodepool, compare with limit for capacity planning. Used in EaglePoint dashboard | `karpenter_nodepools_usage` | Gauge | The amount of resources that have been provisioned for a nodepool. Labeled by... |
| ✅ | Cost visibility — track nodepool spend over time | `karpenter_nodepools_cost_total` | Gauge | Total cost of the nodepool from Karpenter's perspective. Units are determined... |
| ✅ | Core — nodeclaim creation rate, correlate with scaling events. Used in EaglePoint dashboard | `karpenter_nodeclaims_created_total` | Counter | Number of nodeclaims created in total by Karpenter. Labeled by reason the nod... |
| ✅ | Core — nodeclaim termination rate, track churn. Used in EaglePoint dashboard | `karpenter_nodeclaims_terminated_total` | Counter | Number of nodeclaims terminated in total by Karpenter. Labeled by the owning ... |
| ✅ | Core — disruption events, detect spot interruptions and consolidation activity | `karpenter_nodeclaims_disrupted_total` | Counter | Number of nodeclaims disrupted in total by Karpenter. Labeled by reason the n... |
| ✅ | Core — node creation rate, correlate with pending pods | `karpenter_nodes_created_total` | Counter | Number of nodes created in total by Karpenter. Labeled by owning nodepool. |
| ✅ | Core — node termination rate, track consolidation and spot replacement | `karpenter_nodes_terminated_total` | Counter | Number of nodes terminated in total by Karpenter. Labeled by owning nodepool. |
| ✅ | Core — allocatable resources per node, needed for utilization calculations. Used in EaglePoint dashboard | `karpenter_nodes_allocatable` | Gauge | Node allocatable are the resources allocatable by nodes. |
| ✅ | Core — total pod requests per node, compare with allocatable for bin-packing efficiency. Used in EaglePoint dashboard | `karpenter_nodes_total_pod_requests` | Gauge | Node total pod requests are the resources requested by pods bound to nodes, i... |
| ✅ | Core — total pod limits per node, detect over-committed nodes | `karpenter_nodes_total_pod_limits` | Gauge | Node total pod limits are the resources specified by pod limits, including th... |
| ❌ | Niche — daemon overhead is relatively static, check via kubectl if needed | `karpenter_nodes_total_daemon_requests` | Gauge | Node total daemon requests are the resource requested by DaemonSet pods bound... |
| ❌ | Niche — daemon limits rarely change | `karpenter_nodes_total_daemon_limits` | Gauge | Node total daemon limits are the resources specified by DaemonSet pod limits. |
| ❌ | Niche — system overhead is relatively static | `karpenter_nodes_system_overhead` | Gauge | Node system daemon overhead are the resources reserved for system overhead, t... |
| ❌ | Niche — node age available from kube_node_created | `karpenter_cluster_current_lifetime_seconds` | Gauge | Node age in seconds |
| ✅ | Core — cluster-wide utilization, key capacity planning metric | `karpenter_cluster_utilization_percent` | Gauge | Utilization of allocatable resources by pod requests |
| ✅ | Core — pod state distribution across the cluster, detect scheduling issues. Used in EaglePoint dashboard | `karpenter_pods_state` | Gauge | Pod state is the current state of pods. This metric can be used several ways ... |
| ✅ | Core — pod startup latency, detect slow scheduling or image pulls | `karpenter_pods_startup_duration_seconds` | Summary | The time from pod creation until the pod is running. |
| ❌ | Redundant with startup_duration_seconds (gauge version of same data) | `karpenter_pods_unstarted_time_seconds` | Gauge | The time from pod creation until the pod is running. |
| ✅ | Core — pod bind latency, detect scheduler bottlenecks | `karpenter_pods_bound_duration_seconds` | Histogram | The time from pod creation until the pod is bound. |
| ❌ | Redundant with bound_duration_seconds (gauge version of same data) | `karpenter_pods_unbound_time_seconds` | Gauge | The time from pod creation until the pod is bound. |
| ❌ | Niche — provisioning-specific view, startup_duration is sufficient | `karpenter_pods_provisioning_bound_duration_seconds` | Histogram | The time from when Karpenter first thinks the pod can schedule until it binds... |
| ❌ | Redundant gauge version | `karpenter_pods_provisioning_unbound_time_seconds` | Gauge | The time from when Karpenter first thinks the pod can schedule until it binds... |
| ❌ | Niche — provisioning-specific view, startup_duration is sufficient | `karpenter_pods_provisioning_startup_duration_seconds` | Histogram | The time from when Karpenter first thinks the pod can schedule until the pod ... |
| ❌ | Redundant gauge version | `karpenter_pods_provisioning_unstarted_time_seconds` | Gauge | The time from when Karpenter first thinks the pod can schedule until the pod ... |
| ❌ | Niche — scheduling decision timing, not needed for standard monitoring | `karpenter_pods_provisioning_scheduling_undecided_time_seconds` | Gauge | The time from when Karpenter has seen a pod without making a scheduling decis... |
