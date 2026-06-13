# cadvisor — Metric Filter Decisions

> Docs: https://github.com/google/cadvisor/blob/master/docs/storage/prometheus.md
> Generated from: `output/*/parsed/cadvisor.csv`

---

| Use | Reason | component | metric_name | metric_type | description |
| --- | --- | --- | --- | --- | --- |
| ❌ | Too granular — EBS at AWS level | container | `container_blkio_device_usage_total` | Counter | Blkio device bytes usage |
| ✅ | Needed to calculate throttle % | container | `container_cpu_cfs_periods_total` | Counter | Number of elapsed enforcement period intervals |
| ✅ | Throttled period count — needed for throttle % ratio (throttled_periods / total_periods). Used in EaglePoint dashboard | container | `container_cpu_cfs_throttled_periods_total` | Counter | Number of throttled period intervals |
| ✅ | Detects CPU limit throttling | container | `container_cpu_cfs_throttled_seconds_total` | Counter | Total time duration the container has been throttled |
| ❌ | cpu_usage is sufficient | container | `container_cpu_load_average_10s` | Gauge | Value of container cpu load average over the last 10 seconds |
| ❌ | Scheduler internals | container | `container_cpu_schedstat_run_periods_total` | Counter | Number of times processes of the cgroup have run on the cpu |
| ❌ | Scheduler internals | container | `container_cpu_schedstat_runqueue_seconds_total` | Counter | Time duration processes of the container have been waiting on a runqueue |
| ❌ | Scheduler internals | container | `container_cpu_schedstat_run_seconds_total` | Counter | Time duration the processes of the container have run on the CPU |
| ❌ | cpu_usage_seconds_total is sufficient | container | `container_cpu_system_seconds_total` | Counter | Cumulative system cpu time consumed |
| ✅ | Primary CPU metric — rate() gives CPU usage | container | `container_cpu_usage_seconds_total` | Counter | Cumulative cpu time consumed |
| ✅ | User-space CPU time — isolates application CPU from kernel overhead, useful for profiling workload efficiency. Used in EaglePoint dashboard | container | `container_cpu_user_seconds_total` | Counter | Cumulative user cpu time consumed |
| ❌ | Only for FD leak debugging | container | `container_file_descriptors` | Gauge | Number of open file descriptors for the container |
| ❌ | Niche | container | `container_fs_inodes_free` | Gauge | Number of available Inodes |
| ❌ | Niche | container | `container_fs_inodes_total` | Gauge | Total number of Inodes |
| ❌ | Niche — diskIO | container | `container_fs_io_current` | Gauge | Number of I/Os currently in progress |
| ❌ | Niche — diskIO | container | `container_fs_io_time_seconds_total` | Counter | Cumulative count of seconds spent doing I/Os |
| ❌ | Niche — diskIO | container | `container_fs_io_time_weighted_seconds_total` | Counter | Cumulative weighted I/O time |
| ❌ | Rarely set per container | container | `container_fs_limit_bytes` | Gauge | Number of bytes that can be consumed by the container on this filesystem |
| ❌ | Niche — diskIO | container | `container_fs_reads_bytes_total` | Counter | Cumulative count of bytes read |
| ❌ | Niche — diskIO | container | `container_fs_read_seconds_total` | Counter | Cumulative count of seconds spent reading |
| ❌ | Niche — diskIO | container | `container_fs_reads_merged_total` | Counter | Cumulative count of reads merged |
| ❌ | Niche — diskIO | container | `container_fs_reads_total` | Counter | Cumulative count of reads completed |
| ❌ | Niche — diskIO | container | `container_fs_sector_reads_total` | Counter | Cumulative count of sector reads completed |
| ❌ | Niche — diskIO | container | `container_fs_sector_writes_total` | Counter | Cumulative count of sector writes completed |
| ✅ | Alerts on ephemeral storage pressure | container | `container_fs_usage_bytes` | Gauge | Number of bytes that are consumed by the container on this filesystem |
| ❌ | Niche — diskIO | container | `container_fs_writes_bytes_total` | Counter | Cumulative count of bytes written |
| ❌ | Niche — diskIO | container | `container_fs_write_seconds_total` | Counter | Cumulative count of seconds spent writing |
| ❌ | Niche — diskIO | container | `container_fs_writes_merged_total` | Counter | Cumulative count of writes merged |
| ❌ | Niche — diskIO | container | `container_fs_writes_total` | Counter | Cumulative count of writes completed |
| ❌ | Available from K8s API | container | `container_health_state` | Gauge | State of the health check probe |
| ❌ | Hugepages not used | container | `container_hugetlb_failcnt` | Counter | Number of hugepage usage hits limits |
| ❌ | Hugepages not used | container | `container_hugetlb_max_usage_bytes` | Gauge | Maximum hugepage usages recorded |
| ❌ | Hugepages not used | container | `container_hugetlb_usage_bytes` | Gauge | Current hugepage usage |
| ✅ | Detect disappeared containers | container | `container_last_seen` | Gauge | Last time a container was seen by the exporter |
| ❌ | Requires resctrl build flag | container | `container_llc_occupancy_bytes` | Gauge | Last level cache usage statistics for container counted with RDT Memory Bandw... |
| ❌ | Requires resctrl build flag | container | `container_memory_bandwidth_bytes` | Gauge | Total memory bandwidth usage statistics for container counted with RDT Memory... |
| ❌ | Requires resctrl build flag | container | `container_memory_bandwidth_local_bytes` | Gauge | Local memory bandwidth usage statistics for container counted with RDT Memory... |
| ✅ | Distinguishes cache from real usage | container | `container_memory_cache` | Gauge | Total page cache memory |
| ❌ | Available from K8s events | container | `container_memory_failcnt` | Counter | Number of memory usage hits limits |
| ❌ | Niche | container | `container_memory_failures_total` | Counter | Cumulative count of memory allocation failures |
| ❌ | Niche — cgroup v2 memory detail, not needed for standard monitoring | container | `container_memory_file_dirty_bytes` | Gauge | File cache that has been modified but not yet written back to disk (cgroup v2) |
| ❌ | Niche — cgroup v2 memory detail, not needed for standard monitoring | container | `container_memory_file_writeback_bytes` | Gauge | File cache that is currently being written back to disk (cgroup v2) |
| ❌ | Niche | container | `container_memory_mapped_file` | Gauge | Size of memory mapped files |
| ❌ | Sizing only, not real-time | container | `container_memory_max_usage_bytes` | Gauge | Maximum memory usage recorded |
| ❌ | Niche | container | `container_memory_migrate` | Gauge | Memory migrate status |
| ❌ | Niche | container | `container_memory_numa_pages` | Gauge | Number of used pages per NUMA node |
| ❌ | Niche — cgroup v2 page reclaim detail | container | `container_memory_pgscan_total` | Counter | Cumulative number of pages scanned by the page reclaim algorithm (cgroup v2) |
| ❌ | Niche — cgroup v2 page reclaim detail | container | `container_memory_pgsteal_total` | Counter | Cumulative number of pages reclaimed by the page reclaim algorithm (cgroup v2) |
| ✅ | Actual app memory footprint (no cache) | container | `container_memory_rss` | Gauge | Size of RSS |
| ❌ | Swap usually disabled in K8s | container | `container_memory_swap` | Gauge | Container swap usage |
| ✅ | Total memory including cache — OOM risk assessment | container | `container_memory_usage_bytes` | Gauge | Current memory usage, including all memory regardless of when it was accessed |
| ✅ | What K8s uses for OOM kill decisions | container | `container_memory_working_set_bytes` | Gauge | Current working set |
| ❌ | Niche — cgroup v2 refault detail, too low-level | container | `container_memory_workingset_refault_anon_total` | Counter | Cumulative number of refaults of previously evicted anonymous pages (cgroup v2) |
| ❌ | Niche — cgroup v2 refault detail, too low-level | container | `container_memory_workingset_refault_file_total` | Counter | Cumulative number of refaults of previously evicted file pages (cgroup v2) |
| ❌ | Niche | container | `container_network_advance_tcp_stats_total` | Gauge | advanced tcp connections statistic for container |
| ✅ | Pod network throughput | container | `container_network_receive_bytes_total` | Counter | Cumulative count of bytes received |
| ✅ | Detect NIC/driver issues | container | `container_network_receive_errors_total` | Counter | Cumulative count of errors encountered while receiving |
| ✅ | Detect network saturation | container | `container_network_receive_packets_dropped_total` | Counter | Cumulative count of packets dropped while receiving |
| ❌ | Bytes is enough | container | `container_network_receive_packets_total` | Counter | Cumulative count of packets received |
| ❌ | Niche | container | `container_network_tcp6_usage_total` | Gauge | tcp6 connection usage statistic for container |
| ❌ | Niche | container | `container_network_tcp_usage_total` | Gauge | tcp connection usage statistic for container |
| ✅ | Pod network throughput | container | `container_network_transmit_bytes_total` | Counter | Cumulative count of bytes transmitted |
| ✅ | Detect NIC/driver issues | container | `container_network_transmit_errors_total` | Counter | Cumulative count of errors encountered while transmitting |
| ✅ | Detect network saturation | container | `container_network_transmit_packets_dropped_total` | Counter | Cumulative count of packets dropped while transmitting |
| ❌ | Bytes is enough | container | `container_network_transmit_packets_total` | Counter | Cumulative count of packets transmitted |
| ❌ | Niche | container | `container_network_udp6_usage_total` | Gauge | udp6 connection usage statistic for container |
| ❌ | Niche | container | `container_network_udp_usage_total` | Gauge | udp connection usage statistic for container |
| ✅ | OOM kill detection | container | `container_oom_events_total` | Counter | Count of out of memory events observed for the container |
| ❌ | Requires libpfm build flag | container | `container_perf_events_scaling_ratio` | Gauge | Scaling ratio for perf event counter (event can be identified by `event` labe... |
| ❌ | Requires libpfm build flag | container | `container_perf_events_total` | Counter | Scaled counter of perf core event (event can be identified by `event` label a... |
| ❌ | Requires libpfm build flag | container | `container_perf_uncore_events_scaling_ratio` | Gauge | Scaling ratio for perf uncore event counter (event can be identified by `even... |
| ❌ | Requires libpfm build flag | container | `container_perf_uncore_events_total` | Counter | Scaled counter of perf uncore event (event can be identified by `event` label... |
| ❌ | Niche | container | `container_processes` | Gauge | Number of processes running inside the container |
| ❌ | Intrusive collection, adds latency | container | `container_referenced_bytes` | Gauge | Container referenced bytes during last measurements cycle based on Referenced... |
| ❌ | Niche | container | `container_sockets` | Gauge | Number of open sockets for the container |
| ❌ | Static config | container | `container_spec_cpu_period` | Gauge | CPU period of the container |
| ✅ | Needed to calculate CPU limit utilization | container | `container_spec_cpu_quota` | Gauge | CPU quota of the container |
| ❌ | Static config | container | `container_spec_cpu_shares` | Gauge | CPU share of the container |
| ✅ | Needed to calculate usage % of limit | container | `container_spec_memory_limit_bytes` | Gauge | Memory limit for the container |
| ❌ | Static config | container | `container_spec_memory_reservation_limit_bytes` | Gauge | Memory reservation limit for the container |
| ❌ | Swap disabled | container | `container_spec_memory_swap_limit_bytes` | Gauge | Memory swap limit for the container |
| ❌ | Useful once, not a time-series | container | `container_start_time_seconds` | Gauge | Start time of the container since unix epoch |
| ❌ | Rarely useful | container | `container_tasks_state` | Gauge | Number of tasks in given state (`sleeping`, `running`, `stopped`, `uninterrup... |
| ❌ | Niche | container | `container_threads` | Gauge | Number of threads running inside the container |
| ❌ | Static config | container | `container_threads_max` | Gauge | Maximum number of threads allowed inside the container |
| ❌ | Static config | container | `container_ulimits_soft` | Gauge | Soft ulimit values for the container root process. Unlimited if -1, except pr... |
| ❌ | NUMA internals | hardware | `machine_cpu_cache_capacity_bytes` | Gauge | Cache size in bytes assigned to NUMA node and CPU core |
| ✅ | Node capacity — needed for CPU utilization % | hardware | `machine_cpu_cores` | Gauge | Number of logical CPU cores |
| ✅ | Complements logical cores (hyperthreading) | hardware | `machine_cpu_physical_cores` | Gauge | Number of physical CPU cores |
| ✅ | Node hardware topology | hardware | `machine_cpu_sockets` | Gauge | Number of CPU sockets |
| ❌ | DIMM internals | hardware | `machine_dimm_capacity_bytes` | Gauge | Total RAM DIMM capacity (all types memory modules) value labeled by dimm type... |
| ❌ | DIMM internals | hardware | `machine_dimm_count` | Gauge | Number of RAM DIMM (all types memory modules) value labeled by dimm type,<br>... |
| ✅ | Node capacity — needed for memory utilization % | hardware | `machine_memory_bytes` | Gauge | Amount of memory installed on the machine |
| ❌ | Swap usually disabled in K8s | hardware | `machine_swap_bytes` | Gauge | Amount of swap memory available on the machine |
| ❌ | NUMA internals | hardware | `machine_node_distance` | Gauge | Distance between NUMA node and target NUMA node |
| ❌ | Hugepages not used | hardware | `machine_node_hugepages_count` | Gauge | Numer of hugepages assigned to NUMA node |
| ❌ | NUMA internals — machine_memory_bytes is enough | hardware | `machine_node_memory_capacity_bytes` | Gauge | Amount of memory assigned to NUMA node |
| ❌ | Requires libipmctl build flag | hardware | `machine_nvm_avg_power_budget_watts` | Gauge | NVM power budget |
| ❌ | Requires libipmctl build flag | hardware | `machine_nvm_capacity` | Gauge | NVM capacity value labeled by NVM mode (memory mode or app direct mode) |
| ❌ | NUMA/topology internals | hardware | `machine_thread_siblings_count` | Gauge | Number of CPU thread siblings |
