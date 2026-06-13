# karpenter — Metric Filter Decisions

> Version: 1.9.0
> Docs: https://karpenter.sh/docs/reference/metrics/
> Generated from: `output/*/parsed/karpenter.csv`

---

| Use | Reason | metric_name | default_enabled | description |
| --- | --- | --- | --- | --- |
| ✅ | Core — version tracking | `karpenter_build_info` | STABLE | A metric with a constant &lsquo;1&rsquo; value labeled by version from which ... |
| ✅ | Core — unhealthy disruptions, alert on spikes | `karpenter_nodeclaims_unhealthy_disrupted_total` | ALPHA | Number of unhealthy nodeclaims disrupted in total by Karpenter. Labeled by co... |
| ✅ | Core — termination latency | `karpenter_nodeclaims_termination_duration_seconds` | BETA | Duration of NodeClaim termination in seconds. |
| ✅ | Core — nodeclaim termination rate | `karpenter_nodeclaims_terminated_total` | STABLE | Number of nodeclaims terminated in total by Karpenter. Labeled by the owning ... |
| ✅ | Core — cloud instance termination latency | `karpenter_nodeclaims_instance_termination_duration_seconds` | BETA | Duration of CloudProvider Instance termination in seconds. |
| ✅ | Core — disruption events | `karpenter_nodeclaims_disrupted_total` | ALPHA | Number of nodeclaims disrupted in total by Karpenter. Labeled by reason the n... |
| ✅ | Core — nodeclaim creation rate | `karpenter_nodeclaims_created_total` | STABLE | Number of nodeclaims created in total by Karpenter. Labeled by reason the nod... |
| ❌ | Niche — operatorpkg termination timing | `operator_nodeclaim_termination_duration_seconds` | BETA | The amount of time taken by an object to terminate completely. |
| ❌ | Niche — current termination gauge | `operator_nodeclaim_termination_current_time_seconds` | BETA | The current amount of time in seconds that an object has been in terminating ... |
| ✅ | Core — condition transitions, detect flapping | `operator_nodeclaim_status_condition_transitions_total` | BETA | The count of transitions of a given object, type and status. |
| ❌ | Niche — transition timing detail | `operator_nodeclaim_status_condition_transition_seconds` | BETA | The amount of time a condition was in a given state before transitioning. e.g... |
| ❌ | Niche — current status duration | `operator_nodeclaim_status_condition_current_status_seconds` | BETA | The current amount of time in seconds that a status condition has been in a s... |
| ❌ | Niche — operatorpkg condition counts | `operator_nodeclaim_status_condition_count` | BETA | The number of a condition for a given object, type and status. e.g. Alarm := ... |
| ✅ | Core — utilization calculation | `karpenter_nodes_total_pod_requests` | BETA | Node total pod requests are the resources requested by pods bound to nodes, i... |
| ✅ | Core — over-commit detection | `karpenter_nodes_total_pod_limits` | BETA | Node total pod limits are the resources specified by pod limits, including th... |
| ❌ | Niche — daemon overhead is static | `karpenter_nodes_total_daemon_requests` | BETA | Node total daemon requests are the resource requested by DaemonSet pods bound... |
| ❌ | Niche — daemon overhead is static | `karpenter_nodes_total_daemon_limits` | BETA | Node total daemon limits are the resources specified by DaemonSet pod limits. |
| ✅ | Core — node termination latency | `karpenter_nodes_termination_duration_seconds` | BETA | The time taken between a node&rsquo;s deletion request and the removal of its... |
| ✅ | Core — node termination rate | `karpenter_nodes_terminated_total` | STABLE | Number of nodes terminated in total by Karpenter. Labeled by owning nodepool. |
| ❌ | Niche — system overhead is static | `karpenter_nodes_system_overhead` | BETA | Node system daemon overhead are the resources reserved for system overhead, t... |
| ❌ | Niche — node age, not actionable | `karpenter_nodes_lifetime_duration_seconds` | ALPHA | The lifetime duration of the nodes since creation. |
| ✅ | Core — drain events during disruption | `karpenter_nodes_drained_total` | ALPHA | The total number of nodes drained by Karpenter |
| ❌ | Niche — instantaneous age gauge | `karpenter_nodes_current_lifetime_seconds` | ALPHA | Node age in seconds |
| ✅ | Core — node creation rate | `karpenter_nodes_created_total` | STABLE | Number of nodes created in total by Karpenter. Labeled by owning nodepool. |
| ✅ | Core — capacity planning | `karpenter_nodes_allocatable` | BETA | Node allocatable are the resources allocatable by nodes. |
| ❌ | Niche — operatorpkg termination timing | `operator_node_termination_duration_seconds` | BETA | The amount of time taken by an object to terminate completely. |
| ❌ | Niche — current termination gauge | `operator_node_termination_current_time_seconds` | BETA | The current amount of time in seconds that an object has been in terminating ... |
| ✅ | Core — condition transitions, detect flapping | `operator_node_status_condition_transitions_total` | BETA | The count of transitions of a given object, type and status. |
| ❌ | Niche — transition timing detail | `operator_node_status_condition_transition_seconds` | BETA | The amount of time a condition was in a given state before transitioning. e.g... |
| ❌ | Niche — current status duration | `operator_node_status_condition_current_status_seconds` | BETA | The current amount of time in seconds that a status condition has been in a s... |
| ❌ | Niche — operatorpkg condition counts | `operator_node_status_condition_count` | BETA | The number of a condition for a given object, type and status. e.g. Alarm := ... |
| ❌ | Redundant gauge of startup_duration | `karpenter_pods_unstarted_time_seconds` | ALPHA | The time from pod creation until the pod is running. |
| ❌ | Redundant gauge of bound_duration | `karpenter_pods_unbound_time_seconds` | ALPHA | The time from pod creation until the pod is bound. |
| ✅ | Core — pod state distribution | `karpenter_pods_state` | BETA | Pod state is the current state of pods. This metric can be used several ways ... |
| ✅ | Core — pod startup latency | `karpenter_pods_startup_duration_seconds` | STABLE | The time from pod creation until the pod is running. |
| ❌ | Niche — internal scheduling timing | `karpenter_pods_scheduling_decision_duration_seconds` | ALPHA | The time it takes for Karpenter to first try to schedule a pod after it&rsquo... |
| ❌ | Niche — provisioning detail, startup_duration sufficient | `karpenter_pods_provisioning_unstarted_time_seconds` | ALPHA | The time from when Karpenter first thinks the pod can schedule until the pod ... |
| ❌ | Niche — provisioning detail, startup_duration sufficient | `karpenter_pods_provisioning_unbound_time_seconds` | ALPHA | The time from when Karpenter first thinks the pod can schedule until it binds... |
| ❌ | Niche — provisioning detail, startup_duration sufficient | `karpenter_pods_provisioning_startup_duration_seconds` | ALPHA | The time from when Karpenter first thinks the pod can schedule until the pod ... |
| ❌ | Niche — provisioning detail, startup_duration sufficient | `karpenter_pods_provisioning_scheduling_undecided_time_seconds` | ALPHA | The time from when Karpenter has seen a pod without making a scheduling decis... |
| ❌ | Niche — provisioning detail, startup_duration sufficient | `karpenter_pods_provisioning_bound_duration_seconds` | ALPHA | The time from when Karpenter first thinks the pod can schedule until it binds... |
| ✅ | Core — eviction activity during disruption | `karpenter_pods_eviction_requests_total` | ALPHA | The total number of pod eviction requests made by Karpenter, labeled by respo... |
| ✅ | Core — drain activity | `karpenter_pods_drained_total` | ALPHA | The total number of pods drained during node termination by Karpenter, labele... |
| ✅ | Core — pod bind latency | `karpenter_pods_bound_duration_seconds` | ALPHA | The time from pod creation until the pod is bound. |
| ❌ | Niche — operatorpkg termination timing | `operator_nodepool_termination_duration_seconds` | BETA | The amount of time taken by an object to terminate completely. |
| ❌ | Niche — current termination gauge | `operator_nodepool_termination_current_time_seconds` | BETA | The current amount of time in seconds that an object has been in terminating ... |
| ✅ | Core — condition transitions, detect flapping | `operator_nodepool_status_condition_transitions_total` | BETA | The count of transitions of a given object, type and status. |
| ❌ | Niche — transition timing detail | `operator_nodepool_status_condition_transition_seconds` | BETA | The amount of time a condition was in a given state before transitioning. e.g... |
| ❌ | Niche — current status duration | `operator_nodepool_status_condition_current_status_seconds` | BETA | The current amount of time in seconds that a status condition has been in a s... |
| ❌ | Niche — operatorpkg condition counts | `operator_nodepool_status_condition_count` | BETA | The number of a condition for a given object, type and status. e.g. Alarm := ... |
| ❌ | Niche — operatorpkg termination timing | `operator_ec2nodeclass_termination_duration_seconds` | BETA | The amount of time taken by an object to terminate completely. |
| ❌ | Niche — current termination gauge | `operator_ec2nodeclass_termination_current_time_seconds` | BETA | The current amount of time in seconds that an object has been in terminating ... |
| ✅ | Core — condition transitions, detect flapping | `operator_ec2nodeclass_status_condition_transitions_total` | BETA | The count of transitions of a given object, type and status. |
| ❌ | Niche — transition timing detail | `operator_ec2nodeclass_status_condition_transition_seconds` | BETA | The amount of time a condition was in a given state before transitioning. e.g... |
| ❌ | Niche — current status duration | `operator_ec2nodeclass_status_condition_current_status_seconds` | BETA | The current amount of time in seconds that a status condition has been in a s... |
| ❌ | Niche — operatorpkg condition counts | `operator_ec2nodeclass_status_condition_count` | BETA | The number of a condition for a given object, type and status. e.g. Alarm := ... |
| ✅ | Core — disruption queue failures | `karpenter_voluntary_disruption_queue_failures_total` | BETA | The number of times that an enqueued disruption decision failed. Labeled by d... |
| ❌ | Niche — validation detail | `karpenter_voluntary_disruption_failed_validations_total` | ALPHA | Number of candidates that were selected for disruption but failed validation.... |
| ✅ | Core — eligible nodes for disruption | `karpenter_voluntary_disruption_eligible_nodes` | BETA | Number of nodes eligible for disruption by Karpenter. Labeled by disruption r... |
| ✅ | Core — disruption decision count | `karpenter_voluntary_disruption_decisions_total` | STABLE | Number of disruption decisions performed. Labeled by disruption decision, rea... |
| ❌ | Niche — per-nodepool breakdown | `karpenter_voluntary_disruption_decisions_by_nodepool_total` | ALPHA | Number of disruption decisions performed by nodepool. Labeled by nodepool nam... |
| ❌ | Niche — evaluation timing | `karpenter_voluntary_disruption_decision_evaluation_duration_seconds` | BETA | Duration of the disruption decision evaluation process in seconds. Labeled by... |
| ✅ | Core — consolidation health | `karpenter_voluntary_disruption_consolidation_timeouts_total` | BETA | Number of times the Consolidation algorithm has reached a timeout. Labeled by... |
| ✅ | Core — unschedulable pod count | `karpenter_scheduler_unschedulable_pods_count` | ALPHA | The number of unschedulable Pods. |
| ❌ | Niche — workqueue internal | `karpenter_scheduler_unfinished_work_seconds` | ALPHA | How many seconds of work has been done that is in progress and hasn&rsquo;t b... |
| ✅ | Core — scheduling latency | `karpenter_scheduler_scheduling_duration_seconds` | STABLE | Duration of scheduling simulations used for deprovisioning and provisioning i... |
| ✅ | Core — scheduling backlog | `karpenter_scheduler_queue_depth` | BETA | The number of pods currently waiting to be scheduled. |
| ❌ | Niche — internal detail | `karpenter_scheduler_ignored_pods_count` | ALPHA | Number of pods ignored during scheduling by Karpenter |
| ✅ | Core — nodepool usage for capacity | `karpenter_nodepools_usage` | ALPHA | The amount of resources that have been provisioned for a nodepool. Labeled by... |
| ❌ | Niche — budget detail | `karpenter_nodepools_nodes_consuming_budgets` | ALPHA | The number of nodes consuming the budget of a nodepool at a point in time. La... |
| ✅ | Core — nodepool limits for capacity | `karpenter_nodepools_limit` | ALPHA | Limits specified on the nodepool that restrict the quantity of resources prov... |
| ❌ | Niche — cost tracker errors | `karpenter_nodepools_cost_tracker_errors_total` | ALPHA | Number of errors encountered during cost tracking operations. Labeled by node... |
| ✅ | Core — cost tracking | `karpenter_nodepools_cost_total` | ALPHA | Total cost of the nodepool from Karpenter&rsquo;s perspective. Units are dete... |
| ❌ | Niche — budget detail | `karpenter_nodepools_allowed_disruptions` | ALPHA | The number of nodes for a given NodePool that can be concurrently disrupting ... |
| ✅ | Core — spot interruption events | `karpenter_interruption_received_messages_total` | STABLE | Count of messages received from the SQS queue. Broken down by message type an... |
| ✅ | Core — interruption processing latency | `karpenter_interruption_message_queue_duration_seconds` | STABLE | Amount of time an interruption message is on the queue before it is processed... |
| ✅ | Core — unhealthy EC2 instances | `karpenter_interruption_instance_status_unhealthy_total` | STABLE | Count of unhealthy instance statuses detected from EC2 DescribeInstanceStatus... |
| ✅ | Core — processed interruptions | `karpenter_interruption_deleted_messages_total` | STABLE | Count of messages deleted from the SQS queue. |
| ✅ | Core — cluster utilization | `karpenter_cluster_utilization_percent` | ALPHA | Utilization of allocatable resources by pod requests |
| ✅ | Core — alert if state unsynced too long | `karpenter_cluster_state_unsynced_time_seconds` | STABLE | The time for which cluster state is not synced |
| ✅ | Core — cluster state health | `karpenter_cluster_state_synced` | STABLE | Returns 1 if cluster state is synced and 0 otherwise. Synced checks that node... |
| ✅ | Core — cluster node count | `karpenter_cluster_state_node_count` | STABLE | Current count of nodes in cluster state |
| ❌ | Niche — instance type catalog, high cardinality | `karpenter_cloudprovider_instance_type_offering_price_estimate` | BETA | Instance type offering estimated hourly price used when making informed decis... |
| ❌ | Niche — instance type catalog, high cardinality | `karpenter_cloudprovider_instance_type_offering_available` | BETA | Instance type offering availability, based on instance type, capacity type, a... |
| ❌ | Niche — instance type catalog, high cardinality | `karpenter_cloudprovider_instance_type_memory_bytes` | BETA | Memory, in bytes, for a given instance type. |
| ❌ | Niche — instance type catalog, high cardinality | `karpenter_cloudprovider_instance_type_cpu_cores` | BETA | VCPUs cores for a given instance type. |
| ✅ | Core — cloud API errors | `karpenter_cloudprovider_errors_total` | BETA | Total number of errors returned from CloudProvider calls. |
| ✅ | Core — cloud API latency | `karpenter_cloudprovider_duration_seconds` | BETA | Duration of cloud provider method calls. Labeled by the controller, method na... |
| ❌ | Niche — batching internals | `karpenter_cloudprovider_batcher_batch_time_seconds` | BETA | Duration of the batching window per batcher |
| ❌ | Niche — batching internals | `karpenter_cloudprovider_batcher_batch_size` | BETA | Size of the request batch per batcher |
| ✅ | Permanent failures — alert on non-zero, means nodes won't converge | `controller_runtime_terminal_reconcile_errors_total` | STABLE | Total number of terminal reconciliation errors per controller |
| ✅ | Reconciliation throughput — baseline for error rate calculation | `controller_runtime_reconcile_total` | STABLE | Total number of reconciliations per controller |
| ✅ | Reconciliation latency — slow reconciles delay node provisioning | `controller_runtime_reconcile_time_seconds` | STABLE | Length of time per reconciliation per controller |
| ✅ | Critical — any panic means controller instability | `controller_runtime_reconcile_panics_total` | STABLE | Total number of reconciliation panics per controller |
| ✅ | Transient errors — error_rate = errors / total reconciles | `controller_runtime_reconcile_errors_total` | STABLE | Total number of reconciliation errors per controller |
| ✅ | Concurrency ceiling — useful for tuning controller parallelism | `controller_runtime_max_concurrent_reconciles` | STABLE | Maximum number of concurrent reconciles per controller |
| ✅ | Webhook stability — panics here break CRD conversions | `controller_runtime_conversion_webhook_panics_total` | STABLE | Total number of conversion webhook panics |
| ✅ | Worker saturation — active vs max shows headroom | `controller_runtime_active_workers` | STABLE | Number of currently used workers per controller |
| ✅ | Processing time per item — detects slow node provisioning steps | `workqueue_work_duration_seconds` | STABLE | How long in seconds processing an item from workqueue takes. |
| ✅ | Stuck work detection — large values mean items aren't completing | `workqueue_unfinished_work_seconds` | STABLE | How many seconds of work has been done that is in progress and hasn&rsquo;t b... |
| ✅ | Retry pressure — high retries indicate flaky AWS API calls | `workqueue_retries_total` | STABLE | Total number of retries handled by workqueue |
| ✅ | Queue wait time — high values mean provisioning is backlogged | `workqueue_queue_duration_seconds` | STABLE | How long in seconds an item stays in workqueue before being requested |
| ✅ | Stuck processor detection — alert if exceeds threshold | `workqueue_longest_running_processor_seconds` | STABLE | How many seconds has the longest running processor for workqueue been running. |
| ✅ | Queue backlog — growing depth means Karpenter can't keep up | `workqueue_depth` | STABLE | Current depth of workqueue by workqueue and priority |
| ✅ | Incoming work rate — correlate with cluster scaling events | `workqueue_adds_total` | STABLE | Total number of adds handled by workqueue |
| ❌ | Deprecated | `operator_termination_duration_seconds` | DEPRECATED | The amount of time taken by an object to terminate completely. |
| ❌ | Deprecated | `operator_termination_current_time_seconds` | DEPRECATED | The current amount of time in seconds that an object has been in terminating ... |
| ❌ | Deprecated | `operator_status_condition_transitions_total` | DEPRECATED | The count of transitions of a given object, type and status. |
| ❌ | Deprecated | `operator_status_condition_transition_seconds` | DEPRECATED | The amount of time a condition was in a given state before transitioning. e.g... |
| ❌ | Deprecated | `operator_status_condition_current_status_seconds` | DEPRECATED | The current amount of time in seconds that a status condition has been in a s... |
| ❌ | Deprecated | `operator_status_condition_count` | DEPRECATED | The number of a condition for a given object, type and status. e.g. Alarm := ... |
| ✅ | Core — k8s API request volume | `client_go_request_total` | STABLE | Number of HTTP requests, partitioned by status code and method. |
| ✅ | Core — k8s API latency | `client_go_request_duration_seconds` | STABLE | Request latency in seconds. Broken down by verb, group, version, kind, and su... |
| ✅ | AWS API call volume — cost and throttling awareness | `aws_sdk_go_request_total` | STABLE | The total number of AWS SDK Go requests |
| ✅ | AWS retry pressure — high retries indicate API issues or throttling | `aws_sdk_go_request_retry_count` | STABLE | The total number of AWS SDK Go retry attempts per request |
| ✅ | AWS API latency — slow calls delay node provisioning | `aws_sdk_go_request_duration_seconds` | STABLE | Latency of AWS SDK Go requests |
| ✅ | Total attempts including retries — attempt/request ratio shows retry rate | `aws_sdk_go_request_attempt_total` | STABLE | The total number of AWS SDK Go request attempts |
| ✅ | Per-attempt latency — isolates slow individual calls from retries | `aws_sdk_go_request_attempt_duration_seconds` | STABLE | Latency of AWS SDK Go request attempts |
| ✅ | Leader election health — slow paths risk leadership loss | `leader_election_slowpath_total` | STABLE | Total number of slow path exercised in renewing leader leases. &rsquo;name&rs... |
| ✅ | Leader status — alert if no instance is master (Karpenter is down) | `leader_election_master_status` | STABLE | Gauge of if the reporting system is master of the relevant lease, 0 indicates... |