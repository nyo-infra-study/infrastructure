# host-metrics — Metric Filter Decisions

> Docs: https://github.com/open-telemetry/opentelemetry-collector-contrib/blob/main/receiver/hostmetricsreceiver/README.md
> Generated from: `output/*/parsed/host-metrics.csv`

---

| Use | Reason | component | metric_name | metric_type | default_enabled | description |
| --- | --- | --- | --- | --- | --- | --- |
| ✅ | Core — node memory pressure detection | default | `system.memory.usage` | Sum | Enabled | Bytes of memory in use. |
| ❌ | Linux-specific — system.memory.usage covers this | optional | `system.linux.memory.available` | Sum | Disabled | An estimate of how much memory is available for starting new applications, wi... |
| ❌ | Linux-specific — niche | optional | `system.linux.memory.dirty` | Sum | Disabled | The amount of dirty memory according to `/proc/meminfo`. |
| ❌ | Niche — not set on most systems | optional | `system.memory.limit` | Sum | Disabled | Total bytes of memory available. |
| ❌ | Not using hugepages | optional | `system.memory.linux.hugepages.limit` | Sum | Disabled | Total number of hugepages available. |
| ❌ | Not using hugepages | optional | `system.memory.linux.hugepages.page_size` | Sum | Disabled | System hugepage size in bytes. |
| ❌ | Not using hugepages | optional | `system.memory.linux.hugepages.reserved` | Sum | Disabled | Number of reserved hugepages (hugepages for which a commitment to allocate ha... |
| ❌ | Not using hugepages | optional | `system.memory.linux.hugepages.surplus` | Sum | Disabled | Number of surplus hugepages (overcommitted hugepages beyond the persistent po... |
| ❌ | Not using hugepages | optional | `system.memory.linux.hugepages.usage` | Sum | Disabled | Number of hugepages in use by state. |
| ❌ | Not using hugepages | optional | `system.memory.linux.hugepages.utilization` | Gauge | Disabled | Percentage of hugepages in use by state. |
| ❌ | Niche — shared memory detail | optional | `system.memory.linux.shared` | Sum | Disabled | Shared memory usage, including tmpfs filesystems and System V/POSIX shared me... |
| ❌ | Static — page size doesn't change | optional | `system.memory.page_size` | Gauge | Disabled | A constant value for the system's configured page size. |
| ✅ | Core — direct utilization without calculation | optional | `system.memory.utilization` | Gauge | Disabled | Percentage of memory bytes in use. |
| ✅ | Core — detect I/O-heavy workloads | default | `system.disk.io` | Sum | Enabled | Disk bytes transferred. |
| ✅ | Core — disk utilization = rate(io_time) | default | `system.disk.io_time` | Sum | Enabled | Time disk spent activated. On Windows, this is calculated as the inverse of d... |
| ❌ | Niche — low-level I/O scheduler detail | default | `system.disk.merged` | Sum | Enabled | The number of disk reads/writes merged into single physical disk access opera... |
| ❌ | Niche — io_time is sufficient for utilization | default | `system.disk.operation_time` | Sum | Enabled | Time spent in disk operations. |
| ✅ | Core — IOPS monitoring | default | `system.disk.operations` | Sum | Enabled | Disk operations count. |
| ❌ | Niche — queue depth, rarely needed | default | `system.disk.pending_operations` | Sum | Enabled | The queue size of pending I/O operations. |
| ❌ | Niche — io_time is simpler and sufficient | default | `system.disk.weighted_io_time` | Sum | Enabled | Time disk spent activated multiplied by the queue length. |
| ❌ | Niche — inode exhaustion is rare | default | `system.filesystem.inodes.usage` | Sum | Enabled | FileSystem inodes used. |
| ✅ | Core — disk full detection | default | `system.filesystem.usage` | Sum | Enabled | Filesystem bytes used. |
| ✅ | Core — direct percentage without calculation | optional | `system.filesystem.utilization` | Gauge | Disabled | Fraction of filesystem bytes used. |
| ❌ | High cardinality — per-state breakdown is noisy | default | `system.network.connections` | Sum | Enabled | The number of connections. |
| ✅ | Core — detect network saturation | default | `system.network.dropped` | Sum | Enabled | The number of packets dropped. |
| ✅ | Core — alert on sustained errors | default | `system.network.errors` | Sum | Enabled | The number of errors encountered. |
| ✅ | Core — bandwidth monitoring | default | `system.network.io` | Sum | Enabled | The number of bytes transmitted and received. |
| ❌ | Niche — bytes (io) is more useful than packet count | default | `system.network.packets` | Sum | Enabled | The number of packets transferred. |
| ❌ | Niche — conntrack detail | optional | `system.network.conntrack.count` | Sum | Disabled | The count of entries in conntrack table. |
| ❌ | Niche — conntrack detail | optional | `system.network.conntrack.max` | Sum | Disabled | The limit for entries in the conntrack table. |
| ❌ | Niche — swap usage is the actionable metric | default | `system.paging.faults` | Sum | Enabled | The number of page faults. |
| ❌ | Niche — swap usage is the actionable metric | default | `system.paging.operations` | Sum | Enabled | The number of paging operations. |
| ✅ | Core — swap usage indicates memory pressure | default | `system.paging.usage` | Sum | Enabled | Swap (unix) or pagefile (windows) usage. |
| ❌ | Redundant — usage is sufficient with known swap size | optional | `system.paging.utilization` | Gauge | Disabled | Swap (unix) or pagefile (windows) utilization. |
| ✅ | Core — CPU utilization breakdown by state | default | `system.cpu.time` | Sum | Enabled | Total seconds each logical CPU spent on each mode. |
| ❌ | Optional — not needed for utilization monitoring | optional | `system.cpu.frequency` | Gauge | Disabled | Current frequency of the CPU core in Hz. |
| ✅ | Useful — normalize CPU usage per core | optional | `system.cpu.logical.count` | Sum | Disabled | Number of available logical CPUs. |
| ❌ | Niche — logical count is sufficient | optional | `system.cpu.physical.count` | Sum | Disabled | Number of available physical CPUs. |
| ✅ | Core — direct utilization metric, no rate() needed | optional | `system.cpu.utilization` | Gauge | Disabled | Difference in system.cpu.time since the last measurement per logical CPU, div... |
