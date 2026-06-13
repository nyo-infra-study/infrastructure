# kubelet: 33 keep / 30 drop (63 total) [filter]
# cadvisor: 24 keep / 76 drop (100 total) [filter]
# host-metrics: 14 keep / 25 drop (39 total) [filter]
# cilium: 34 keep / 224 drop (258 total) [scrape]
# envoy: 48 keep / 133 drop (181 total) [scrape]
# node-local-dns: 11 keep / 19 drop (30 total) [scrape]
# otel-collector: 24 keep / 14 drop (38 total) [filter]
# kube-state-metrics: 55 keep / 194 drop (249 total) [scrape]
# traefik: 21 keep / 0 drop (21 total) [scrape]
# coredns: 11 keep / 0 drop (11 total) [scrape]
# keda: 13 keep / 12 drop (25 total) [scrape]
# kyverno: 30 keep / 0 drop (30 total) [scrape]
# karpenter: 67 keep / 53 drop (120 total) [scrape]
# karpenter-core: 15 keep / 11 drop (26 total) [scrape]
# argocd: 27 keep / 14 drop (41 total) [scrape]
# metrics-server: 4 keep / 0 drop (4 total) [scrape]
# argo-rollouts: 18 keep / 8 drop (26 total) [scrape]
# argo-workflows: 17 keep / 13 drop (30 total) [scrape]
# descheduler: 4 keep / 0 drop (4 total) [scrape]
# cert-manager: 7 keep / 3 drop (10 total) [scrape]
# external-secrets: 13 keep / 0 drop (13 total) [scrape]
# clickhouse-operator: 10 keep / 3 drop (13 total) [scrape]
# aws-lbc: 10 keep / 6 drop (16 total) [scrape]
# nidhogg: 5 keep / 2 drop (7 total) [scrape]
# aws-ec2-network: 5 keep / 0 drop (5 total) [filter]
# redis-labs: 46 keep / 151 drop (197 total) [scrape]
# 
# Total: 566 keep / 991 drop (1557 total)
# Scrape-level: 21 sources | Filter-level: 5 sources
#
# === Filter Levels ===
# SCRAPE-LEVEL (metric_relabel_configs) — preferred, drops at scrape time:
#   - argo-rollouts
#   - argo-workflows
#   - argocd
#   - aws-lbc
#   - cert-manager
#   - cilium
#   - clickhouse-operator
#   - coredns
#   - descheduler
#   - envoy
#   - external-secrets
#   - karpenter
#   - karpenter-core
#   - keda
#   - kube-state-metrics
#   - kyverno
#   - metrics-server
#   - nidhogg
#   - node-local-dns
#   - redis-labs
#   - traefik
# FILTER-LEVEL (OTel filter processor) — for non-Prometheus sources:
#   - filter/cadvisor
#   - filter/host-metrics
#   - filter/kubelet
#   - filter/otel-collector
#

# ─── Filter Processors (paste into config.processors) ───
# Add each filter/* to the metrics pipeline processors list.

