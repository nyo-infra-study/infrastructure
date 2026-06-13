# redis-labs — Metric Filter Decisions

> Version: 7.8
> Docs: https://redis.io/docs/latest/operate/rs/monitoring/metrics_stream_engine/prometheus-metrics-v2/
> Generated from: `output/*/parsed/redis-labs.csv`

---

| Use | Reason | component | metric_name | metric_type | description |
| --- | --- | --- | --- | --- | --- |
| ✅ | Connection rate monitoring | database | `endpoint_accepted_connections` | Counter | Number of incoming accepted client connections |
| ✅ | Track connection churn | database | `endpoint_client_connections` | Counter | Number of client connection establishment events |
| ❌ | Niche — connections metric is sufficient | database | `endpoint_client_disconnections` | Counter | Number of client disconnections initiated by the client |
| ❌ | Niche — only relevant if TTL is configured | database | `endpoint_client_connection_expired` | Counter | Total number of client connections with expired TTL (Time To Live) |
| ❌ | Low volume — alert on connection count drop instead | database | `endpoint_client_establishment_failures` | Counter | Number of client connections that failed to establish properly |
| ❌ | Niche | database | `endpoint_client_expiration_refresh` | Counter | Number of expiration time changes of clients |
| ❌ | Not using client-side caching | database | `endpoint_client_tracking_off_requests` | Counter | Total number of |
| ❌ | Not using client-side caching | database | `endpoint_client_tracking_on_requests` | Counter | Total number of |
| ❌ | Redundant — can rate() accepted_connections | database | `endpoint_connections_rate` | Gauge | The rate of incoming connections. Computed as |
| ❌ | Auth detail — not needed | database | `endpoint_disconnected_cba_client` | Counter | Number of certificate-based clients disconnected |
| ❌ | Not using LDAP auth | database | `endpoint_disconnected_ldap_client` | Counter | Number of LDAP clients disconnected |
| ❌ | Auth detail — not needed | database | `endpoint_disconnected_user_password_client` | Counter | Number of user&amp;password clients disconnected |
| ❌ | Niche — rare failure mode | database | `endpoint_dispatch_failures` | Counter | Number of clients closed due to failure to be dispatched to workers |
| ❌ | Not using client-side caching | database | `endpoint_disposed_commands_after_client_caching` | Counter | Total number of client caching commands that were disposed due to misuse |
| ✅ | Core — network throughput monitoring | database | `endpoint_egress` | Counter | Number of egress bytes |
| ❌ | Niche — internal proxy detail | database | `endpoint_egress_pending` | Counter | Number of send-pending bytes |
| ❌ | Niche | database | `endpoint_egress_pending_discarded` | Counter | Number of send-pending bytes that were discarded due to disconnection |
| ❌ | Auth detail | database | `endpoint_failed_cba_authentication` | Counter | Number of clients that failed certificate-based authentication |
| ❌ | Not using LDAP | database | `endpoint_failed_ldap_authentication` | Counter | Number of clients that failed LDAP authentication |
| ❌ | Auth detail | database | `endpoint_failed_user_password_authentication` | Counter | Number of clients that failed user password authentication |
| ✅ | Core — network throughput monitoring | database | `endpoint_ingress` | Counter | Number of ingress bytes |
| ❌ | Niche — pipeline optimization detail | database | `endpoint_longest_pipeline_histogram` | Counter | Tracks the distribution of longest observed pipeline lengths, where a pipelin... |
| ❌ | Niche | database | `endpoint_other_requests` | Counter | Number of other requests |
| ❌ | Niche | database | `endpoint_other_requests_latency_histogram` | Histogram | Latency (in Âµs) histogram of other commands |
| ❌ | Niche | database | `endpoint_other_requests_latency_histogram_bucket` | Histogram | Latency histograms for commands other than read or write commands. Can be use... |
| ❌ | Niche | database | `endpoint_other_responses` | Counter | Number of other responses |
| ✅ | Core — health check, alert on > 0 | database | `endpoint_ping_failures` | Gauge | Number of consecutive endpoint ping failures. Labels: endpoint_uid |
| ✅ | Core — how long the endpoint has been unhealthy | database | `endpoint_ping_failure_duration_seconds` | Gauge | Duration of ongoing endpoint failures (0 when healthy). Labels: endpoint_uid |
| ❌ | Niche | database | `endpoint_proxy_disconnections` | Counter | Number of client disconnections initiated by the proxy |
| ❌ | Niche — unless rate limiting is configured | database | `endpoint_rate_limit_ok` | Gauge | Rate limit status based on the last 2 intervals. |
| ❌ | Niche — unless rate limiting is configured | database | `endpoint_rate_limit_overflows` | Counter | Total number of rate limit overflows |
| ✅ | Core — read throughput | database | `endpoint_read_requests` | Counter | Number of read requests |
| ✅ | Core — read latency percentiles | database | `endpoint_read_requests_latency_histogram` | Histogram | Latency (in Âµs) histogram of read commands |
| ❌ | Redundant — histogram already covers this | database | `endpoint_read_requests_latency_histogram_bucket` | Histogram | Latency histograms for read commands. Can be used to represent different late... |
| ❌ | Redundant — read_requests is sufficient | database | `endpoint_read_responses` | Counter | Number of read responses |
| ❌ | Auth detail — not needed | database | `endpoint_successful_cba_authentication` | Counter | Number of clients that successfully authenticated with certificate-based auth... |
| ❌ | Auth detail — not needed | database | `endpoint_successful_ldap_authentication` | Counter | Number of clients that successfully authenticated with LDAP |
| ❌ | Auth detail — not needed | database | `endpoint_successful_user_password_authentication` | Counter | Number of clients that successfully authenticated with user&amp;password |
| ✅ | Core — write throughput | database | `endpoint_write_requests` | Counter | Number of write requests |
| ✅ | Core — write latency percentiles | database | `endpoint_write_requests_latency_histogram` | Histogram | Latency (in Âµs) histogram of write commands |
| ❌ | Redundant — histogram already covers this | database | `endpoint_write_requests_latency_histogram_bucket` | Histogram | Latency histograms for write commands. Can be used to represent different lat... |
| ❌ | Redundant — write_requests is sufficient | database | `endpoint_write_responses` | Counter | Number of write responses |
| ✅ | Inventory — track config changes | database | `db_config` | Counter | This is an information metric that holds database configuration within labels... |
| ✅ | Core — alert on non-zero (non-active) status | database | `db_status` | Gauge | This is a status metric that reports on various database statuses: 0 = active... |
| ❌ | Not using flash storage | node | `node_available_flash_bytes` | Gauge | Available flash in the node (bytes) |
| ❌ | Not using flash | node | `node_available_flash_no_overbooking_bytes` | Gauge | Available flash in the node (bytes), without taking into account overbooking |
| ✅ | Core — memory pressure detection | node | `node_available_memory_bytes` | Gauge | Amount of free memory in the node (bytes) |
| ❌ | Niche — overbooking detail | node | `node_available_memory_no_overbooking_bytes` | Gauge | Available RAM in the node (bytes) without taking into account overbooking |
| ❌ | Not using BigRedis | node | `node_bigstore_free_bytes` | Gauge | Sum of free space of back-end flash (used by flash database's [BigRedis]) on ... |
| ✅ | Core — alert before cert expiry | node | `node_cert_expires_in_seconds` | Gauge | Certificate expiration (in seconds) per given node; read more about |
| ❌ | Static info — check once | node | `customer_managed_ine_certificates` | Gauge | Indicates whether customer-provided internode encryption certificates are in use |
| ❌ | Managed service — Redis Labs handles disk | node | `node_ephemeral_storage_avail_bytes` | Gauge | Disk space available to RLEC processes on configured ephemeral disk (bytes) |
| ❌ | Managed service | node | `node_ephemeral_storage_free_bytes` | Gauge | Free disk space on configured ephemeral disk (bytes) |
| ❌ | Managed service | node | `node_persistent_storage_avail_bytes` | Gauge | Disk space available to RLEC processes on configured persistent disk (bytes) |
| ❌ | Managed service | node | `node_persistent_storage_free_bytes` | Gauge | Free disk space on configured persistent disk (bytes) |
| ❌ | Managed service — Redis Labs handles provisioning | node | `node_provisional_flash_bytes` | Gauge | Amount of flash available for new shards on this node, taking into account ov... |
| ❌ | Managed service — Redis Labs handles provisioning | node | `node_provisional_flash_no_overbooking_bytes` | Gauge | Amount of flash available for new shards on this node, without taking into ac... |
| ❌ | Managed service — Redis Labs handles provisioning | node | `node_provisional_memory_bytes` | Gauge | Amount of RAM that is available for provisioning to databases out of the tota... |
| ❌ | Managed service — Redis Labs handles provisioning | node | `node_provisional_memory_no_overbooking_bytes` | Gauge | Amount of RAM that is available for provisioning to databases out of the tota... |
| ✅ | Core — node health | node | `node_metrics_up` | Gauge | Node is part of the cluster and is connected |
| ❌ | Internal Redis cluster detail | node | `dmc_ping_failures` | Gauge | Number of consecutive DMC ping failures |
| ❌ | Internal Redis cluster detail | node | `dmc_ping_failure_duration_seconds` | Gauge | Duration of ongoing DMC failures (0 when healthy) |
| ✅ | Core — alert before license expiry | cluster | `license_expiration_days` | Gauge | Number of days until the license expires |
| ❌ | Static — check once | cluster | `license_shards_limit` | Gauge | Total shard limit by the license by shard type (ram / flash) |
| ❌ | Static — rarely changes | cluster | `users_count` | Gauge | Current number of users on the cluster |
| ❌ | Not using Active-Active replication | replication | `database_syncer_config` | Gauge | Used as a placeholder for configuration labels |
| ❌ | Not using Active-Active replication | replication | `database_syncer_current_status` | Gauge | Syncer status for traffic; 0 = in-sync, 2 = out of sync |
| ❌ | Not using Active-Active replication | replication | `database_syncer_dst_connectivity_state` | Gauge | Destination connectivity state |
| ❌ | Not using Active-Active replication | replication | `database_syncer_dst_connectivity_state_ms` | Gauge | Destination connectivity state duration |
| ❌ | Not using Active-Active replication | replication | `database_syncer_dst_lag` | Gauge | Lag in milliseconds between the syncer and the destination |
| ❌ | Not using Active-Active replication | replication | `database_syncer_dst_repl_offset` | Gauge | Offset of the last command acknowledged |
| ❌ | Not using Active-Active replication | replication | `database_syncer_flush_counter` | Gauge | Number of destination flushes |
| ❌ | Not using Active-Active replication | replication | `database_syncer_ingress_bytes` | Gauge | Number of bytes read from source shard |
| ❌ | Not using Active-Active replication | replication | `database_syncer_ingress_bytes_decompressed` | Gauge | Number of bytes read from source shard |
| ❌ | Not using Active-Active replication | replication | `database_syncer_internal_state` | Gauge | Internal state of the syncer |
| ❌ | Not using Active-Active replication | replication | `database_syncer_lag_ms` | Gauge | Lag time between the source and the destination for traffic in milliseconds |
| ❌ | Not using Active-Active replication | replication | `database_syncer_rdb_size` | Gauge | The source's RDB size in bytes to be transferred during the syncing phase |
| ❌ | Not using Active-Active replication | replication | `database_syncer_rdb_transferred` | Gauge | Number of bytes transferred from the source's RDB during the syncing phase |
| ❌ | Not using Active-Active replication | replication | `database_syncer_src_connectivity_state` | Gauge | Source connectivity state |
| ❌ | Not using Active-Active replication | replication | `database_syncer_src_connectivity_state_ms` | Gauge | Source connectivity state duration |
| ❌ | Not using Active-Active replication | replication | `database_syncer_src_repl_offset` | Gauge | Last known source offset |
| ❌ | Not using Active-Active replication | replication | `database_syncer_state` | Gauge | Internal state of the shard syncer |
| ❌ | Not using Active-Active replication | replication | `database_syncer_syncer_repl_offset` | Gauge | Offset of the last command handled by the syncer |
| ❌ | Not using Active-Active replication | replication | `database_syncer_total_requests` | Gauge | Number of destination writes |
| ❌ | Not using Active-Active replication | replication | `database_syncer_total_responses` | Gauge | Number of destination writes acknowledged |
| ❌ | Niche — internal optimization detail | shard | `redis_server_active_defrag_running` | Unknown | Automatic memory defragmentation current aggressiveness (% cpu) |
| ❌ | Niche — used_memory is sufficient | shard | `redis_server_allocator_active` | Unknown | Total used memory, including external fragmentation |
| ❌ | Niche — used_memory is sufficient | shard | `redis_server_allocator_allocated` | Unknown | Total allocated memory |
| ❌ | Niche — used_memory is sufficient | shard | `redis_server_allocator_resident` | Unknown | Total resident memory (RSS) |
| ❌ | Managed service handles persistence | shard | `redis_server_aof_last_cow_size` | Unknown | Last AOFR, CopyOnWrite memory |
| ❌ | Managed service handles persistence | shard | `redis_server_aof_rewrite_in_progress` | Unknown | The number of simultaneous AOF rewrites that are in progress |
| ❌ | Managed service handles persistence | shard | `redis_server_aof_rewrites` | Unknown | Number of AOF rewrites this process executed |
| ❌ | Managed service handles persistence | shard | `redis_server_aof_delayed_fsync` | Unknown | Number of times an AOF fsync caused delays in the main Redis thread (inducing... |
| ✅ | Core — detect blocking command issues | shard | `redis_server_blocked_clients` | Unknown | Count the clients waiting on a blocking call |
| ✅ | Core — connection count monitoring | shard | `redis_server_connected_clients` | Unknown | Number of client connections to the specific shard |
| ✅ | Replication health | shard | `redis_server_connected_slaves` | Unknown | Number of connected replicas |
| ❌ | Niche | shard | `redis_server_db_avg_ttl` | Unknown | Average TTL of all volatile keys |
| ✅ | Inventory — track data growth | shard | `redis_server_db_keys` | Unknown | Total key count. |
| ✅ | Core — evictions mean memory pressure | shard | `redis_server_evicted_keys` | Unknown | Keys evicted so far (since restart) |
| ❌ | Niche | shard | `redis_server_expire_cycle_cpu_milliseconds` | Unknown | The cumulative amount of time spent on active expiry cycles |
| ❌ | Niche — evicted_keys is more actionable | shard | `redis_server_expired_keys` | Unknown | Keys expired so far since restart |
| ❌ | Internal cluster detail | shard | `redis_server_forwarding_state` | Unknown | Shard forwarding state (on or off) |
| ❌ | Niche — resharding detail | shard | `redis_server_keys_trimmed` | Unknown | The number of keys that were trimmed in the current or last resharding process |
| ✅ | Core — cache hit rate | shard | `redis_server_keyspace_read_hits` | Unknown | Number of read operations accessing an existing keyspace |
| ✅ | Core — cache miss rate | shard | `redis_server_keyspace_read_misses` | Unknown | Number of read operations accessing a non-existing keyspace |
| ❌ | Niche — read hit/miss is more useful for cache behavior | shard | `redis_server_keyspace_write_hits` | Unknown | Number of write operations accessing an existing keyspace |
| ❌ | Niche — read hit/miss is more useful for cache behavior | shard | `redis_server_keyspace_write_misses` | Unknown | Number of write operations accessing a non-existing keyspace |
| ❌ | Managed service handles replication | shard | `redis_server_master_link_status` | Unknown | Indicates if the replica is connected to its master |
| ❌ | Managed service handles replication | shard | `redis_server_master_repl_offset` | Unknown | Number of bytes sent to replicas by the shard; calculate the throughput for a... |
| ❌ | Managed service handles replication | shard | `redis_server_master_sync_in_progress` | Unknown | The primary shard is synchronizing (1 true; 0 false) |
| ❌ | Redundant — maxmemory is the useful limit | shard | `redis_server_max_process_mem` | Unknown | Current memory limit configured by redis_mgr according to node free memory |
| ✅ | Core — calculate memory utilization % | shard | `redis_server_maxmemory` | Unknown | Current memory limit configured by redis_mgr according to database memory lim... |
| ❌ | Niche — used_memory + fragmentation_ratio is sufficient | shard | `redis_server_mem_aof_buffer` | Unknown | Current size of AOF buffer |
| ❌ | Niche — used_memory + fragmentation_ratio is sufficient | shard | `redis_server_mem_clients_normal` | Unknown | Current memory used for input and output buffers of non-replica clients |
| ❌ | Niche — used_memory + fragmentation_ratio is sufficient | shard | `redis_server_mem_clients_slaves` | Unknown | Current memory used for input and output buffers of replica clients |
| ✅ | Core — high fragmentation wastes memory | shard | `redis_server_mem_fragmentation_ratio` | Unknown | Memory fragmentation ratio (1.3 means 30% overhead) |
| ❌ | Niche — used_memory + fragmentation_ratio is sufficient | shard | `redis_server_mem_not_counted_for_evict` | Unknown | Portion of used_memory (in bytes) that's not counted for eviction and OOM error |
| ❌ | Niche — used_memory + fragmentation_ratio is sufficient | shard | `redis_server_mem_replication_backlog` | Unknown | Size of replication backlog |
| ❌ | Niche | shard | `redis_server_module_fork_in_progress` | Unknown | A binary value that indicates if there is an active fork spawned by a module ... |
| ❌ | Managed service — Redis Labs monitors processes | shard | `namedprocess_namegroup_cpu_seconds_total` | Unknown | Shard process CPU usage in seconds |
| ❌ | Managed service — Redis Labs monitors processes | shard | `namedprocess_namegroup_thread_cpu_seconds_total` | Unknown | Shard main thread CPU time spent in seconds |
| ❌ | Managed service — Redis Labs monitors processes | shard | `namedprocess_namegroup_open_filedesc` | Unknown | Shard number of open file descriptors |
| ❌ | Managed service — Redis Labs monitors processes | shard | `namedprocess_namegroup_memory_bytes` | Unknown | Shard memory size in bytes |
| ❌ | Managed service — Redis Labs monitors processes | shard | `namedprocess_namegroup_oldest_start_time_seconds` | Unknown | Shard start time of the process since unix epoch in seconds |
| ❌ | Managed service handles persistence | shard | `redis_server_rdb_bgsave_in_progress` | Unknown | Indication if bgsave is currently in progress |
| ❌ | Managed service handles persistence | shard | `redis_server_rdb_last_cow_size` | Unknown | Last bgsave (or SYNC fork) used CopyOnWrite memory |
| ❌ | Managed service handles persistence | shard | `redis_server_rdb_saves` | Unknown | Total count of bgsaves since the process was restarted (including replica ful... |
| ❌ | Niche | shard | `redis_server_repl_touch_bytes` | Unknown | Number of bytes sent to replicas as TOUCH commands by the shard as a result o... |
| ✅ | Core — throughput monitoring | shard | `redis_server_total_commands_processed` | Unknown | Number of commands processed by the shard; calculate the number of commands f... |
| ✅ | Connection rate | shard | `redis_server_total_connections_received` | Unknown | Number of connections received by the shard; calculate the number of connecti... |
| ✅ | Network throughput | shard | `redis_server_total_net_input_bytes` | Unknown | Number of bytes received by the shard; calculate the throughput for a time pe... |
| ✅ | Network throughput | shard | `redis_server_total_net_output_bytes` | Unknown | Number of bytes sent by the shard; calculate the throughput for a time period... |
| ✅ | Core — shard health | shard | `redis_server_up` | Unknown | Shard is up and running |
| ✅ | Core — memory usage monitoring | shard | `redis_server_used_memory` | Unknown | Memory used by shard (in BigRedis this includes flash) (bytes) |
| ❌ | Not using RediSearch | shard | `redis_server_search_gc_bytes_collected` | Unknown | The total amount of memory freed by the garbage collectors from indexes in th... |
| ❌ | Not using RediSearch | shard | `redis_server_search_bytes_collected` | Unknown | The total amount of memory freed by the garbage collectors from indexes in th... |
| ❌ | Not using RediSearch | shard | `redis_server_search_gc_marked_deleted_vectors` | Unknown | The number of vectors marked as deleted in the vector indexes that have not y... |
| ❌ | Not using RediSearch | shard | `redis_server_search_marked_deleted_vectors` | Unknown | The number of vectors marked as deleted in the vector indexes that have not y... |
| ❌ | Not using RediSearch | shard | `redis_server_search_gc_total_cycles` | Unknown | The total number of garbage collection cycles executed. |
| ❌ | Not using RediSearch | shard | `redis_server_search_total_cycles` | Unknown | The total number of garbage collection cycles executed. Deprecated in 8.0 (re... |
| ❌ | Not using RediSearch | shard | `redis_server_search_gc_total_docs_not_collected_by_gc` | Unknown | The number of documents marked as deleted, whose memory has not yet been free... |
| ❌ | Not using RediSearch | shard | `redis_server_search_total_docs_not_collected_by_gc` | Unknown | The number of documents marked as deleted, whose memory has not yet been free... |
| ❌ | Not using RediSearch | shard | `redis_server_search_gc_total_ms_run` | Unknown | The total duration of all garbage collection cycles in the shard, measured in... |
| ❌ | Not using RediSearch | shard | `redis_server_search_total_ms_run` | Unknown | The total duration of all garbage collection cycles in the shard, measured in... |
| ❌ | Not using RediSearch | shard | `redis_server_search_cursors_internal_idle` | Unknown | The total number of coordinator cursors that are currently holding pending re... |
| ❌ | Not using RediSearch | shard | `redis_server_search_cursors_user_idle` | Unknown | The total number of cursors that were explicitly requested by users, that are... |
| ❌ | Not using RediSearch | shard | `redis_server_search_global_idle` | Unknown | The total number of user and internal cursors currently holding pending resul... |
| ❌ | Not using RediSearch | shard | `redis_server_search_cursors_internal_active` | Unknown | The total number of coordinator cursors in the shard, either holding pending ... |
| ❌ | Not using RediSearch | shard | `redis_server_search_cursors_user_active` | Unknown | The total number of user cursors in the shard, either holding pending results... |
| ❌ | Not using RediSearch | shard | `redis_server_search_global_total` | Unknown | The total number of user and internal cursors in the shard, either holding pe... |
| ❌ | Not using RediSearch | shard | `redis_server_search_number_of_indexes` | Unknown | Total number of indexes in the shard |
| ❌ | Not using RediSearch | shard | `redis_server_search_number_of_active_indexes` | Unknown | The total number of indexes running a background indexing and/or background q... |
| ✅ | Core — index size tracking | shard | `redis_server_search_total_num_docs_in_indexes` | Unknown | The total number of documents currently indexed across all indexes in the shard. |
| ❌ | Not using RediSearch | shard | `redis_server_search_number_of_active_indexes_running_queries` | Unknown | Total count of indexes currently running a background query process. |
| ❌ | Not using RediSearch | shard | `redis_server_search_number_of_active_indexes_indexing` | Unknown | Total count of indexes currently undergoing a background indexing process. Ba... |
| ❌ | Not using RediSearch | shard | `redis_server_search_total_active_write_threads` | Unknown | Total count of background write (indexing) processes currently running in the... |
| ❌ | Niche — per-field-type indexing ops, high cardinality | shard | `redis_server_search_total_indexing_ops_text_fields` | Unknown | The total number of indexing operations performed on |
| ❌ | Niche — per-field-type indexing ops, high cardinality | shard | `redis_server_search_total_indexing_ops_tag_fields` | Unknown | The total number of indexing operations performed on |
| ❌ | Niche — per-field-type indexing ops, high cardinality | shard | `redis_server_search_total_indexing_ops_numeric_fields` | Unknown | The total number of indexing operations performed on |
| ❌ | Niche — per-field-type indexing ops, high cardinality | shard | `redis_server_search_total_indexing_ops_geo_fields` | Unknown | The total number of indexing operations performed on |
| ❌ | Niche — per-field-type indexing ops, high cardinality | shard | `redis_server_search_total_indexing_ops_geoshape_fields` | Unknown | The total number of indexing operations performed on |
| ❌ | Niche — per-field-type indexing ops, high cardinality | shard | `redis_server_search_total_indexing_ops_vector_fields` | Unknown | The total number of indexing operations performed on |
| ❌ | Not using RediSearch | shard | `redis_server_search_used_memory_indexes` | Unknown | The total memory allocated by all indexes in the shard in bytes. |
| ❌ | Not using RediSearch | shard | `redis_server_search_smallest_memory_index` | Unknown | The memory usage of the index with the smallest memory usage in the shard in ... |
| ❌ | Not using RediSearch | shard | `redis_server_search_largest_memory_index` | Unknown | The memory usage of the index with the largest memory usage in the shard in b... |
| ❌ | Not using RediSearch | shard | `redis_server_search_total_indexing_time` | Unknown | The total time spent on indexing operations, excluding the background indexin... |
| ❌ | Not using RediSearch | shard | `redis_server_search_used_memory_vector_index` | Unknown | The total memory usage of all vector indexes in the shard. |
| ❌ | Not using RediSearch | shard | `redis_server_search_total_queries_processed` | Unknown | The total number of successful query executions (When using cursors, not coun... |
| ❌ | Not using RediSearch | shard | `redis_server_search_total_query_commands` | Unknown | The total number of successful query command executions (including |
| ❌ | Not using RediSearch | shard | `redis_server_search_total_query_execution_time_ms` | Unknown | The cumulative execution time of all query commands, including |
| ❌ | Not using RediSearch | shard | `redis_server_search_total_active_queries` | Unknown | The total number of background queries currently being executed in the shard,... |
| ❌ | Not using RediSearch | shard | `redis_server_search_errors_indexing_failures` | Unknown | The total number of indexing failures recorded across all indexes in the shard. |
| ❌ | Not using RediSearch | shard | `redis_server_search_errors_for_index_with_max_failures` | Unknown | The number of indexing failures in the index with the highest count of failures. |
| ✅ | Core — query errors, alert on spikes | shard | `redis_server_search_shard_total_query_errors_syntax` | Unknown | The total number of query syntax errors occurred in the shard. |
| ✅ | Core — query errors, alert on spikes | shard | `redis_server_search_shard_total_query_errors_arguments` | Unknown | The total number of queries in the shard that failed due to missing or invali... |
| ✅ | Core — query errors, alert on spikes | shard | `redis_server_search_shard_total_query_errors_timeout` | Unknown | The total number of query timeout errors occurred in the shard (when timeout ... |
| ❌ | Niche — warnings are non-critical | shard | `redis_server_search_shard_total_query_warnings_timeout` | Unknown | The total number of query timeout warnings occurred in the shard (when timeou... |
| ✅ | Core — query errors, alert on spikes | shard | `redis_server_search_shard_total_query_errors_oom` | Unknown | The total number of query out-of-memory errors occurred in the shard. |
| ❌ | Niche — warnings are non-critical | shard | `redis_server_search_shard_total_query_warnings_oom` | Unknown | The total number of query out-of-memory warnings occurred in the shard. |
| ❌ | Niche — warnings are non-critical | shard | `redis_server_search_shard_total_query_warnings_max_prefix_expansions` | Unknown | The total number of max prefix expansion warnings occurred in the shard. |
| ✅ | Core — query errors, alert on spikes | shard | `redis_server_search_coord_total_query_errors_syntax` | Unknown | The total number of query syntax errors occurred at the coordinator. |
| ✅ | Core — query errors, alert on spikes | shard | `redis_server_search_coord_total_query_errors_arguments` | Unknown | The total number of query argument errors encountered by the shard's coordina... |
| ✅ | Core — query errors, alert on spikes | shard | `redis_server_search_coord_total_query_errors_timeout` | Unknown | The total number of query timeout errors encountered by the shard's coordinat... |
| ❌ | Niche — warnings are non-critical | shard | `redis_server_search_coord_total_query_warnings_timeout` | Unknown | The total number of query timeout warnings encountered by the shard's coordin... |
| ✅ | Core — query errors, alert on spikes | shard | `redis_server_search_coord_total_query_errors_oom` | Unknown | The total number of query out-of-memory errors encountered by the shard's coo... |
| ❌ | Niche — warnings are non-critical | shard | `redis_server_search_coord_total_query_warnings_oom` | Unknown | The total number of query out-of-memory warnings encountered by the shard's c... |
| ❌ | Niche — warnings are non-critical | shard | `redis_server_search_coord_total_query_warnings_max_prefix_expansions` | Unknown | The total number of max prefix expansion warnings encountered by the shard's ... |
| ❌ | Niche — UV thread internals | shard | `redis_server_search_uv_threads_running_queries` | Unknown | The number of I/O threads currently handling query distribution to shards in ... |
| ❌ | Niche — UV thread internals | shard | `redis_server_search_uv_threads_running_topology_update` | Unknown | The number of UV threads currently running topology updates. |
| ✅ | Core — thread pool saturation | shard | `redis_server_search_active_worker_threads` | Unknown | The number of active worker threads. |
| ✅ | Core — thread pool saturation | shard | `redis_server_search_active_coord_threads` | Unknown | The number of active coordinator threads. |
| ✅ | Core — queue depth, detect backpressure | shard | `redis_server_search_workers_low_priority_pending_jobs` | Unknown | The number of pending low-priority jobs in worker threads, such as vector bac... |
| ✅ | Core — queue depth, detect backpressure | shard | `redis_server_search_workers_high_priority_pending_jobs` | Unknown | The number of pending high-priority jobs in worker threads, such as query exe... |
| ✅ | Core — queue depth, detect backpressure | shard | `redis_server_search_workers_admin_priority_pending_jobs` | Unknown | The number of pending admin-priority jobs in worker threads, such as threadpo... |
| ✅ | Core — queue depth, detect backpressure | shard | `redis_server_search_coord_high_priority_pending_jobs` | Unknown | The number of pending jobs in the coordinator thread queue. Coordinator threa... |
| ❌ | Internal cluster detail | shard | `shard_ping_failures` | Gauge |  |
| ❌ | Internal cluster detail | shard | `shard_ping_failure_duration_seconds` | Gauge | Available since RediSearch 2.6. |