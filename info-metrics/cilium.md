# cilium — Metric Filter Decisions

> Version: 1.18
> Docs: https://docs.cilium.io/en/v1.18/observability/metrics/
> Generated from: `output/*/parsed/cilium.csv`

---

| Use | Reason | component | metric_name | labels | default_enabled | description |
| --- | --- | --- | --- | --- | --- | --- |
| ❌ | Static config flag | cilium-agent | `bandwidth_manager_enabled` | None |  | Bandwidth Manager enabled on the agent |
| ❌ | Static config flag | cilium-agent | `bgp_enabled` | None |  | BGP enabled on the agent |
| ❌ | Static config flag | cilium-agent | `big_tcp_enabled` | address_family |  | Big TCP enabled on the agent |
| ❌ | Static config flag | cilium-agent | `cilium_envoy_config_enabled` | None |  | Cilium Envoy Config enabled on the agent |
| ❌ | Static config flag | cilium-agent | `cilium_node_config_enabled` | None |  | Cilium Node Config enabled on the agent |
| ❌ | Static config flag | cilium-agent | `clustermesh_enabled` | max_connected_clusters |  | Mode of the active Cluster Mesh connections/peers |
| ❌ | Static config flag | cilium-agent | `egress_gateway_enabled` | None |  | Egress Gateway enabled on the agent |
| ❌ | Static config flag | cilium-agent | `envoy_proxy_enabled` | mode |  | Envoy Proxy mode enabled on the agent |
| ❌ | Static config flag | cilium-agent | `k8s_internal_traffic_policy_enabled` | None |  | K8s Internal Traffic Policy enabled on the agent |
| ❌ | Static config flag | cilium-agent | `kube_proxy_replacement_enabled` | None |  | KubeProxyReplacement enabled on the agent |
| ❌ | Static config flag | cilium-agent | `l2_lb_enabled` | None |  | L2 LB announcement enabled on the agent |
| ❌ | Static config flag | cilium-agent | `l2_pod_announcement_enabled` | None |  | L2 pod announcement enabled on the agent |
| ❌ | Static config flag | cilium-agent | `node_port_configuration` | acceleration |  | Node Port configuration enabled on the agent |
| ❌ | Static config flag | cilium-agent | `sctp_enabled` | None |  | SCTP enabled on the agent |
| ❌ | Static config flag | cilium-agent | `transparent_encryption` | mode |  | Encryption mode enabled on the agent |
| ❌ | Static config flag | cilium-agent | `vtep_enabled` | None |  | VTEP enabled on the agent |
| ❌ | Static config flag | cilium-agent | `cilium_endpoint_slices_enabled` | None |  | Cilium Endpoint Slices enabled on the agent |
| ❌ | Static config flag | cilium-agent | `identity_allocation` | mode |  | Identity Allocation mode enabled on the agent |
| ❌ | Static config flag | cilium-agent | `ipam` | mode |  | IPAM mode enabled on the agent |
| ❌ | Static config flag | cilium-agent | `chaining_enabled` | mode |  | Chaining mode enabled on the agent |
| ❌ | Static config flag | cilium-agent | `config` | mode |  | Datapath config mode enabled on the agent |
| ❌ | Static config flag | cilium-agent | `internet_protocol` | address_family |  | IP mode enabled on the agent |
| ❌ | Static config flag | cilium-agent | `network` | mode |  | Network mode enabled on the agent |
| ❌ | Static config | cilium-agent | `cidr_policies` | mode |  | Mode to apply CIDR Policies to Nodes |
| ❌ | Policy ingestion counter — niche | cilium-agent | `cilium_clusterwide_envoy_config_total` | action |  | Cilium Clusterwide Envoy Config have been ingested since the agent started |
| ❌ | Policy ingestion counter — niche | cilium-agent | `cilium_clusterwide_network_policies_total` | action |  | Cilium Clusterwide Network Policies have been ingested since the agent started |
| ❌ | Policy ingestion counter — niche | cilium-agent | `cilium_envoy_config_total` | action |  | Cilium Envoy Config have been ingested since the agent started |
| ❌ | Policy ingestion counter — niche | cilium-agent | `cilium_network_policies_total` | action |  | Cilium Network Policies have been ingested since the agent started |
| ❌ | Policy ingestion counter — niche | cilium-agent | `deny_policies_total` | action |  | Deny Policies have been ingested since the agent started |
| ❌ | Policy ingestion counter — niche | cilium-agent | `dns_policies_total` | action |  | DNS Policies have been ingested since the agent started |
| ❌ | Policy ingestion counter — niche | cilium-agent | `fqdn_policies_total` | action |  | ToFQDNs Policies have been ingested since the agent started |
| ❌ | Static config flag | cilium-agent | `host_firewall_enabled` | None |  | Host firewall enabled on the agent |
| ❌ | Policy ingestion counter — niche | cilium-agent | `host_network_policies_total` | action |  | Host Network Policies have been ingested since the agent started |
| ❌ | Policy ingestion counter — niche | cilium-agent | `http_header_matches_policies_total` | action |  | HTTP HeaderMatches Policies have been ingested since the agent started |
| ❌ | Policy ingestion counter — niche | cilium-agent | `http_policies_total` | action |  | HTTP/GRPC Policies have been ingested since the agent started |
| ❌ | Policy ingestion counter — niche | cilium-agent | `ingress_cidr_group_policies_total` | action |  | Ingress CIDR Group Policies have been ingested since the agent started |
| ❌ | Policy ingestion counter — niche | cilium-agent | `internal_traffic_policy_services_total` | action |  | K8s Services with Internal Traffic Policy have been ingested since the agent ... |
| ❌ | Policy ingestion counter — niche | cilium-agent | `l3_policies_total` | action |  | Layer 3 and Layer 4 policies have been ingested since the agent started |
| ❌ | Policy ingestion counter — niche | cilium-agent | `local_redirect_policies_total` | action |  | Local Redirect Policies have been ingested since the agent started |
| ❌ | Static config flag | cilium-agent | `local_redirect_policy_enabled` | None |  | Local Redirect Policy enabled on the agent |
| ❌ | Static config flag | cilium-agent | `mutual_auth_enabled` | None |  | Mutual Auth enabled on the agent |
| ❌ | Policy ingestion counter — niche | cilium-agent | `mutual_auth_policies_total` | action |  | Mutual Auth Policies have been ingested since the agent started |
| ❌ | Static config flag | cilium-agent | `non_defaultdeny_policies_enabled` | None |  | Non DefaultDeny Policies is enabled in the agent |
| ❌ | Policy ingestion counter — niche | cilium-agent | `non_defaultdeny_policies_total` | action |  | Non DefaultDeny Policies have been ingested since the agent started |
| ❌ | Policy ingestion counter — niche | cilium-agent | `other_l7_policies_total` | action |  | Other L7 Policies have been ingested since the agent started |
| ❌ | Policy ingestion counter — niche | cilium-agent | `sni_allow_list_policies_total` | action |  | SNI Allow List Policies have been ingested since the agent started |
| ❌ | Policy ingestion counter — niche | cilium-agent | `tls_inspection_policies_total` | action |  | TLS Inspection Policies have been ingested since the agent started |
| ✅ | Core — how many endpoints managed | cilium-agent | `endpoint` |  | Enabled | Number of endpoints managed by this agent |
| ❌ | Disabled by default, niche debugging | cilium-agent | `endpoint_max_ifindex` |  | Disabled | Maximum interface index observed for existing endpoints |
| ✅ | High rate = policy churn | cilium-agent | `endpoint_regenerations_total` | outcome | Enabled | Count of all endpoint regenerations that have completed |
| ❌ | Endpoint regeneration time stats | cilium-agent | `endpoint_regeneration_time_stats_seconds` | scope | Enabled | Endpoint regeneration time stats |
| ✅ | Detect endpoints stuck in non-ready state | cilium-agent | `endpoint_state` | state | Enabled | Count of all endpoints |
| ❌ | Number of services events labeled by action type | cilium-agent | `services_events_total` |  | Enabled | Number of services events labeled by action type |
| ❌ | Duration in seconds to propagate the data plane programmi... | cilium-agent | `service_implementation_delay` | action | Enabled | Duration in seconds to propagate the data plane programming of a service, its... |
| ✅ | > 0 = network partition | cilium-agent | `unreachable_nodes` |  | Enabled | Number of nodes that cannot be reached |
| ✅ | > 0 = connectivity issue | cilium-agent | `unreachable_health_endpoints` |  | Enabled | Number of health endpoints that cannot be reached |
| ❌ | Number of endpoints with last observed status of both ICM... | cilium-agent | `node_health_connectivity_status` | source_cluster, source_node_name, type, status | Enabled | Number of endpoints with last observed status of both ICMP and HTTP connectiv... |
| ❌ | Histogram of the last observed latency between the curren... | cilium-agent | `node_health_connectivity_latency_seconds` | source_cluster, source_node_name, type, address_type, protocol | Enabled | Histogram of the last observed latency between the current Cilium agent and o... |
| ✅ | ClusterMesh service inventory | cilium-agent | `clustermesh_global_services` | source_cluster, source_node_name | Enabled | The total number of global services in the cluster mesh |
| ❌ | The total number of remote clusters meshed with the local... | cilium-agent | `clustermesh_remote_clusters` | source_cluster, source_node_name | Enabled | The total number of remote clusters meshed with the local cluster |
| ❌ | The total number of failures related to the remote cluster | cilium-agent | `clustermesh_remote_cluster_failures` | source_cluster, source_node_name, target_cluster | Enabled | The total number of failures related to the remote cluster |
| ❌ | The total number of nodes per remote cluster | cilium-agent | `clustermesh_remote_cluster_nodes` | source_cluster, source_node_name, target_cluster | Enabled | The total number of nodes in the remote cluster |
| ❌ | The timestamp of the last failure of the remote cluster | cilium-agent | `clustermesh_remote_cluster_last_failure_ts` | source_cluster, source_node_name, target_cluster | Enabled | The timestamp of the last failure of the remote cluster |
| ❌ | The readiness status of the remote cluster | cilium-agent | `clustermesh_remote_cluster_readiness_status` | source_cluster, source_node_name, target_cluster | Enabled | The readiness status of the remote cluster |
| ❌ | Number of conntrack dump resets. Happens when a BPF entry... | cilium-agent | `datapath_conntrack_dump_resets_total` | area, name, family | Enabled | Number of conntrack dump resets. Happens when a BPF entry gets removed while ... |
| ✅ | Conntrack health | cilium-agent | `datapath_conntrack_gc_runs_total` | status | Enabled | Number of times that the conntrack garbage collector process was run |
| ❌ | The number of alive and deleted conntrack entries at the ... | cilium-agent | `datapath_conntrack_gc_key_fallbacks_total` |  | Enabled | The number of alive and deleted conntrack entries at the end of a garbage col... |
| ✅ | Conntrack table size | cilium-agent | `datapath_conntrack_gc_entries` | family | Enabled | The number of alive and deleted conntrack entries at the end of a garbage col... |
| ❌ | Duration in seconds of the garbage collector process IPsec  | cilium-agent | `datapath_conntrack_gc_duration_seconds` | status | Enabled | Duration in seconds of the garbage collector process |
| ❌ | Total number of xfrm errors | cilium-agent | `ipsec_xfrm_error` | error, type | Enabled | Total number of xfrm errors |
| ❌ | Number of keys in use | cilium-agent | `ipsec_keys` |  | Enabled | Number of keys in use |
| ❌ | Number of XFRM states | cilium-agent | `ipsec_xfrm_states` | direction | Enabled | Number of XFRM states |
| ❌ | Number of XFRM policies eBPF  | cilium-agent | `ipsec_xfrm_policies` | direction | Enabled | Number of XFRM policies |
| ❌ | Duration of eBPF system call performed | cilium-agent | `bpf_syscall_duration_seconds` | operation, outcome | Disabled | Duration of eBPF system call performed |
| ✅ | Eaglepoint dashboard — BPF map ops | cilium-agent | `bpf_map_ops_total` | mapName (deprecated), map_name, operation, outcome | Enabled | Number of eBPF map operations performed. mapName is deprecated and will be re... |
| ✅ | Approaching 1.0 = map full, drops | cilium-agent | `bpf_map_pressure` | map_name | Enabled | Map pressure is defined as a ratio of the required map size compared to its c... |
| ❌ | Maximum size of eBPF maps by group of maps (type of map t... | cilium-agent | `bpf_map_capacity` | map_group | Enabled | Maximum size of eBPF maps by group of maps (type of map that have the same ma... |
| ❌ | Max memory used by eBPF maps installed in the system | cilium-agent | `bpf_maps_virtual_memory_max_bytes` |  | Enabled | Max memory used by eBPF maps installed in the system |
| ❌ | Max memory used by eBPF programs installed in the system | cilium-agent | `bpf_progs_virtual_memory_max_bytes` |  | Enabled | Max memory used by eBPF programs installed in the system |
| ❌ | Total drops resulting from BPF ratelimiter, tagged by sou... | cilium-agent | `bpf_ratelimit_dropped_total` | usage | Enabled | Total drops resulting from BPF ratelimiter, tagged by source of drop |
| ✅ | Core — network drops = policy issues | cilium-agent | `drop_count_total` | reason, direction | Enabled | Total dropped packets |
| ✅ | Complements drop_count | cilium-agent | `drop_bytes_total` | reason, direction | Enabled | Total dropped bytes |
| ✅ | Baseline network throughput | cilium-agent | `forward_count_total` | direction | Enabled | Total forwarded packets |
| ✅ | Baseline | cilium-agent | `forward_bytes_total` | direction | Enabled | Total forwarded bytes |
| ✅ | Core — policy inventory | cilium-agent | `policy` |  | Enabled | Number of policies currently loaded |
| ❌ | Deprecated, use endpoint_regenerations_total | cilium-agent | `policy_regeneration_total` |  | Enabled | Deprecated, will be removed in Cilium 1.17 - use endpoint_regenerations_total... |
| ❌ | Deprecated | cilium-agent | `policy_regeneration_time_stats_seconds` | scope | Enabled | Deprecated, will be removed in Cilium 1.17 - use endpoint_regeneration_time_s... |
| ❌ | Highest policy revision number in the agent | cilium-agent | `policy_max_revision` |  | Enabled | Highest policy revision number in the agent |
| ✅ | Policy changes by outcome | cilium-agent | `policy_change_total` |  | Enabled | Number of policy changes by outcome |
| ❌ | Number of endpoints labeled by policy enforcement status | cilium-agent | `policy_endpoint_enforcement_status` |  | Enabled | Number of endpoints labeled by policy enforcement status |
| ❌ | Time in seconds between a policy change and it being full... | cilium-agent | `policy_implementation_delay` | source | Enabled | Time in seconds between a policy change and it being fully deployed into the ... |
| ❌ | The maximum number of identities selected by a network po... | cilium-agent | `policy_selector_match_count_max` | class | Enabled | The maximum number of identities selected by a network policy selector |
| ❌ | The time taken for newly learned identities to be added t... | cilium-agent | `policy_incremental_update_duration` | scope | Enabled | The time taken for newly learned identities to be added to the policy system,... |
| ❌ | Number of redirects installed for endpoints | cilium-agent | `proxy_redirects` | protocol | Enabled | Number of redirects installed for endpoints |
| ❌ | Seconds waited for upstream server to reply to a request | cilium-agent | `proxy_upstream_reply_seconds` | error, protocol_l7, scope | Enabled | Seconds waited for upstream server to reply to a request |
| ❌ | Number of total datapath update timeouts due to FQDN IP u... | cilium-agent | `proxy_datapath_update_timeout_total` |  | Disabled | Number of total datapath update timeouts due to FQDN IP updates |
| ❌ | Number of total L7 requests/responses Identity  | cilium-agent | `policy_l7_total` | rule, proxy_type | Enabled | Number of total L7 requests/responses |
| ✅ | Identity capacity — exhaustion breaks networking | cilium-agent | `identity` | type | Enabled | Number of identities currently allocated |
| ❌ | Number of identities which contain at least one label fro... | cilium-agent | `identity_label_sources` | source | Enabled | Number of identities which contain at least one label from the given label so... |
| ❌ | Number of alive and deleted identities at the end of a ga... | cilium-agent | `identity_gc_entries` | identity_type | Enabled | Number of alive and deleted identities at the end of a garbage collector run |
| ❌ | Number of times identity garbage collector has run | cilium-agent | `identity_gc_runs` | outcome, identity_type | Enabled | Number of times identity garbage collector has run |
| ❌ | Duration of the last successful identity GC run | cilium-agent | `identity_gc_latency` | outcome, identity_type | Enabled | Duration of the last successful identity GC run |
| ✅ | > 0 = routing issues | cilium-agent | `ipcache_errors_total` | type, error | Enabled | Number of errors interacting with the ipcache |
| ❌ | Number of events interacting with the ipcache | cilium-agent | `ipcache_events_total` | type | Enabled | Number of events interacting with the ipcache |
| ❌ | Seconds required to execute periodic policy processes. na... | cilium-agent | `identity_cache_timer_duration` | name | Enabled | Seconds required to execute periodic policy processes. name="id-alloc-update-... |
| ❌ | Seconds spent waiting for a previous process to finish be... | cilium-agent | `identity_cache_timer_trigger_latency` | name | Enabled | Seconds spent waiting for a previous process to finish before starting the ne... |
| ❌ | Number of timer triggers that were coalesced in to one ex... | cilium-agent | `identity_cache_timer_trigger_folds` | name | Enabled | Number of timer triggers that were coalesced in to one execution. name="id-al... |
| ❌ | Last timestamp when Cilium received an event from a contr... | cilium-agent | `event_ts` | source | Enabled | Last timestamp when Cilium received an event from a control plane source, per... |
| ❌ | Lag for Kubernetes events - computed value between receiv... | cilium-agent | `k8s_event_lag_seconds` | source | Disabled | Lag for Kubernetes events - computed value between receiving a CNI ADD event ... |
| ❌ | Number of times that a controller process was run | cilium-agent | `controllers_runs_total` | status | Enabled | Number of times that a controller process was run |
| ❌ | Duration in seconds of the controller process | cilium-agent | `controllers_runs_duration_seconds` | status | Enabled | Duration in seconds of the controller process |
| ❌ | Number of times that a controller process was run, labele... | cilium-agent | `controllers_group_runs_total` | status, group_name | Enabled | Number of times that a controller process was run, labeled by controller grou... |
| ✅ | > 0 = agent internal issue | cilium-agent | `controllers_failing` |  | Enabled | Number of failing controllers |
| ❌ | Number of times that Cilium has started a subprocess Kube... | cilium-agent | `subprocess_start_total` | subsystem | Enabled | Number of times that Cilium has started a subprocess |
| ❌ | Number of Kubernetes events received | cilium-agent | `kubernetes_events_received_total` | scope, action, validity, equal | Enabled | Number of Kubernetes events received |
| ❌ | Number of Kubernetes events processed | cilium-agent | `kubernetes_events_total` | scope, action, outcome | Enabled | Number of Kubernetes events processed |
| ❌ | Duration in seconds in how long it took to complete a CNP... | cilium-agent | `k8s_cnp_status_completion_seconds` | attempts, outcome | Enabled | Duration in seconds in how long it took to complete a CNP status update |
| ❌ | Number of terminating endpoint events received from Kuber... | cilium-agent | `k8s_terminating_endpoints_events_total` |  | Enabled | Number of terminating endpoint events received from Kubernetes |
| ❌ | Duration of processed API calls labeled by path and method | cilium-agent | `k8s_client_api_latency_time_seconds` | path, method | Enabled | Duration of processed API calls labeled by path and method |
| ❌ | Kubernetes client rate limiter latency in seconds. | cilium-agent | `k8s_client_rate_limiter_duration_seconds` | path, method | Enabled | Kubernetes client rate limiter latency in seconds. Broken down by path and me... |
| ❌ | Number of API calls made to kube-apiserver labeled by hos... | cilium-agent | `k8s_client_api_calls_total` | host, method, return_code | Enabled | Number of API calls made to kube-apiserver labeled by host, method and return... |
| ❌ | Current depth of workqueue | cilium-agent | `k8s_workqueue_depth` | name | Enabled | Current depth of workqueue |
| ❌ | Total number of adds handled by workqueue | cilium-agent | `k8s_workqueue_adds_total` | name | Enabled | Total number of adds handled by workqueue |
| ❌ | Duration in seconds an item stays in workqueue prior to r... | cilium-agent | `k8s_workqueue_queue_duration_seconds` | name | Enabled | Duration in seconds an item stays in workqueue prior to request |
| ❌ | Duration in seconds to process an item from workqueue | cilium-agent | `k8s_workqueue_work_duration_seconds` | name | Enabled | Duration in seconds to process an item from workqueue |
| ❌ | Duration in seconds of work in progress that hasn’t been ... | cilium-agent | `k8s_workqueue_unfinished_work_seconds` | name | Enabled | Duration in seconds of work in progress that hasn’t been observed by work_dur... |
| ❌ | Duration in seconds of the longest running processor for ... | cilium-agent | `k8s_workqueue_longest_running_processor_seconds` | name | Enabled | Duration in seconds of the longest running processor for workqueue |
| ❌ | Total number of retries handled by workqueue IPAM  | cilium-agent | `k8s_workqueue_retries_total` | name | Enabled | Total number of retries handled by workqueue |
| ❌ | Total number of IPs in the IPAM pool labeled by family | cilium-agent | `ipam_capacity` | family | Enabled | Total number of IPs in the IPAM pool labeled by family |
| ❌ | Number of IPAM events received labeled by action and data... | cilium-agent | `ipam_events_total` |  | Enabled | Number of IPAM events received labeled by action and datapath family type |
| ✅ | IP exhaustion detection | cilium-agent | `ip_addresses` | family | Enabled | Number of allocated IP addresses |
| ❌ | Duration of kvstore operation | cilium-agent | `kvstore_operations_duration_seconds` | action, kind, outcome, scope | Enabled | Duration of kvstore operation |
| ✅ | Eaglepoint dashboard — kvstore queue | cilium-agent | `kvstore_events_queue_seconds` | action, scope | Enabled | Seconds waited before a received event was queued |
| ✅ | > 0 = etcd quorum issues | cilium-agent | `kvstore_quorum_errors_total` | error | Enabled | Number of quorum errors |
| ✅ | > 0 = state inconsistency | cilium-agent | `kvstore_sync_errors_total` | scope, source_cluster | Enabled | Number of times synchronization to the kvstore failed |
| ❌ | Number of elements queued for synchronization in the kvstore | cilium-agent | `kvstore_sync_queue_size` | scope, source_cluster | Enabled | Number of elements queued for synchronization in the kvstore |
| ❌ | Whether the initial synchronization from/to the kvstore h... | cilium-agent | `kvstore_initial_sync_completed` | scope, source_cluster, action | Enabled | Whether the initial synchronization from/to the kvstore has completed |
| ❌ | Deprecated, will be removed in Cilium 1.20 - use | cilium-agent | `agent_bootstrap_seconds` | scope, outcome | Enabled | Duration of various bootstrap phases |
| ❌ | Internal API latency — niche debugging | cilium-agent | `api_process_time_seconds` |  | Enabled | Processing time of all the API calls made to the cilium-agent, labeled by API... |
| ❌ | Number of FQDNs that have been cleaned on FQDN garbage co... | cilium-agent | `fqdn_gc_deletions_total` |  | Enabled | Number of FQDNs that have been cleaned on FQDN garbage collector job |
| ❌ | Number of domains inside the DNS cache that have not expi... | cilium-agent | `fqdn_active_names` | endpoint | Disabled | Number of domains inside the DNS cache that have not expired (by TTL), per en... |
| ❌ | Number of IPs inside the DNS cache associated with a doma... | cilium-agent | `fqdn_active_ips` | endpoint | Disabled | Number of IPs inside the DNS cache associated with a domain that has not expi... |
| ❌ | Number of IPs associated with domains that have expired (... | cilium-agent | `fqdn_alive_zombie_connections` | endpoint | Disabled | Number of IPs associated with domains that have expired (by TTL) yet still as... |
| ❌ | Number of registered ToFQDN selectors Jobs  | cilium-agent | `fqdn_selectors` |  | Enabled | Number of registered ToFQDN selectors |
| ✅ | Job failures — renamed to hive_jobs_* in 1.19 | cilium-agent | `jobs_errors_total` | job | Enabled | Number of jobs runs that returned an error |
| ❌ | Internal job latency — niche | cilium-agent | `jobs_one_shot_run_seconds` | job | Enabled | Histogram of one shot job run duration |
| ❌ | Internal job latency — niche | cilium-agent | `jobs_timer_run_seconds` | job | Enabled | Histogram of timer job run duration |
| ❌ | Internal job latency — niche | cilium-agent | `jobs_observer_run_seconds` | job | Enabled | Histogram of observer job run duration |
| ❌ | Niche | cilium-agent | `cidrgroups_referenced` |  |  |  |
| ❌ | Niche | cilium-agent | `cidrgroup_translation_time_stats_seconds` |  |  |  |
| ❌ | Most recent adjustment factor for automatic adjustment | cilium-agent | `api_limiter_adjustment_factor` | api_call | Enabled | Most recent adjustment factor for automatic adjustment |
| ❌ | Total number of API requests processed | cilium-agent | `api_limiter_processed_requests_total` | api_call, outcome, return_code | Enabled | Total number of API requests processed |
| ❌ | Mean and estimated processing duration in seconds | cilium-agent | `api_limiter_processing_duration_seconds` | api_call, value | Enabled | Mean and estimated processing duration in seconds |
| ❌ | Current rate limiting configuration (limit and burst) | cilium-agent | `api_limiter_rate_limit` | api_call, value | Enabled | Current rate limiting configuration (limit and burst) |
| ❌ | Current and maximum allowed number of requests in flight | cilium-agent | `api_limiter_requests_in_flight` | api_call value | Enabled | Current and maximum allowed number of requests in flight |
| ❌ | Mean, min, and max wait duration | cilium-agent | `api_limiter_wait_duration_seconds` | api_call, value | Enabled | Mean, min, and max wait duration |
| ❌ | Histogram of wait duration per API call processed BGP Con... | cilium-agent | `api_limiter_wait_history_duration_seconds` | api_call | Disabled | Histogram of wait duration per API call processed |
| ❌ | Current state of the BGP session with the peer, Up = 1 or... | cilium-agent | `session_state` | vrouter, neighbor, neighbor_asn | Enabled | Current state of the BGP session with the peer, Up = 1 or Down = 0 |
| ❌ | Number of routes advertised to the peer | cilium-agent | `advertised_routes` | vrouter, neighbor, neighbor_asn, afi, safi | Enabled | Number of routes advertised to the peer |
| ❌ | Number of routes received from the peer | cilium-agent | `received_routes` | vrouter, neighbor, neighbor_asn, afi, safi | Enabled | Number of routes received from the peer |
| ❌ | Number of errors returned per BGP resource reconciliation | cilium-agent | `reconcile_errors_total` | vrouter | Enabled | Number of reconciliation runs that returned an error |
| ❌ | Histogram of reconciliation run duration All metrics are ... | cilium-agent | `reconcile_run_duration_seconds` | vrouter | Enabled | Histogram of reconciliation run duration |
| ❌ | Static config flag | cilium-operator | `gateway_api_enabled` | None |  | GatewayAPI enabled on the operator |
| ❌ | Static config flag | cilium-operator | `ingress_controller_enabled` | None |  | IngressController enabled on the operator |
| ❌ | Static config flag | cilium-operator | `l7_aware_traffic_management_enabled` | None |  | L7 Aware Traffic Management enabled on the operator |
| ❌ | Static config flag | cilium-operator | `lb_ipam_enabled` | None |  | LB IPAM enabled on the operator |
| ❌ | Static config flag | cilium-operator | `node_ipam_enabled` | None |  | Node IPAM enabled on the operator |
| ❌ | Number of errors returned per BGP resource reconciliation | cilium-operator | `reconcile_errors_total` | resource_kind, resource_name | Enabled | Number of errors returned per BGP resource reconciliation |
| ❌ | Histogram of reconciliation run duration All metrics are ... | cilium-operator | `reconcile_run_duration_seconds` |  | Enabled | Histogram of reconciliation run duration |
| ❌ | Number of IPs allocated | cilium-operator | `ipam_ips` | type | Enabled | Number of IPs allocated |
| ❌ | Number of IP allocation operations. | cilium-operator | `ipam_ip_allocation_ops` | subnet_id | Enabled | Number of IP allocation operations. |
| ❌ | Number of IP release operations. | cilium-operator | `ipam_ip_release_ops` | subnet_id | Enabled | Number of IP release operations. |
| ❌ | Number of interfaces creation operations. | cilium-operator | `ipam_interface_creation_ops` | subnet_id | Enabled | Number of interfaces creation operations. |
| ❌ | Release ip or interface latency in seconds | cilium-operator | `ipam_release_duration_seconds` | type, status, subnet_id | Enabled | Release ip or interface latency in seconds |
| ❌ | Allocation ip or interface latency in seconds | cilium-operator | `ipam_allocation_duration_seconds` | type, status, subnet_id | Enabled | Allocation ip or interface latency in seconds |
| ❌ | Number of interfaces with addresses available | cilium-operator | `ipam_available_interfaces` |  | Enabled | Number of interfaces with addresses available |
| ❌ | at-c... | cilium-operator | `ipam_nodes` | category | Enabled | Number of nodes by category { total \| in-deficit \| at-capacity } |
| ❌ | Number of synchronization operations with external IPAM API | cilium-operator | `ipam_resync_total` |  | Enabled | Number of synchronization operations with external IPAM API |
| ❌ | Duration of interactions with external IPAM API. | cilium-operator | `ipam_api_duration_seconds` | operation, response_code | Enabled | Duration of interactions with external IPAM API. |
| ❌ | Duration of rate limiting while accessing external IPAM API | cilium-operator | `ipam_api_rate_limit_duration_seconds` | operation | Enabled | Duration of rate limiting while accessing external IPAM API |
| ✅ | Eaglepoint dashboard — operator available IPs | cilium-operator | `ipam_available_ips` | target_node | Enabled | Number of available IPs on a node (taking into account plugin specific NIC/Ad... |
| ❌ | Number of currently used IPs on a node. | cilium-operator | `ipam_used_ips` | target_node | Enabled | Number of currently used IPs on a node. |
| ❌ | Number of IPs needed to satisfy allocation on a node. LB-... | cilium-operator | `ipam_needed_ips` | target_node | Enabled | Number of IPs needed to satisfy allocation on a node. |
| ❌ | Number of conflicting pools | cilium-operator | `lbipam_conflicting_pools` |  | Enabled | Number of conflicting pools |
| ❌ | Number of available IPs per pool | cilium-operator | `lbipam_ips_available` | pool | Enabled | Number of available IPs per pool |
| ❌ | Number of used IPs per pool | cilium-operator | `lbipam_ips_used` | pool | Enabled | Number of used IPs per pool |
| ❌ | Number of matching services | cilium-operator | `lbipam_services_matching` |  | Enabled | Number of matching services |
| ❌ | Number of services which did not get requested IPs Contro... | cilium-operator | `lbipam_services_unsatisfied` |  | Enabled | Number of services which did not get requested IPs |
| ❌ | Number of times that a controller process was run, labele... | cilium-operator | `controllers_group_runs_total` | status, group_name | Enabled | Number of times that a controller process was run, labeled by controller grou... |
| ❌ | Niche — CES batching detail | cilium-operator | `number_of_ceps_per_ces` |  |  | The number of CEPs batched in a CES |
| ❌ | Niche — CES batching detail | cilium-operator | `number_of_cep_changes_per_ces` | opcode |  | The number of changed CEPs in each CES update |
| ❌ | Niche — CES sync detail | cilium-operator | `ces_sync_total` | outcome |  | The number of completed CES syncs by outcome |
| ❌ | Niche — CES queueing detail | cilium-operator | `ces_queueing_delay_seconds` |  |  | CiliumEndpointSlice queueing delay in seconds |
| ❌ | The total number of pods observed to be unmanaged by Cili... | cilium-operator | `unmanaged_pods` |  | Enabled | The total number of pods observed to be unmanaged by Cilium operator |
| ❌ | The total number of CRD identities | cilium-operator | `doublewrite_crd_identities` |  | Enabled | The total number of CRD identities |
| ❌ | The total number of identities in the KVStore | cilium-operator | `doublewrite_kvstore_identities` |  | Enabled | The total number of identities in the KVStore |
| ❌ | The number of CRD identities not present in the KVStore | cilium-operator | `doublewrite_crd_only_identities` |  | Enabled | The number of CRD identities not present in the KVStore |
| ❌ | The number of identities in the KVStore not present as a ... | cilium-operator | `doublewrite_kvstore_only_identities` |  | Enabled | The number of identities in the KVStore not present as a CRD |
| ❌ | Niche — CID controller detail | cilium-operator | `cid_controller_work_queue_event_count` | resource, outcome |  | Counts processed events by CID controller work queues |
| ❌ | Niche — CID controller detail | cilium-operator | `cid_controller_work_queue_latency` | resource, phase |  | Duration of CID controller work queues enqueuing and processing latencies in ... |
| ❌ | Current depth of workqueue | cilium-operator | `workqueue_depth` | queue_name | Enabled | Current depth of workqueue |
| ❌ | Total number of adds handled by workqueue | cilium-operator | `workqueue_adds_total` | queue_name | Enabled | Total number of adds handled by workqueue |
| ❌ | Duration in seconds an item stays in workqueue prior to r... | cilium-operator | `workqueue_queue_duration_seconds` | queue_name | Enabled | Duration in seconds an item stays in workqueue prior to request |
| ❌ | Duration in seconds to process an item from workqueue | cilium-operator | `workqueue_work_duration_seconds` | queue_name | Enabled | Duration in seconds to process an item from workqueue |
| ❌ | Duration in seconds of work in progress that hasn’t been ... | cilium-operator | `workqueue_unfinished_work_seconds` | queue_name | Enabled | Duration in seconds of work in progress that hasn’t been observed by work_dur... |
| ❌ | Duration in seconds of the longest running processor for ... | cilium-operator | `workqueue_longest_running_processor_seconds` | queue_name | Enabled | Duration in seconds of the longest running processor for workqueue |
| ❌ | Total number of retries handled by workqueue MCS-API  | cilium-operator | `workqueue_retries_total` | queue_name | Enabled | Total number of retries handled by workqueue |
| ✅ | Hubble data loss detection | hubble | `lost_events_total` | source | Enabled | Number of lost events |
| ❌ | Number of DNS queries observed | hubble | `dns_queries_total` | rcode, qtypes, ips_returned | Disabled | Number of DNS queries observed |
| ❌ | Number of DNS responses observed | hubble | `dns_responses_total` | rcode, qtypes, ips_returned | Disabled | Number of DNS responses observed |
| ❌ | Number of DNS response types Options  Option Key Option ... | hubble | `dns_response_types_total` | type, qtypes | Disabled | Number of DNS response types |
| ❌ | Number of drops Options  This metric supports Context Op... | hubble | `drop_total` | reason, protocol | Disabled | Number of drops |
| ❌ | Total number of flows processed Options  This metric sup... | hubble | `flows_processed_total` | type, subtype, verdict | Disabled | Total number of flows processed |
| ❌ | Total number of flows to reserved:world . Options  Optio... | hubble | `flows_to_world_total` | protocol, verdict | Disabled | Total number of flows to reserved:world. |
| ✅ | L7 request rate (eBPF, no app instrumentation) | hubble | `http_requests_total` | method, protocol, reporter | Disabled | Count of HTTP requests |
| ❌ | Count of HTTP responses | hubble | `http_responses_total` | method, status, reporter | Disabled | Count of HTTP responses |
| ✅ | L7 latency (eBPF, no app instrumentation) | hubble | `http_request_duration_seconds` | method, reporter | Disabled | Histogram of HTTP request duration in seconds |
| ❌ | Number of ICMP messages Options  This metric supports Co... | hubble | `icmp_total` | family, type | Disabled | Number of ICMP messages |
| ❌ | Count of Kafka requests by topic | hubble | `kafka_requests_total` | topic, api_key, error_code, reporter | Disabled | Count of Kafka requests by topic |
| ❌ | Histogram of Kafka request duration by topic Options  Th... | hubble | `kafka_request_duration_seconds` | topic, api_key, reporter | Disabled | Histogram of Kafka request duration by topic |
| ❌ | Numbers of packets distributed by destination port Option... | hubble | `port_distribution_total` | protocol, port | Disabled | Numbers of packets distributed by destination port |
| ❌ | TCP flag occurrences Options  This metric supports Conte... | hubble | `tcp_flags_total` | flag, family | Disabled | TCP flag occurrences |
| ❌ | Number of configured hubble exporters | hubble | `dynamic_exporter_exporters_total` | source | Enabled | Number of configured hubble exporters |
| ❌ | Status of exporter (1 - active, 0 - inactive) | hubble | `dynamic_exporter_up` | source | Enabled | Status of exporter (1 - active, 0 - inactive) |
| ❌ | Number of dynamic exporters reconfigurations | hubble | `dynamic_exporter_reconfigurations_total` | op | Enabled | Number of dynamic exporters reconfigurations |
| ❌ | Hash of last applied config | hubble | `dynamic_exporter_config_hash` |  | Enabled | Hash of last applied config |
| ❌ | Timestamp of last applied config | hubble | `dynamic_exporter_config_last_applied` |  | Enabled | Timestamp of last applied config |
| ❌ | Niche — one-time startup metric | clustermesh-apiserver | `bootstrap_seconds` | source_cluster |  | Duration in seconds to complete bootstrap |
| ❌ | Duration of kvstore operation | clustermesh-apiserver | `kvstore_operations_duration_seconds` | action, kind, outcome, scope |  | Duration of kvstore operation |
| ✅ | Eaglepoint dashboard — kvstore queue | clustermesh-apiserver | `kvstore_events_queue_seconds` | action, scope |  | Seconds waited before a received event was queued |
| ✅ | > 0 = etcd quorum issues | clustermesh-apiserver | `kvstore_quorum_errors_total` | error |  | Number of quorum errors |
| ✅ | > 0 = state inconsistency | clustermesh-apiserver | `kvstore_sync_errors_total` | scope, source_cluster |  | Number of times synchronization to the kvstore failed |
| ❌ | Number of elements queued for synchronization in the kvstore | clustermesh-apiserver | `kvstore_sync_queue_size` | scope, source_cluster |  | Number of elements queued for synchronization in the kvstore |
| ❌ | Whether the initial synchronization from/to the kvstore h... | clustermesh-apiserver | `kvstore_initial_sync_completed` | scope, source_cluster, action |  | Whether the initial synchronization from/to the kvstore has completed |
| ❌ | Total number of API requests processed | clustermesh-apiserver | `api_limiter_processed_requests_total` | api_call, outcome, return_code |  | Total number of API requests processed |
| ❌ | Mean and estimated processing duration in seconds | clustermesh-apiserver | `api_limiter_processing_duration_seconds` | api_call, value |  | Mean and estimated processing duration in seconds |
| ❌ | Current rate limiting configuration (limit and burst) | clustermesh-apiserver | `api_limiter_rate_limit` | api_call, value |  | Current rate limiting configuration (limit and burst) |
| ❌ | Current and maximum allowed number of requests in flight | clustermesh-apiserver | `api_limiter_requests_in_flight` | api_call value |  | Current and maximum allowed number of requests in flight |
| ❌ | Mean, min, and max wait duration | clustermesh-apiserver | `api_limiter_wait_duration_seconds` | api_call, value |  | Mean, min, and max wait duration |
| ❌ | Number of times that a controller process was run, labele... | clustermesh-apiserver | `controllers_group_runs_total` | status, group_name | Enabled | Number of times that a controller process was run, labeled by controller grou... |
| ❌ | Niche — one-time startup metric | kvstoremesh | `bootstrap_seconds` | source_cluster |  | Duration in seconds to complete bootstrap |
| ❌ | Niche — static cluster mesh topology | kvstoremesh | `remote_clusters` | source_cluster |  | The total number of remote clusters meshed with the local cluster |
| ❌ | Niche — cluster mesh detail | kvstoremesh | `remote_cluster_failures` | source_cluster, target_cluster |  | The total number of failures related to the remote cluster |
| ❌ | Niche — cluster mesh detail | kvstoremesh | `remote_cluster_last_failure_ts` | source_cluster, target_cluster |  | The timestamp of the last failure of the remote cluster |
| ❌ | Niche — cluster mesh detail | kvstoremesh | `remote_cluster_readiness_status` | source_cluster, target_cluster |  | The readiness status of the remote cluster |
| ❌ | Duration of kvstore operation | kvstoremesh | `kvstore_operations_duration_seconds` | action, kind, outcome, scope |  | Duration of kvstore operation |
| ✅ | Eaglepoint dashboard — kvstore queue | kvstoremesh | `kvstore_events_queue_seconds` | action, scope |  | Seconds waited before a received event was queued |
| ✅ | > 0 = etcd quorum issues | kvstoremesh | `kvstore_quorum_errors_total` | error |  | Number of quorum errors |
| ✅ | > 0 = state inconsistency | kvstoremesh | `kvstore_sync_errors_total` | scope, source_cluster |  | Number of times synchronization to the kvstore failed |
| ❌ | Number of elements queued for synchronization in the kvstore | kvstoremesh | `kvstore_sync_queue_size` | scope, source_cluster |  | Number of elements queued for synchronization in the kvstore |
| ❌ | Whether the initial synchronization from/to the kvstore h... | kvstoremesh | `kvstore_initial_sync_completed` | scope, source_cluster, action |  | Whether the initial synchronization from/to the kvstore has completed |
| ❌ | Total number of API requests processed | kvstoremesh | `api_limiter_processed_requests_total` | api_call, outcome, return_code |  | Total number of API requests processed |
| ❌ | Mean and estimated processing duration in seconds | kvstoremesh | `api_limiter_processing_duration_seconds` | api_call, value |  | Mean and estimated processing duration in seconds |
| ❌ | Current rate limiting configuration (limit and burst) | kvstoremesh | `api_limiter_rate_limit` | api_call, value |  | Current rate limiting configuration (limit and burst) |
| ❌ | Current and maximum allowed number of requests in flight | kvstoremesh | `api_limiter_requests_in_flight` | api_call value |  | Current and maximum allowed number of requests in flight |
| ❌ | Mean, min, and max wait duration | kvstoremesh | `api_limiter_wait_duration_seconds` | api_call, value |  | Mean, min, and max wait duration |
| ❌ | Number of times that a controller process was run, labele... | kvstoremesh | `controllers_group_runs_total` | status, group_name | Enabled | Number of times that a controller process was run, labeled by controller grou... |
| ❌ | Saturation of the most saturated distinct NAT mapped conn... | kvstoremesh | `nat_endpoint_max_connection` | family | Enabled | Saturation of the most saturated distinct NAT mapped connection, in terms of ... |