processors:
  filter/kubelet:
    metrics:
      metric:
        - IsMatch(name, "^(container\.memory\.major_page_faults|container\.memory\.page_faults|container\.uptime|k8s\.container\.cpu\.node\.utilization|k8s\.container\.cpu_limit_utilization|k8s\.container\.cpu_request_utilization|k8s\.container\.ephemeral_storage\.usage|k8s\.container\.memory\.node\.utilization|k8s\.container\.memory_limit_utilization|k8s\.container\.memory_request_utilization|k8s\.node\.memory\.major_page_faults|k8s\.node\.memory\.page_faults|k8s\.node\.system_container\.cpu\.time|k8s\.node\.system_container\.cpu\.usage|k8s\.node\.system_container\.memory\.usage|k8s\.node\.system_container\.memory\.working_set|k8s\.node\.uptime|k8s\.pod\.cpu\.node\.utilization|k8s\.pod\.cpu_limit_utilization|k8s\.pod\.cpu_request_utilization|k8s\.pod\.memory\.major_page_faults|k8s\.pod\.memory\.node\.utilization|k8s\.pod\.memory\.page_faults|k8s\.pod\.memory_limit_utilization|k8s\.pod\.memory_request_utilization|k8s\.pod\.uptime|k8s\.pod\.volume\.usage|k8s\.volume\.inodes|k8s\.volume\.inodes\.free|k8s\.volume\.inodes\.used)$")
  filter/cadvisor:
    metrics:
      metric:
        - IsMatch(name, "^(container_blkio_device_usage_total|container_cpu_load_average_10s|container_cpu_schedstat_run_periods_total|container_cpu_schedstat_run_seconds_total|container_cpu_schedstat_runqueue_seconds_total|container_cpu_system_seconds_total|container_file_descriptors|container_fs_inodes_free|container_fs_inodes_total|container_fs_io_current|container_fs_io_time_seconds_total|container_fs_io_time_weighted_seconds_total|container_fs_limit_bytes|container_fs_read_seconds_total|container_fs_reads_bytes_total|container_fs_reads_merged_total|container_fs_reads_total|container_fs_sector_reads_total|container_fs_sector_writes_total|container_fs_write_seconds_total|container_fs_writes_bytes_total|container_fs_writes_merged_total|container_fs_writes_total|container_health_state|container_hugetlb_failcnt|container_hugetlb_max_usage_bytes|container_hugetlb_usage_bytes|container_llc_occupancy_bytes|container_memory_bandwidth_bytes|container_memory_bandwidth_local_bytes|container_memory_failcnt|container_memory_failures_total|container_memory_file_dirty_bytes|container_memory_file_writeback_bytes|container_memory_mapped_file|container_memory_max_usage_bytes|container_memory_migrate|container_memory_numa_pages|container_memory_pgscan_total|container_memory_pgsteal_total|container_memory_swap|container_memory_workingset_refault_anon_total|container_memory_workingset_refault_file_total|container_network_advance_tcp_stats_total|container_network_receive_packets_total|container_network_tcp6_usage_total|container_network_tcp_usage_total|container_network_transmit_packets_total|container_network_udp6_usage_total|container_network_udp_usage_total|container_perf_events_scaling_ratio|container_perf_events_total|container_perf_uncore_events_scaling_ratio|container_perf_uncore_events_total|container_processes|container_referenced_bytes|container_sockets|container_spec_cpu_period|container_spec_cpu_shares|container_spec_memory_reservation_limit_bytes|container_spec_memory_swap_limit_bytes|container_start_time_seconds|container_tasks_state|container_threads|container_threads_max|container_ulimits_soft|machine_cpu_cache_capacity_bytes|machine_dimm_capacity_bytes|machine_dimm_count|machine_node_distance|machine_node_hugepages_count|machine_node_memory_capacity_bytes|machine_nvm_avg_power_budget_watts|machine_nvm_capacity|machine_swap_bytes|machine_thread_siblings_count)$")
  filter/host-metrics:
    metrics:
      metric:
        - IsMatch(name, "^(system\.cpu\.frequency|system\.cpu\.physical\.count|system\.disk\.merged|system\.disk\.operation_time|system\.disk\.pending_operations|system\.disk\.weighted_io_time|system\.filesystem\.inodes\.usage|system\.linux\.memory\.available|system\.linux\.memory\.dirty|system\.memory\.limit|system\.memory\.linux\.hugepages\.limit|system\.memory\.linux\.hugepages\.page_size|system\.memory\.linux\.hugepages\.reserved|system\.memory\.linux\.hugepages\.surplus|system\.memory\.linux\.hugepages\.usage|system\.memory\.linux\.hugepages\.utilization|system\.memory\.linux\.shared|system\.memory\.page_size|system\.network\.connections|system\.network\.conntrack\.count|system\.network\.conntrack\.max|system\.network\.packets|system\.paging\.faults|system\.paging\.operations|system\.paging\.utilization)$")
  filter/otel-collector:
    metrics:
      metric:
        - IsMatch(name, "^(http\.client\.request\.body\.size|http\.client\.request\.duration|http\.server\.request\.body\.size|http\.server\.request\.duration|http\.server\.response\.body\.size|otelcol_process_runtime_total_alloc_bytes|otelcol_process_runtime_total_sys_memory_bytes|otelcol_processor_batch_metadata_cardinality|otelcol_processor_incoming_items|otelcol_processor_outgoing_items|otelcol_scraper_errored_metric_points|otelcol_scraper_scraped_metric_points|rpc\.client\.call\.duration|rpc\.server\.call\.duration)$")


