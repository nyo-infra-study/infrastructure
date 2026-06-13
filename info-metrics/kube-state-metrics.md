# kube-state-metrics — Metric Filter Decisions

> Version: 2.18.0
> Docs: https://github.com/kubernetes/kube-state-metrics/tree/v2.18.0/internal/store
> Generated from: `output/*/parsed/kube-state-metrics.csv`

---

| Use | Reason | component | metric_name | metric_type | description |
| --- | --- | --- | --- | --- | --- |
| ❌ | High-cardinality annotation mirror | 1-deployment | `kube_deployment_annotations` | Gauge | Kubernetes annotations converted to Prometheus labels. |
| ❌ | High-cardinality label mirror | 1-deployment | `kube_deployment_labels` | Gauge | Kubernetes labels converted to Prometheus labels. |
| ❌ | Owner info available from k8sattributes processor | 1-deployment | `kube_deployment_owner` | Gauge | Information about the Deployment's owner. |
| ❌ | Static timestamp, not useful as time-series | 1-deployment | `kube_deployment_created` | Gauge | Unix creation timestamp |
| ✅ | Core: current replica count for deployment health | 1-deployment | `kube_deployment_status_replicas` | Gauge | The number of replicas per deployment. |
| ❌ | Redundant — available is the standard readiness signal | 1-deployment | `kube_deployment_status_replicas_ready` | Gauge | The number of ready replicas per deployment. |
| ✅ | Core: available replicas — alert when < spec | 1-deployment | `kube_deployment_status_replicas_available` | Gauge | The number of available replicas per deployment. |
| ✅ | Core: directly alerts on unavailable replicas | 1-deployment | `kube_deployment_status_replicas_unavailable` | Gauge | The number of unavailable replicas per deployment. |
| ❌ | Rolling update detail — not needed for steady-state | 1-deployment | `kube_deployment_status_replicas_updated` | Gauge | The number of updated replicas per deployment. |
| ❌ | Transient rolling update detail | 1-deployment | `kube_deployment_status_terminating_replicas` | Gauge | The number of terminating replicas per deployment. |
| ✅ | Detect stuck rollouts (generation != observed) | 1-deployment | `kube_deployment_status_observed_generation` | Gauge | The generation observed by the deployment controller. |
| ❌ | High cardinality (condition × status matrix) — use replicas instead | 1-deployment | `kube_deployment_status_condition` | Gauge | The current status conditions of a deployment. |
| ✅ | Core: desired replica count — compare with actual | 1-deployment | `kube_deployment_spec_replicas` | Gauge | Number of desired pods for a deployment. |
| ❌ | Static config — check via K8s API if needed | 1-deployment | `kube_deployment_spec_paused` | Gauge | Whether the deployment is paused and will not be processed by the deployment ... |
| ✅ | Validate rolling update config for safe deployments | 1-deployment | `kube_deployment_spec_strategy_rollingupdate_max_unavailable` | Gauge | Maximum number of unavailable replicas during a rolling update of a deployment. |
| ✅ | Validate rolling update config for safe deployments | 1-deployment | `kube_deployment_spec_strategy_rollingupdate_max_surge` | Gauge | Maximum number of replicas that can be scheduled above the desired number of ... |
| ❌ | Internal K8s bookkeeping | 1-deployment | `kube_deployment_metadata_generation` | Gauge | Sequence number representing a specific generation of the desired state. |
| ❌ | Niche deletion tracking — not needed | 1-deployment | `kube_deployment_deletion_timestamp` | Gauge | Unix deletion timestamp |
| ❌ | High-cardinality annotation mirror | 10-persistentvolumeclaim | `kube_persistentvolumeclaim_annotations` | Gauge | Kubernetes annotations converted to Prometheus labels. |
| ❌ | High-cardinality label mirror | 10-persistentvolumeclaim | `kube_persistentvolumeclaim_labels` | Gauge | Kubernetes labels converted to Prometheus labels. |
| ❌ | Metadata — use K8s API for PVC details | 10-persistentvolumeclaim | `kube_persistentvolumeclaim_info` | Gauge | Information about persistent volume claim. |
| ✅ | Core: detect Pending/Lost PVCs | 10-persistentvolumeclaim | `kube_persistentvolumeclaim_status_phase` | Gauge | The phase the persistent volume claim is currently in. |
| ✅ | Core: requested storage — compare with PV capacity | 10-persistentvolumeclaim | `kube_persistentvolumeclaim_resource_requests_storage_bytes` | Histogram | The capacity of storage requested by the persistent volume claim. |
| ❌ | Static config — check via K8s API if needed | 10-persistentvolumeclaim | `kube_persistentvolumeclaim_access_mode` | Gauge | The access mode(s) specified by the persistent volume claim. |
| ❌ | Niche — PVC conditions rarely actionable | 10-persistentvolumeclaim | `kube_persistentvolumeclaim_status_condition` | Gauge | Information about status of different conditions of persistent volume claim. |
| ❌ | Static timestamp, not useful as time-series | 10-persistentvolumeclaim | `kube_persistentvolumeclaim_created` | Gauge | Unix creation timestamp |
| ❌ | Niche deletion tracking — not needed | 10-persistentvolumeclaim | `kube_persistentvolumeclaim_deletion_timestamp` | Gauge | Unix deletion timestamp |
| ❌ | Metadata — PV-to-PVC binding info, use K8s API | 11-persistentvolume | `kube_persistentvolume_claim_ref` | Gauge | Information about the Persistent Volume Claim Reference. |
| ❌ | High-cardinality annotation mirror | 11-persistentvolume | `kube_persistentvolume_annotations` | Gauge | Kubernetes annotations converted to Prometheus labels. |
| ❌ | High-cardinality label mirror | 11-persistentvolume | `kube_persistentvolume_labels` | Gauge | Kubernetes labels converted to Prometheus labels. |
| ❌ | Niche CSI detail — not needed | 11-persistentvolume | `kube_persistentvolume_csi_attributes` | Gauge | CSI attributes of the Persistent Volume. |
| ✅ | Core: detect Failed/Released PVs | 11-persistentvolume | `kube_persistentvolume_status_phase` | Gauge | The phase indicates if a volume is available, bound to a claim, or released b... |
| ❌ | Metadata — high cardinality (many provider-specific labels) | 11-persistentvolume | `kube_persistentvolume_info` | Gauge | Information about persistentvolume. |
| ✅ | Core: PV capacity for storage monitoring | 11-persistentvolume | `kube_persistentvolume_capacity_bytes` | Histogram | Persistentvolume capacity in bytes. |
| ❌ | Static timestamp, not useful as time-series | 11-persistentvolume | `kube_persistentvolume_created` | Gauge | Unix creation timestamp |
| ❌ | Niche deletion tracking — not needed | 11-persistentvolume | `kube_persistentvolume_deletion_timestamp` | Gauge | Unix deletion timestamp |
| ❌ | Static config — check via K8s API if needed | 11-persistentvolume | `kube_persistentvolume_volume_mode` | Gauge | Volume Mode information for the PersistentVolume. |
| ❌ | High-cardinality annotation mirror | 12-namespace | `kube_namespace_annotations` | Gauge | Kubernetes annotations converted to Prometheus labels. |
| ❌ | High-cardinality label mirror | 12-namespace | `kube_namespace_labels` | Gauge | Kubernetes labels converted to Prometheus labels. |
| ❌ | Static timestamp, not useful as time-series | 12-namespace | `kube_namespace_created` | Gauge | Unix creation timestamp |
| ✅ | Detect namespaces stuck in Terminating state | 12-namespace | `kube_namespace_status_phase` | Gauge | kubernetes namespace status phase. |
| ❌ | Niche — namespace deletion failures are rare | 12-namespace | `kube_namespace_status_condition` | Gauge | The condition of a namespace. |
| ❌ | High-cardinality annotation mirror | 13-service | `kube_service_annotations` | Gauge | Kubernetes annotations converted to Prometheus labels. |
| ❌ | High-cardinality label mirror | 13-service | `kube_service_labels` | Gauge | Kubernetes labels converted to Prometheus labels. |
| ❌ | Low-value resource — use K8s API for service details | 13-service | `kube_service_info` | Gauge | Information about service. |
| ❌ | Static timestamp, not useful as time-series | 13-service | `kube_service_created` | Gauge | Unix creation timestamp |
| ❌ | Low-value resource — static config | 13-service | `kube_service_spec_type` | Gauge | Type about service. |
| ❌ | Low-value resource — static config | 13-service | `kube_service_spec_external_ip` | Gauge | Service external ips. One series for each ip |
| ❌ | Low-value resource — LB status rarely changes | 13-service | `kube_service_status_load_balancer_ingress` | Gauge | Service load balancer ingress status |
| ❌ | Niche deletion tracking — not needed | 13-service | `kube_service_deletion_timestamp` | Gauge | Unix deletion timestamp |
| ❌ | High-cardinality annotation mirror | 14-configmap | `kube_configmap_annotations` | Gauge | Kubernetes annotations converted to Prometheus labels. |
| ❌ | High-cardinality label mirror | 14-configmap | `kube_configmap_labels` | Gauge | Kubernetes labels converted to Prometheus labels. |
| ❌ | Low-value resource — use K8s API for configmap details | 14-configmap | `kube_configmap_info` | Gauge | Information about configmap. |
| ❌ | Static timestamp, not useful as time-series | 14-configmap | `kube_configmap_created` | Gauge | Unix creation timestamp |
| ❌ | Internal K8s bookkeeping, no monitoring value | 14-configmap | `kube_configmap_metadata_resource_version` | Gauge | Resource version representing a specific version of the configmap. |
| ❌ | High-cardinality annotation mirror | 15-secret | `kube_secret_annotations` | Gauge | Kubernetes annotations converted to Prometheus labels. |
| ❌ | High-cardinality label mirror | 15-secret | `kube_secret_labels` | Gauge | Kubernetes labels converted to Prometheus labels. |
| ❌ | Low-value resource — use K8s API for secret details | 15-secret | `kube_secret_info` | Gauge | Information about secret. |
| ❌ | Low-value resource — static config | 15-secret | `kube_secret_type` | Gauge | Type about secret. |
| ❌ | Static timestamp, not useful as time-series | 15-secret | `kube_secret_created` | Gauge | Unix creation timestamp |
| ❌ | Internal K8s bookkeeping | 15-secret | `kube_secret_metadata_resource_version` | Gauge | Resource version representing a specific version of secret. |
| ❌ | Owner info available from k8sattributes processor | 15-secret | `kube_secret_owner` | Gauge | Information about the Secret's owner. |
| ❌ | High-cardinality annotation mirror | 16-ingress | `kube_ingress_annotations` | Gauge | Kubernetes annotations converted to Prometheus labels. |
| ❌ | High-cardinality label mirror | 16-ingress | `kube_ingress_labels` | Gauge | Kubernetes labels converted to Prometheus labels. |
| ❌ | Low-value resource — use K8s API for ingress details | 16-ingress | `kube_ingress_info` | Gauge | Information about ingress. |
| ❌ | Static timestamp, not useful as time-series | 16-ingress | `kube_ingress_created` | Gauge | Unix creation timestamp |
| ❌ | Internal K8s bookkeeping | 16-ingress | `kube_ingress_metadata_resource_version` | Gauge | Resource version representing a specific version of ingress. |
| ❌ | Low-value resource — static config | 16-ingress | `kube_ingress_path` | Gauge | Ingress host, paths and backend service information. |
| ❌ | Low-value resource — static config | 16-ingress | `kube_ingress_tls` | Gauge | Ingress TLS host and secret information. |
| ❌ | High-cardinality annotation mirror | 17-endpoint | `kube_endpoint_annotations` | Gauge | Kubernetes annotations converted to Prometheus labels. |
| ❌ | High-cardinality label mirror | 17-endpoint | `kube_endpoint_labels` | Gauge | Kubernetes labels converted to Prometheus labels. |
| ❌ | Low-value resource — endpoint monitoring not needed | 17-endpoint | `kube_endpoint_info` | Gauge | Information about endpoint. |
| ❌ | Static timestamp, not useful as time-series | 17-endpoint | `kube_endpoint_created` | Gauge | Unix creation timestamp |
| ❌ | Low-value resource — endpoint monitoring not needed | 17-endpoint | `kube_endpoint_address` | Gauge | Information about Endpoint available and non available addresses. |
| ❌ | DEPRECATED from v2.14.0 | 17-endpoint | `kube_endpoint_ports` | Gauge | Information about the Endpoint ports. |
| ❌ | High-cardinality annotation mirror | 18-resourcequota | `kube_resourcequota_annotations` | Gauge | Kubernetes annotations converted to Prometheus labels. |
| ❌ | High-cardinality label mirror | 18-resourcequota | `kube_resourcequota_labels` | Gauge | Kubernetes labels converted to Prometheus labels. |
| ❌ | Static timestamp, not useful as time-series | 18-resourcequota | `kube_resourcequota_created` | Gauge | Unix creation timestamp |
| ❌ | Low-value resource — static quota config | 18-resourcequota | `kube_resourcequota` | Gauge | Information about resource quota. |
| ❌ | Low-value resource — static policy config | 19-limitrange | `kube_limitrange` | Gauge | Information about limit range. |
| ❌ | Static timestamp, not useful as time-series | 19-limitrange | `kube_limitrange_created` | Gauge | Unix creation timestamp |
| ❌ | High-cardinality annotation mirror | 2-node | `kube_node_annotations` | Gauge | Kubernetes annotations converted to Prometheus labels. |
| ❌ | High-cardinality label mirror | 2-node | `kube_node_labels` | Gauge | Kubernetes labels converted to Prometheus labels. |
| ❌ | Niche deletion tracking — not needed | 2-node | `kube_node_deletion_timestamp` | Gauge | Unix deletion timestamp |
| ❌ | Static timestamp, not useful as time-series | 2-node | `kube_node_created` | Gauge | Unix creation timestamp |
| ❌ | Niche — IP addresses rarely change, use K8s API | 2-node | `kube_node_status_addresses` | Gauge | Node address information. |
| ✅ | Exception: node info is essential for version/runtime tracking | 2-node | `kube_node_info` | Gauge | Information about a cluster node. |
| ❌ | Redundant — role available in node_info labels | 2-node | `kube_node_role` | Gauge | The role of a cluster node. |
| ❌ | High cardinality (key × value × effect per node) | 2-node | `kube_node_spec_taint` | Gauge | The taint of a cluster node. |
| ✅ | Core: detect cordoned nodes | 2-node | `kube_node_spec_unschedulable` | Gauge | Whether a node can schedule new pods. |
| ✅ | Core: allocatable resources — compare with requests | 2-node | `kube_node_status_allocatable` | Gauge | The allocatable for different resources of a node that are available for sche... |
| ✅ | Core: total node resources for capacity planning | 2-node | `kube_node_status_capacity` | Gauge | The capacity for different resources of a node. |
| ✅ | Core: detect NotReady, MemoryPressure, DiskPressure | 2-node | `kube_node_status_condition` | Gauge | The condition of a cluster node. |
| ❌ | High-cardinality annotation mirror | 20-storageclass | `kube_storageclass_annotations` | Gauge | Kubernetes annotations converted to Prometheus labels. |
| ❌ | High-cardinality label mirror | 20-storageclass | `kube_storageclass_labels` | Gauge | Kubernetes labels converted to Prometheus labels. |
| ❌ | Low-value resource — static config | 20-storageclass | `kube_storageclass_info` | Gauge | Information about storageclass. |
| ❌ | Static timestamp, not useful as time-series | 20-storageclass | `kube_storageclass_created` | Gauge | Unix creation timestamp |
| ❌ | High-cardinality annotation mirror | 21-certificatesigningrequest | `kube_certificatesigningrequest_annotations` | Gauge | Kubernetes annotations converted to Prometheus labels. |
| ❌ | High-cardinality label mirror | 21-certificatesigningrequest | `kube_certificatesigningrequest_labels` | Gauge | Kubernetes labels converted to Prometheus labels. |
| ❌ | Static timestamp, not useful as time-series | 21-certificatesigningrequest | `kube_certificatesigningrequest_created` | Gauge | Unix creation timestamp |
| ❌ | Low-value resource — CSR monitoring not needed | 21-certificatesigningrequest | `kube_certificatesigningrequest_condition` | Gauge | The number of each certificatesigningrequest condition |
| ❌ | Low-value resource — CSR monitoring not needed | 21-certificatesigningrequest | `kube_certificatesigningrequest_cert_length` | Gauge | Length of the issued cert |
| ❌ | High-cardinality annotation mirror | 3-daemonset | `kube_daemonset_annotations` | Gauge | Kubernetes annotations converted to Prometheus labels. |
| ❌ | High-cardinality label mirror | 3-daemonset | `kube_daemonset_labels` | Gauge | Kubernetes labels converted to Prometheus labels. |
| ❌ | Static timestamp, not useful as time-series | 3-daemonset | `kube_daemonset_created` | Gauge | Unix creation timestamp |
| ✅ | Core: pods currently scheduled on nodes | 3-daemonset | `kube_daemonset_status_current_number_scheduled` | Gauge | The number of nodes running at least one daemon pod and are supposed to. |
| ✅ | Core: expected pod count — compare with current for drift | 3-daemonset | `kube_daemonset_status_desired_number_scheduled` | Gauge | The number of nodes that should be running the daemon pod. |
| ❌ | Redundant with number_ready for alerting | 3-daemonset | `kube_daemonset_status_number_available` | Gauge | The number of nodes that should be running the daemon pod and have one or mor... |
| ❌ | Niche — misscheduled pods are rare in practice | 3-daemonset | `kube_daemonset_status_number_misscheduled` | Gauge | The number of nodes running a daemon pod but are not supposed to. |
| ✅ | Core: ready pods — alert when ready < desired | 3-daemonset | `kube_daemonset_status_number_ready` | Gauge | The number of nodes that should be running the daemon pod and have one or mor... |
| ✅ | Core: directly alerts on unavailable daemonset pods | 3-daemonset | `kube_daemonset_status_number_unavailable` | Gauge | The number of nodes that should be running the daemon pod and have none of th... |
| ❌ | Internal bookkeeping — generation tracking | 3-daemonset | `kube_daemonset_status_observed_generation` | Gauge | The most recent generation observed by the daemon set controller. |
| ❌ | Rolling update detail — not needed for steady-state | 3-daemonset | `kube_daemonset_status_updated_number_scheduled` | Gauge | The total number of nodes that are running updated daemon pod |
| ❌ | Internal K8s bookkeeping | 3-daemonset | `kube_daemonset_metadata_generation` | Gauge | Sequence number representing a specific generation of the desired state. |
| ❌ | Niche deletion tracking — not needed | 3-daemonset | `kube_daemonset_deletion_timestamp` | Gauge | Unix deletion timestamp |
| ❌ | High-cardinality annotation mirror | 4-statefulset | `kube_statefulset_annotations` | Gauge | Kubernetes annotations converted to Prometheus labels. |
| ❌ | High-cardinality label mirror | 4-statefulset | `kube_statefulset_labels` | Gauge | Kubernetes labels converted to Prometheus labels. |
| ❌ | Static timestamp, not useful as time-series | 4-statefulset | `kube_statefulset_created` | Gauge | Unix creation timestamp |
| ❌ | Redundant — replicas_current + replicas_ready are more specific | 4-statefulset | `kube_statefulset_status_replicas` | Gauge | The number of replicas per StatefulSet. |
| ❌ | Redundant with replicas_ready for alerting | 4-statefulset | `kube_statefulset_status_replicas_available` | Gauge | The number of available replicas per StatefulSet. |
| ✅ | Core: current replicas in the active revision | 4-statefulset | `kube_statefulset_status_replicas_current` | Gauge | The number of current replicas per StatefulSet. |
| ✅ | Core: ready replicas — alert when < desired | 4-statefulset | `kube_statefulset_status_replicas_ready` | Gauge | The number of ready replicas per StatefulSet. |
| ❌ | Rolling update detail — not needed for steady-state | 4-statefulset | `kube_statefulset_status_replicas_updated` | Gauge | The number of updated replicas per StatefulSet. |
| ❌ | Internal bookkeeping — generation tracking | 4-statefulset | `kube_statefulset_status_observed_generation` | Gauge | The generation observed by the StatefulSet controller. |
| ✅ | Core: desired replica count — compare with actual | 4-statefulset | `kube_statefulset_replicas` | Gauge | Number of desired pods for a StatefulSet. |
| ❌ | Static config — ordinal start rarely changes | 4-statefulset | `kube_statefulset_ordinals_start` | Gauge | Start ordinal of the StatefulSet. |
| ❌ | Internal K8s bookkeeping | 4-statefulset | `kube_statefulset_metadata_generation` | Gauge | Sequence number representing a specific generation of the desired state for t... |
| ❌ | Static config — retention policy doesn't change | 4-statefulset | `kube_statefulset_persistentvolumeclaim_retention_policy` | Gauge | Count of retention policy for StatefulSet template PVCs |
| ❌ | Niche — revision tracking not needed for alerting | 4-statefulset | `kube_statefulset_status_current_revision` | Gauge | Indicates the version of the StatefulSet used to generate Pods in the sequenc... |
| ❌ | Niche — revision tracking not needed for alerting | 4-statefulset | `kube_statefulset_status_update_revision` | Gauge | Indicates the version of the StatefulSet used to generate Pods in the sequenc... |
| ❌ | Niche deletion tracking — not needed | 4-statefulset | `kube_statefulset_deletion_timestamp` | Gauge | Unix deletion timestamp |
| ❌ | High-cardinality annotation mirror | 5-replicaset | `kube_replicaset_annotations` | Gauge | Kubernetes annotations converted to Prometheus labels. |
| ❌ | High-cardinality label mirror | 5-replicaset | `kube_replicaset_labels` | Gauge | Kubernetes labels converted to Prometheus labels. |
| ❌ | Static timestamp, not useful as time-series | 5-replicaset | `kube_replicaset_created` | Gauge | Unix creation timestamp |
| ✅ | Core: current replica count | 5-replicaset | `kube_replicaset_status_replicas` | Gauge | The number of replicas per ReplicaSet. |
| ❌ | Niche — fully labeled tracking not needed | 5-replicaset | `kube_replicaset_status_fully_labeled_replicas` | Gauge | The number of fully labeled replicas per ReplicaSet. |
| ✅ | Core: ready replicas — alert when < spec | 5-replicaset | `kube_replicaset_status_ready_replicas` | Gauge | The number of ready replicas per ReplicaSet. |
| ❌ | Transient rolling update detail | 5-replicaset | `kube_replicaset_status_terminating_replicas` | Gauge | The number of terminating replicas per ReplicaSet. |
| ❌ | Internal bookkeeping — generation tracking | 5-replicaset | `kube_replicaset_status_observed_generation` | Gauge | The generation observed by the ReplicaSet controller. |
| ✅ | Core: desired replica count — compare with actual | 5-replicaset | `kube_replicaset_spec_replicas` | Gauge | Number of desired pods for a ReplicaSet. |
| ❌ | Internal K8s bookkeeping | 5-replicaset | `kube_replicaset_metadata_generation` | Gauge | Sequence number representing a specific generation of the desired state. |
| ❌ | Owner info available from k8sattributes processor | 5-replicaset | `kube_replicaset_owner` | Gauge | Information about the ReplicaSet's owner. |
| ❌ | High-cardinality annotation mirror | 6-horizontalpodautoscaler | `kube_horizontalpodautoscaler_annotations` | Gauge | Kubernetes annotations converted to Prometheus labels. |
| ❌ | High-cardinality label mirror | 6-horizontalpodautoscaler | `kube_horizontalpodautoscaler_labels` | Gauge | Kubernetes labels converted to Prometheus labels. |
| ✅ | HPA count and metadata — tracks how many HPAs exist per namespace, useful for capacity planning and detecting orphaned autoscalers. Used in EaglePoint dashboard | 6-horizontalpodautoscaler | `kube_horizontalpodautoscaler_info` | Gauge | Information about this autoscaler. |
| ❌ | Internal K8s bookkeeping | 6-horizontalpodautoscaler | `kube_horizontalpodautoscaler_metadata_generation` | Gauge | The generation observed by the HorizontalPodAutoscaler controller. |
| ✅ | Core: detect HPA hitting ceiling | 6-horizontalpodautoscaler | `kube_horizontalpodautoscaler_spec_max_replicas` | Gauge | Upper limit for the number of pods that can be set by the autoscaler; cannot ... |
| ✅ | Core: detect HPA at floor | 6-horizontalpodautoscaler | `kube_horizontalpodautoscaler_spec_min_replicas` | Gauge | Lower limit for the number of pods that can be set by the autoscaler, default 1. |
| ❌ | Static config — target metric spec | 6-horizontalpodautoscaler | `kube_horizontalpodautoscaler_spec_target_metric` | Gauge | The metric specifications used by this autoscaler when calculating the desire... |
| ❌ | High cardinality (metric_name × metric_target_type) | 6-horizontalpodautoscaler | `kube_horizontalpodautoscaler_status_target_metric` | Gauge | The current metric status used by this autoscaler when calculating the desire... |
| ✅ | Core: current HPA replica count — compare with min/max | 6-horizontalpodautoscaler | `kube_horizontalpodautoscaler_status_current_replicas` | Gauge | Current number of replicas of pods managed by this autoscaler. |
| ❌ | Redundant with current_replicas + condition for alerting | 6-horizontalpodautoscaler | `kube_horizontalpodautoscaler_status_desired_replicas` | Gauge | Desired number of replicas of pods managed by this autoscaler. |
| ✅ | Detect HPA unable to scale (ScalingLimited, AbleToScale) | 6-horizontalpodautoscaler | `kube_horizontalpodautoscaler_status_condition` | Gauge | The condition of this autoscaler. |
| ❌ | Static timestamp, not useful as time-series | 6-horizontalpodautoscaler | `kube_horizontalpodautoscaler_created` | Gauge | Unix creation timestamp |
| ❌ | Niche deletion tracking — not needed | 6-horizontalpodautoscaler | `kube_horizontalpodautoscaler_deletion_timestamp` | Gauge | Unix deletion timestamp |
| ❌ | High-cardinality annotation mirror | 7-job | `kube_job_annotations` | Gauge | Kubernetes annotations converted to Prometheus labels. |
| ❌ | High-cardinality label mirror | 7-job | `kube_job_labels` | Gauge | Kubernetes labels converted to Prometheus labels. |
| ❌ | Metadata — use K8s API for job details | 7-job | `kube_job_info` | Gauge | Information about job. |
| ❌ | Static timestamp, not useful as time-series | 7-job | `kube_job_created` | Gauge | Unix creation timestamp |
| ❌ | Static config — check via K8s API if needed | 7-job | `kube_job_spec_parallelism` | Gauge | The maximum desired number of pods the job should run at any given time. |
| ❌ | Static config — check via K8s API if needed | 7-job | `kube_job_spec_completions` | Gauge | The desired number of successfully finished pods the job should be run with. |
| ❌ | Static config — check via K8s API if needed | 7-job | `kube_job_spec_active_deadline_seconds` | Histogram | The duration in seconds relative to the startTime that the job may be active ... |
| ✅ | Core: track job completion rate | 7-job | `kube_job_status_succeeded` | Gauge | The number of pods which reached Phase Succeeded. |
| ✅ | Core: alert on job failures | 7-job | `kube_job_status_failed` | Gauge | The number of pods which reached Phase Failed and the reason for failure. |
| ✅ | Core: detect stuck jobs (active for too long) | 7-job | `kube_job_status_active` | Gauge | The number of actively running pods. |
| ❌ | Redundant with status_active for alerting | 7-job | `kube_job_status_ready` | Gauge | The number of ready pods that belong to this Job. |
| ✅ | Core: job completion condition signal | 7-job | `kube_job_complete` | Gauge | The job has completed its execution. |
| ✅ | Core: job failure condition signal | 7-job | `kube_job_failed` | Gauge | The job has failed its execution. |
| ❌ | Timestamp — derive duration from active/complete instead | 7-job | `kube_job_status_start_time` | Gauge | StartTime represents time when the job was acknowledged by the Job Manager. |
| ❌ | Timestamp — derive duration from active/complete instead | 7-job | `kube_job_status_completion_time` | Gauge | CompletionTime represents time when the job was completed. |
| ❌ | Niche — suspended jobs are rare | 7-job | `kube_job_status_suspended` | Gauge | The number of pods which reached Phase Suspended. |
| ❌ | Owner info available from k8sattributes processor | 7-job | `kube_job_owner` | Gauge | Information about the Job's owner. |
| ❌ | High-cardinality annotation mirror | 8-cronjob | `kube_cronjob_annotations` | Gauge | Kubernetes annotations converted to Prometheus labels. |
| ❌ | High-cardinality label mirror | 8-cronjob | `kube_cronjob_labels` | Gauge | Kubernetes labels converted to Prometheus labels. |
| ✅ | CronJob inventory — tracks total cronjob count per namespace, useful for detecting drift and orphaned schedules. Used in EaglePoint dashboard | 8-cronjob | `kube_cronjob_info` | Gauge | Info about cronjob. |
| ❌ | Static timestamp, not useful as time-series | 8-cronjob | `kube_cronjob_created` | Gauge | Unix creation timestamp |
| ✅ | Alert on cronjobs that are still running (stuck) | 8-cronjob | `kube_cronjob_status_active` | Gauge | Active holds pointers to currently running jobs. |
| ✅ | Detect cronjobs that stopped being scheduled | 8-cronjob | `kube_cronjob_status_last_schedule_time` | Gauge | LastScheduleTime keeps information of when was the last time the job was succ... |
| ❌ | Redundant with last_schedule_time + job status | 8-cronjob | `kube_cronjob_status_last_successful_time` | Gauge | LastSuccessfulTime keeps information of when was the last time the job was co... |
| ❌ | Static config — check via K8s API if needed | 8-cronjob | `kube_cronjob_spec_suspend` | Gauge | Suspend flag tells the controller to suspend subsequent executions. |
| ❌ | Static config — check via K8s API if needed | 8-cronjob | `kube_cronjob_spec_starting_deadline_seconds` | Histogram | Deadline in seconds for starting the job if it misses scheduled time for any ... |
| ✅ | Detect stuck/missed cronjob schedules | 8-cronjob | `kube_cronjob_next_schedule_time` | Gauge | Next time the cronjob should be scheduled. The time after lastScheduleTime, o... |
| ❌ | Internal K8s bookkeeping | 8-cronjob | `kube_cronjob_metadata_resource_version` | Gauge | Resource version representing a specific version of the cronjob. |
| ❌ | Static config — check via K8s API if needed | 8-cronjob | `kube_cronjob_spec_successful_job_history_limit` | Gauge | Successful job history limit tells the controller how many completed jobs sho... |
| ❌ | Static config — check via K8s API if needed | 8-cronjob | `kube_cronjob_spec_failed_job_history_limit` | Gauge | Failed job history limit tells the controller how many failed jobs should be ... |
| ❌ | High-cardinality annotation mirror | 9-poddisruptionbudget | `kube_poddisruptionbudget_annotations` | Gauge | Kubernetes annotations converted to Prometheus labels. |
| ❌ | High-cardinality label mirror | 9-poddisruptionbudget | `kube_poddisruptionbudget_labels` | Gauge | Kubernetes labels converted to Prometheus labels. |
| ❌ | Static timestamp, not useful as time-series | 9-poddisruptionbudget | `kube_poddisruptionbudget_created` | Gauge | Unix creation timestamp |
| ✅ | Core: current healthy pods vs desired | 9-poddisruptionbudget | `kube_poddisruptionbudget_status_current_healthy` | Gauge | Current number of healthy pods |
| ✅ | Core: minimum healthy pods required by PDB | 9-poddisruptionbudget | `kube_poddisruptionbudget_status_desired_healthy` | Gauge | Minimum desired number of healthy pods |
| ✅ | Core: alert when disruptions_allowed = 0 (blocked rollouts) | 9-poddisruptionbudget | `kube_poddisruptionbudget_status_pod_disruptions_allowed` | Gauge | Number of pod disruptions that are currently allowed |
| ❌ | Redundant with current_healthy + desired_healthy | 9-poddisruptionbudget | `kube_poddisruptionbudget_status_expected_pods` | Gauge | Total number of pods counted by this disruption budget |
| ❌ | Internal bookkeeping — generation tracking | 9-poddisruptionbudget | `kube_poddisruptionbudget_status_observed_generation` | Gauge | Most recent generation observed when updating this PDB status |
| ❌ | Niche deletion tracking — not needed | 9-poddisruptionbudget | `kube_poddisruptionbudget_deletion_timestamp` | Gauge | Unix deletion timestamp |
| ❌ | Static timestamp, not useful as time-series | pod | `kube_pod_completion_time` | Gauge | Completion time in unix timestamp for a pod. |
| ❌ | Metadata — high cardinality (image, image_id per container) | pod | `kube_pod_container_info` | Gauge | Information about a container in a pod. |
| ✅ | Core: resource limits — detect missing limits, OOM risk | pod | `kube_pod_container_resource_limits` | Gauge | The number of requested limit resource by a container. It is recommended to u... |
| ✅ | Core: resource requests — capacity planning and overcommit detection | pod | `kube_pod_container_resource_requests` | Gauge | The number of requested request resource by a container. It is recommended to... |
| ❌ | Static timestamp per container start | pod | `kube_pod_container_state_started` | Gauge | Start time in unix timestamp for a pod container. |
| ✅ | Core: detect recurring OOMKilled/Error after restart | pod | `kube_pod_container_status_last_terminated_reason` | Gauge | Describes the last reason the container was in terminated state. |
| ❌ | Niche — exit code detail, reason is sufficient | pod | `kube_pod_container_status_last_terminated_exitcode` | Gauge | Describes the exit code for the last container in terminated state. |
| ❌ | Static timestamp, not useful as time-series | pod | `kube_pod_container_status_last_terminated_timestamp` | Gauge | Last terminated time for a pod container in unix timestamp. |
| ❌ | Redundant — pod-level status_ready is sufficient | pod | `kube_pod_container_status_ready` | Gauge | Describes whether the containers readiness check succeeded. |
| ✅ | Core: alert on high restart rate (CrashLoopBackOff) | pod | `kube_pod_container_status_restarts_total` | Counter | The number of container restarts per container. |
| ❌ | Redundant — covered by pod_status_ready | pod | `kube_pod_container_status_running` | Gauge | Describes whether the container is currently in running state. |
| ✅ | Container terminated state — surfaces pods that exited (OOMKilled, completed, error) without needing the specific reason breakdown. Used in EaglePoint dashboard | pod | `kube_pod_container_status_terminated` | Gauge | Describes whether the container is currently in terminated state. |
| ✅ | Core: detect OOMKilled, Error, etc. | pod | `kube_pod_container_status_terminated_reason` | Gauge | Describes the reason the container is currently in terminated state. |
| ✅ | Container waiting state — counts pods stuck in pending states (image pull, crash loop, scheduling). Used in EaglePoint dashboard | pod | `kube_pod_container_status_waiting` | Gauge | Describes whether the container is currently in waiting state. |
| ✅ | Core: detect CrashLoopBackOff, ImagePullBackOff, etc. | pod | `kube_pod_container_status_waiting_reason` | Gauge | Describes the reason the container is currently in waiting state. |
| ❌ | Static timestamp, not useful as time-series | pod | `kube_pod_created` | Gauge | Unix creation timestamp |
| ❌ | Niche deletion tracking — not needed | pod | `kube_pod_deletion_timestamp` | Gauge | Unix deletion timestamp |
| ❌ | Metadata — high cardinality (host_ip, pod_ip, uid per pod) | pod | `kube_pod_info` | Gauge | Information about pod. |
| ❌ | Niche — IP addresses available from pod_info | pod | `kube_pod_ips` | Gauge | Pod IP addresses |
| ❌ | Init container metric — niche | pod | `kube_pod_init_container_info` | Gauge | Information about an init container in a pod. |
| ❌ | Init container metric — niche | pod | `kube_pod_init_container_resource_limits` | Gauge | The number of requested limit resource by an init container. |
| ❌ | Init container metric — niche | pod | `kube_pod_init_container_resource_requests` | Gauge | The number of requested request resource by an init container. |
| ❌ | Init container metric — niche | pod | `kube_pod_init_container_status_last_terminated_reason` | Gauge | Describes the last reason the init container was in terminated state. |
| ❌ | Init container metric — niche | pod | `kube_pod_init_container_status_ready` | Gauge | Describes whether the init containers readiness check succeeded. |
| ❌ | Init container metric — niche | pod | `kube_pod_init_container_status_restarts_total` | Counter | The number of restarts for the init container. |
| ❌ | Init container metric — niche | pod | `kube_pod_init_container_status_running` | Gauge | Describes whether the init container is currently in running state. |
| ❌ | Init container metric — niche | pod | `kube_pod_init_container_status_terminated` | Gauge | Describes whether the init container is currently in terminated state. |
| ❌ | Init container metric — niche | pod | `kube_pod_init_container_status_terminated_reason` | Gauge | Describes the reason the init container is currently in terminated state. |
| ❌ | Init container metric — niche | pod | `kube_pod_init_container_status_waiting` | Gauge | Describes whether the init container is currently in waiting state. |
| ❌ | Init container metric — niche | pod | `kube_pod_init_container_status_waiting_reason` | Gauge | Describes the reason the init container is currently in waiting state. |
| ❌ | High-cardinality annotation mirror | pod | `kube_pod_annotations` | Gauge | Kubernetes annotations converted to Prometheus labels. |
| ❌ | High-cardinality label mirror | pod | `kube_pod_labels` | Gauge | Kubernetes labels converted to Prometheus labels. |
| ❌ | Niche — pod overhead is minimal in most setups | pod | `kube_pod_overhead_cpu_cores` | Gauge | The pod overhead in regards to cpu cores associated with running a pod. |
| ❌ | Niche — pod overhead is minimal in most setups | pod | `kube_pod_overhead_memory_bytes` | Histogram | The pod overhead in regards to memory associated with running a pod. |
| ❌ | Owner info available from k8sattributes processor | pod | `kube_pod_owner` | Gauge | Information about the Pod's owner. |
| ❌ | Static config — restart policy doesn't change | pod | `kube_pod_restart_policy` | Gauge | Describes the restart policy in use by this pod. |
| ❌ | Metadata — runtime class rarely changes | pod | `kube_pod_runtimeclass_name_info` | Gauge | The runtimeclass associated with the pod. |
| ❌ | Pod spec volume detail — niche | pod | `kube_pod_spec_volumes_persistentvolumeclaims_info` | Gauge | Information about persistentvolumeclaim volumes in a pod. |
| ❌ | Pod spec volume detail — niche | pod | `kube_pod_spec_volumes_persistentvolumeclaims_readonly` | Gauge | Describes whether a persistentvolumeclaim is mounted read only. |
| ❌ | Static timestamp, not useful as time-series | pod | `kube_pod_start_time` | Gauge | Start time in unix timestamp for a pod. |
| ✅ | Core: detect Pending/Failed/Unknown pods | pod | `kube_pod_status_phase` | Gauge | The pods current phase. |
| ❌ | Niche timing metric — not needed for alerting | pod | `kube_pod_status_initialized_time` | Gauge | Initialized time in unix timestamp for a pod. |
| ❌ | Niche timing metric — not needed for alerting | pod | `kube_pod_status_container_ready_time` | Gauge | Readiness achieved time in unix timestamp for a pod containers. |
| ❌ | Niche timing metric — not needed for alerting | pod | `kube_pod_status_ready_time` | Gauge | Readiness achieved time in unix timestamp for a pod. |
| ❌ | Static config — QoS class doesn't change | pod | `kube_pod_status_qos_class` | Gauge | The pods current qosClass. |
| ✅ | Core: pod readiness — alert on not-ready pods | pod | `kube_pod_status_ready` | Gauge | Describes whether the pod is ready to serve requests. |
| ✅ | Detect Evicted/NodeAffinity/NodeLost pods (new in v2) | pod | `kube_pod_status_reason` | Gauge | The pod status reasons |
| ❌ | Redundant — scheduling issues surface via phase/unschedulable | pod | `kube_pod_status_scheduled` | Gauge | Describes the status of the scheduling process for the pod. |
| ❌ | Static timestamp, not useful as time-series | pod | `kube_pod_status_scheduled_time` | Gauge | Unix timestamp when pod moved into scheduled status |
| ❌ | Redundant — surfaces via status_phase Pending | pod | `kube_pod_status_unschedulable` | Gauge | Describes the unschedulable status for the pod. |
| ❌ | Niche timing metric — not needed for alerting | pod | `kube_pod_status_unscheduled_time` | Gauge | Unix timestamp when pod moved into unscheduled status |
| ❌ | High cardinality (key × value × effect per pod) | pod | `kube_pod_tolerations` | Gauge | Information about the pod tolerations |
| ❌ | Static config — check via K8s API if needed | pod | `kube_pod_nodeselectors` | Gauge | Describes the Pod nodeSelectors. |
| ❌ | Static config — check via K8s API if needed | pod | `kube_pod_service_account` | Gauge | The service account for a pod. |
| ❌ | Static config — scheduler rarely changes | pod | `kube_pod_scheduler` | Gauge | The scheduler for a pod. |