# ─── Scrape Filters (paste into prometheus receiver scrape_configs) ───
# Add metric_relabel_configs to each matching scrape job.
# These use KEEP action — only listed metrics are retained.

scrape_configs:
  # job_name: cilium
  cilium:
    metric_relabel_configs:
      - source_labels: [__name__]
        regex: "(bpf_map_ops_total|bpf_map_pressure|clustermesh_global_services|controllers_failing|datapath_conntrack_gc_entries|datapath_conntrack_gc_runs_total|drop_bytes_total|drop_count_total|endpoint|endpoint_regenerations_total|endpoint_state|forward_bytes_total|forward_count_total|http_request_duration_seconds|http_requests_total|identity|ip_addresses|ipam_available_ips|ipcache_errors_total|jobs_errors_total|kvstore_events_queue_seconds|kvstore_quorum_errors_total|kvstore_sync_errors_total|lost_events_total|policy|policy_change_total|unreachable_health_endpoints|unreachable_nodes)"
        action: keep

  # job_name: envoy
  envoy:
    metric_relabel_configs:
      - source_labels: [__name__]
        regex: "(attempt|connection_error|cx_open|ejections_active|ejections_enforced_total|ejections_overflow|fail_verify_cert_hash|fail_verify_error|fail_verify_no_cert|fail_verify_san|failure|handshake|healthy|membership_degraded|membership_healthy|membership_total|rq_open|rq_pending_open|rq_retry_open|success|upstream_cx_active|upstream_cx_connect_fail|upstream_cx_connect_ms|upstream_cx_connect_timeout|upstream_cx_destroy_with_active_rq|upstream_cx_none_healthy|upstream_cx_overflow|upstream_cx_pool_overflow|upstream_cx_protocol_error|upstream_cx_total|upstream_rq_active|upstream_rq_cancelled|upstream_rq_completed|upstream_rq_maintenance_mode|upstream_rq_max_duration_reached|upstream_rq_pending_overflow|upstream_rq_pending_total|upstream_rq_per_try_timeout|upstream_rq_retry|upstream_rq_retry_backoff_ratelimited|upstream_rq_retry_limit_exceeded|upstream_rq_retry_overflow|upstream_rq_retry_success|upstream_rq_rx_reset|upstream_rq_time|upstream_rq_timeout|upstream_rq_total|upstream_rq_tx_reset)"
        action: keep

  # job_name: node-local-dns
  node-local-dns:
    metric_relabel_configs:
      - source_labels: [__name__]
        regex: "(coredns_cache_entries|coredns_cache_hits_total|coredns_cache_misses_total|coredns_cache_requests_total|coredns_dns_request_duration_seconds|coredns_dns_requests_total|coredns_dns_responses_total|coredns_forward_healthcheck_broken_total|coredns_forward_request_duration_seconds|coredns_forward_requests_total|coredns_forward_responses_total)"
        action: keep

  # job_name: kube-state-metrics
  kube-state-metrics:
    metric_relabel_configs:
      - source_labels: [__name__]
        regex: "(kube_cronjob_info|kube_cronjob_next_schedule_time|kube_cronjob_status_active|kube_cronjob_status_last_schedule_time|kube_daemonset_status_current_number_scheduled|kube_daemonset_status_desired_number_scheduled|kube_daemonset_status_number_ready|kube_daemonset_status_number_unavailable|kube_deployment_spec_replicas|kube_deployment_spec_strategy_rollingupdate_max_surge|kube_deployment_spec_strategy_rollingupdate_max_unavailable|kube_deployment_status_observed_generation|kube_deployment_status_replicas|kube_deployment_status_replicas_available|kube_deployment_status_replicas_unavailable|kube_horizontalpodautoscaler_info|kube_horizontalpodautoscaler_spec_max_replicas|kube_horizontalpodautoscaler_spec_min_replicas|kube_horizontalpodautoscaler_status_condition|kube_horizontalpodautoscaler_status_current_replicas|kube_job_complete|kube_job_failed|kube_job_status_active|kube_job_status_failed|kube_job_status_succeeded|kube_namespace_status_phase|kube_node_info|kube_node_spec_unschedulable|kube_node_status_allocatable|kube_node_status_capacity|kube_node_status_condition|kube_persistentvolume_capacity_bytes|kube_persistentvolume_status_phase|kube_persistentvolumeclaim_resource_requests_storage_bytes|kube_persistentvolumeclaim_status_phase|kube_pod_container_resource_limits|kube_pod_container_resource_requests|kube_pod_container_status_last_terminated_reason|kube_pod_container_status_restarts_total|kube_pod_container_status_terminated|kube_pod_container_status_terminated_reason|kube_pod_container_status_waiting|kube_pod_container_status_waiting_reason|kube_pod_status_phase|kube_pod_status_ready|kube_pod_status_reason|kube_poddisruptionbudget_status_current_healthy|kube_poddisruptionbudget_status_desired_healthy|kube_poddisruptionbudget_status_pod_disruptions_allowed|kube_replicaset_spec_replicas|kube_replicaset_status_ready_replicas|kube_replicaset_status_replicas|kube_statefulset_replicas|kube_statefulset_status_replicas_current|kube_statefulset_status_replicas_ready)"
        action: keep

  # job_name: traefik
  traefik:
    metric_relabel_configs:
      - source_labels: [__name__]
        regex: "(traefik_config_last_reload_success|traefik_config_reloads_total|traefik_entrypoint_request_duration_seconds|traefik_entrypoint_requests_bytes_total|traefik_entrypoint_requests_tls_total|traefik_entrypoint_requests_total|traefik_entrypoint_responses_bytes_total|traefik_open_connections|traefik_router_request_duration_seconds|traefik_router_requests_bytes_total|traefik_router_requests_tls_total|traefik_router_requests_total|traefik_router_responses_bytes_total|traefik_service_request_duration_seconds|traefik_service_requests_bytes_total|traefik_service_requests_tls_total|traefik_service_requests_total|traefik_service_responses_bytes_total|traefik_service_retries_total|traefik_service_server_up|traefik_tls_certs_not_after)"
        action: keep

  # job_name: coredns
  coredns:
    metric_relabel_configs:
      - source_labels: [__name__]
        regex: "(coredns_build_info|coredns_dns_do_requests_total|coredns_dns_https_responses_total|coredns_dns_quic_responses_total|coredns_dns_request_duration_seconds|coredns_dns_request_size_bytes|coredns_dns_requests_total|coredns_dns_response_size_bytes|coredns_dns_responses_total|coredns_panics_total|coredns_plugin_enabled)"
        action: keep

  # job_name: keda
  keda:
    metric_relabel_configs:
      - source_labels: [__name__]
        regex: "(keda_build_info|keda_internal_scale_loop_latency_seconds|keda_resource_registered_total|keda_scaled_job_errors_total|keda_scaled_object_errors_total|keda_scaled_object_paused|keda_scaler_active|keda_scaler_detail_errors_total|keda_scaler_metrics_latency_seconds|keda_scaler_metrics_value|keda_trigger_registered_total|keda_webhook_scaled_object_validation_errors|keda_webhook_scaled_object_validation_total)"
        action: keep

  # job_name: kyverno
  kyverno:
    metric_relabel_configs:
      - source_labels: [__name__]
        regex: "(kyverno_admission_requests_total|kyverno_admission_review_duration_seconds_bucket|kyverno_admission_review_duration_seconds_sum|kyverno_cleanup_controller_deletedobjects_total|kyverno_cleanup_controller_errors_total|kyverno_client_queries_total|kyverno_controller_drop_total|kyverno_controller_reconcile_total|kyverno_controller_requeue_total|kyverno_deleting_controller_deletedobjects_total|kyverno_deleting_controller_errors_total|kyverno_generating_policy_execution_duration_seconds_bucket|kyverno_generating_policy_execution_duration_seconds_sum|kyverno_http_requests_duration_seconds_bucket|kyverno_http_requests_duration_seconds_sum|kyverno_http_requests_total|kyverno_image_validating_policy_execution_duration_seconds_bucket|kyverno_image_validating_policy_execution_duration_seconds_sum|kyverno_info|kyverno_mutating_policy_execution_duration_seconds_bucket|kyverno_mutating_policy_execution_duration_seconds_sum|kyverno_policy_changes_total|kyverno_policy_execution_duration_seconds_bucket|kyverno_policy_execution_duration_seconds_sum|kyverno_policy_results|kyverno_policy_rule_info_total|kyverno_ttl_controller_deletedobjects|kyverno_ttl_controller_errors|kyverno_validating_policy_execution_duration_seconds_bucket|kyverno_validating_policy_execution_duration_seconds_sum)"
        action: keep

  # job_name: karpenter
  karpenter:
    metric_relabel_configs:
      - source_labels: [__name__]
        regex: "(aws_sdk_go_request_attempt_duration_seconds|aws_sdk_go_request_attempt_total|aws_sdk_go_request_duration_seconds|aws_sdk_go_request_retry_count|aws_sdk_go_request_total|client_go_request_duration_seconds|client_go_request_total|controller_runtime_active_workers|controller_runtime_conversion_webhook_panics_total|controller_runtime_max_concurrent_reconciles|controller_runtime_reconcile_errors_total|controller_runtime_reconcile_panics_total|controller_runtime_reconcile_time_seconds|controller_runtime_reconcile_total|controller_runtime_terminal_reconcile_errors_total|karpenter_build_info|karpenter_cloudprovider_duration_seconds|karpenter_cloudprovider_errors_total|karpenter_cluster_state_node_count|karpenter_cluster_state_synced|karpenter_cluster_state_unsynced_time_seconds|karpenter_cluster_utilization_percent|karpenter_interruption_deleted_messages_total|karpenter_interruption_instance_status_unhealthy_total|karpenter_interruption_message_queue_duration_seconds|karpenter_interruption_received_messages_total|karpenter_nodeclaims_created_total|karpenter_nodeclaims_disrupted_total|karpenter_nodeclaims_instance_termination_duration_seconds|karpenter_nodeclaims_terminated_total|karpenter_nodeclaims_termination_duration_seconds|karpenter_nodeclaims_unhealthy_disrupted_total|karpenter_nodepools_cost_total|karpenter_nodepools_limit|karpenter_nodepools_usage|karpenter_nodes_allocatable|karpenter_nodes_created_total|karpenter_nodes_drained_total|karpenter_nodes_terminated_total|karpenter_nodes_termination_duration_seconds|karpenter_nodes_total_pod_limits|karpenter_nodes_total_pod_requests|karpenter_pods_bound_duration_seconds|karpenter_pods_drained_total|karpenter_pods_eviction_requests_total|karpenter_pods_startup_duration_seconds|karpenter_pods_state|karpenter_scheduler_queue_depth|karpenter_scheduler_scheduling_duration_seconds|karpenter_scheduler_unschedulable_pods_count|karpenter_voluntary_disruption_consolidation_timeouts_total|karpenter_voluntary_disruption_decisions_total|karpenter_voluntary_disruption_eligible_nodes|karpenter_voluntary_disruption_queue_failures_total|leader_election_master_status|leader_election_slowpath_total|operator_ec2nodeclass_status_condition_transitions_total|operator_node_status_condition_transitions_total|operator_nodeclaim_status_condition_transitions_total|operator_nodepool_status_condition_transitions_total|workqueue_adds_total|workqueue_depth|workqueue_longest_running_processor_seconds|workqueue_queue_duration_seconds|workqueue_retries_total|workqueue_unfinished_work_seconds|workqueue_work_duration_seconds)"
        action: keep

  # job_name: karpenter-core
  karpenter-core:
    metric_relabel_configs:
      - source_labels: [__name__]
        regex: "(karpenter_cluster_utilization_percent|karpenter_nodeclaims_created_total|karpenter_nodeclaims_disrupted_total|karpenter_nodeclaims_terminated_total|karpenter_nodepools_cost_total|karpenter_nodepools_limit|karpenter_nodepools_usage|karpenter_nodes_allocatable|karpenter_nodes_created_total|karpenter_nodes_terminated_total|karpenter_nodes_total_pod_limits|karpenter_nodes_total_pod_requests|karpenter_pods_bound_duration_seconds|karpenter_pods_startup_duration_seconds|karpenter_pods_state)"
        action: keep

  # job_name: argocd
  argocd:
    metric_relabel_configs:
      - source_labels: [__name__]
        regex: "(argocd_app_condition|argocd_app_info|argocd_app_k8s_request_total|argocd_app_orphaned_resources_count|argocd_app_reconcile|argocd_app_sync_total|argocd_appset_info|argocd_appset_owned_applications|argocd_appset_reconcile|argocd_cluster_api_resource_objects|argocd_cluster_api_resources|argocd_cluster_cache_age_seconds|argocd_cluster_connection_status|argocd_cluster_events_total|argocd_cluster_info|argocd_git_fetch_fail_total|argocd_git_request_duration_seconds|argocd_git_request_total|argocd_kubectl_exec_pending|argocd_kubectl_exec_total|argocd_redis_request_duration|argocd_redis_request_duration_seconds|argocd_redis_request_total|argocd_repo_pending_request_total)"
        action: keep

  # job_name: metrics-server
  metrics-server:
    metric_relabel_configs:
      - source_labels: [__name__]
        regex: "(metrics_server_api_metric_freshness_seconds|metrics_server_kubelet_last_request_time_seconds|metrics_server_kubelet_request_duration_seconds|metrics_server_kubelet_request_total)"
        action: keep

  # job_name: argo-rollouts
  argo-rollouts:
    metric_relabel_configs:
      - source_labels: [__name__]
        regex: "(analysis_run_info|analysis_run_metric_phase|analysis_run_phase|analysis_run_reconcile|analysis_run_reconcile_error|controller_clientset_k8s_request_total|experiment_info|experiment_reconcile|experiment_reconcile_error|rollout_info|rollout_info_replicas_available|rollout_info_replicas_desired|rollout_info_replicas_unavailable|rollout_info_replicas_updated|rollout_reconcile|rollout_reconcile_error|workqueue_adds_total|workqueue_depth)"
        action: keep

  # job_name: argo-workflows
  argo-workflows:
    metric_relabel_configs:
      - source_labels: [__name__]
        regex: "(cronworkflows_concurrencypolicy_triggered|cronworkflows_triggered_total|deprecated_feature|error_count|gauge|is_leader|k8s_request_duration|operation_duration_seconds|pod_missing|pod_pending_count|pod_restarts_total|pods_gauge|queue_adds_count|queue_depth_gauge|total_count|workers_busy_count|workflow_condition)"
        action: keep

  # job_name: descheduler
  descheduler:
    metric_relabel_configs:
      - source_labels: [__name__]
        regex: "(descheduler_build_info|descheduler_descheduler_loop_duration_seconds|descheduler_descheduler_strategy_duration_seconds|descheduler_pods_evicted)"
        action: keep

  # job_name: cert-manager
  cert-manager:
    metric_relabel_configs:
      - source_labels: [__name__]
        regex: "(certmanager_certificate_expiration_timestamp_seconds|certmanager_certificate_ready_status|certmanager_certificate_renewal_timestamp_seconds|certmanager_controller_sync_call_count|certmanager_controller_sync_error_count|certmanager_http_acme_client_request_count|certmanager_http_acme_client_request_duration_seconds)"
        action: keep

  # job_name: external-secrets
  external-secrets:
    metric_relabel_configs:
      - source_labels: [__name__]
        regex: "(clusterexternalsecret_reconcile_duration|clusterexternalsecret_status_condition|clustersecretstore_reconcile_duration|clustersecretstore_status_condition|externalsecret_provider_api_calls_count|externalsecret_reconcile_duration|externalsecret_status_condition|externalsecret_sync_calls_error|externalsecret_sync_calls_total|pushsecret_reconcile_duration|pushsecret_status_condition|secretstore_reconcile_duration|secretstore_status_condition)"
        action: keep

  # job_name: clickhouse-operator
  clickhouse-operator:
    metric_relabel_configs:
      - source_labels: [__name__]
        regex: "(clickhouse_operator_chi|clickhouse_operator_chi_reconciles_aborted|clickhouse_operator_chi_reconciles_completed|clickhouse_operator_chi_reconciles_started|clickhouse_operator_chi_reconciles_timings|clickhouse_operator_host_reconciles_completed|clickhouse_operator_host_reconciles_errors|clickhouse_operator_host_reconciles_restarts|clickhouse_operator_host_reconciles_started|clickhouse_operator_host_reconciles_timings)"
        action: keep

  # job_name: aws-lbc
  aws-lbc:
    metric_relabel_configs:
      - source_labels: [__name__]
        regex: "(aws_api_call_duration_seconds|aws_api_call_permission_errors_total|aws_api_call_retries|aws_api_call_service_limit_exceeded_errors_total|aws_api_call_throttled_errors_total|aws_api_call_validation_errors_total|aws_api_calls_total|awslbc_controller_reconcile_errors_total|awslbc_controller_reconcile_stage_duration|awslbc_readiness_gate_ready_seconds)"
        action: keep

  # job_name: nidhogg
  nidhogg:
    metric_relabel_configs:
      - source_labels: [__name__]
        regex: "(controller_runtime_reconcile_errors_total|controller_runtime_reconcile_panics_total|controller_runtime_reconcile_time_seconds|controller_runtime_reconcile_total|controller_runtime_terminal_reconcile_errors_total)"
        action: keep

  # job_name: redis-labs
  redis-labs:
    metric_relabel_configs:
      - source_labels: [__name__]
        regex: "(db_config|db_status|endpoint_accepted_connections|endpoint_client_connections|endpoint_egress|endpoint_ingress|endpoint_ping_failure_duration_seconds|endpoint_ping_failures|endpoint_read_requests|endpoint_read_requests_latency_histogram|endpoint_write_requests|endpoint_write_requests_latency_histogram|license_expiration_days|node_available_memory_bytes|node_cert_expires_in_seconds|node_metrics_up|redis_server_blocked_clients|redis_server_connected_clients|redis_server_connected_slaves|redis_server_db_keys|redis_server_evicted_keys|redis_server_keyspace_read_hits|redis_server_keyspace_read_misses|redis_server_maxmemory|redis_server_mem_fragmentation_ratio|redis_server_search_active_coord_threads|redis_server_search_active_worker_threads|redis_server_search_coord_high_priority_pending_jobs|redis_server_search_coord_total_query_errors_arguments|redis_server_search_coord_total_query_errors_oom|redis_server_search_coord_total_query_errors_syntax|redis_server_search_coord_total_query_errors_timeout|redis_server_search_shard_total_query_errors_arguments|redis_server_search_shard_total_query_errors_oom|redis_server_search_shard_total_query_errors_syntax|redis_server_search_shard_total_query_errors_timeout|redis_server_search_total_num_docs_in_indexes|redis_server_search_workers_admin_priority_pending_jobs|redis_server_search_workers_high_priority_pending_jobs|redis_server_search_workers_low_priority_pending_jobs|redis_server_total_commands_processed|redis_server_total_connections_received|redis_server_total_net_input_bytes|redis_server_total_net_output_bytes|redis_server_up|redis_server_used_memory)"
        action: keep

