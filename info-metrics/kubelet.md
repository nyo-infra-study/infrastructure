# kubelet — Metric Filter Decisions

> Docs: https://github.com/open-telemetry/opentelemetry-collector-contrib/blob/main/receiver/kubeletstatsreceiver/documentation.md
> Generated from: `output/*/parsed/kubelet.csv`

---

| Use | Reason | component | metric_name | metric_type | default_enabled | description |
| --- | --- | --- | --- | --- | --- | --- |
| ✅ | Cumulative CPU — needed for rate() | default | `container.cpu.time` | Sum | Enabled | Total cumulative CPU time (sum of all cores) spent by the container/pod/node ... |
| ✅ | Instant CPU usage — primary dashboard metric | default | `container.cpu.usage` | Gauge | Enabled | Total CPU usage (sum of all cores per second) averaged over the sample window |
| ✅ | Ephemeral storage remaining | default | `container.filesystem.available` | Gauge | Enabled | Container filesystem available |
| ✅ | Total ephemeral storage — usage % | default | `container.filesystem.capacity` | Gauge | Enabled | Container filesystem capacity |
| ✅ | Ephemeral storage used | default | `container.filesystem.usage` | Gauge | Enabled | Container filesystem usage |
| ✅ | How much memory the container can still use | default | `container.memory.available` | Gauge | Enabled | Container memory available |
| ❌ | Niche — debugging memory pressure from disk-backed pages | default | `container.memory.major_page_faults` | Gauge | Enabled | Container memory major_page_faults |
| ❌ | Niche — minor page faults are normal | default | `container.memory.page_faults` | Gauge | Enabled | Container memory page_faults |
| ✅ | Actual physical memory used (excludes cache) | default | `container.memory.rss` | Gauge | Enabled | Container memory rss |
| ✅ | Total memory including cache — OOM risk | default | `container.memory.usage` | Gauge | Enabled | Container memory usage |
| ✅ | What K8s uses for OOM kill decisions | default | `container.memory.working_set` | Gauge | Enabled | Container memory working_set |
| ✅ | Node-level cumulative CPU | default | `k8s.node.cpu.time` | Sum | Enabled | Total cumulative CPU time (sum of all cores) spent by the container/pod/node ... |
| ✅ | Node-level instant CPU usage | default | `k8s.node.cpu.usage` | Gauge | Enabled | Total CPU usage (sum of all cores per second) averaged over the sample window |
| ✅ | Node disk headroom | default | `k8s.node.filesystem.available` | Gauge | Enabled | Node filesystem available |
| ✅ | Node disk total | default | `k8s.node.filesystem.capacity` | Gauge | Enabled | Node filesystem capacity |
| ✅ | Node disk used | default | `k8s.node.filesystem.usage` | Gauge | Enabled | Node filesystem usage |
| ✅ | Node memory headroom | default | `k8s.node.memory.available` | Gauge | Enabled | Node memory available |
| ❌ | Niche at node level | default | `k8s.node.memory.major_page_faults` | Gauge | Enabled | Node memory major_page_faults |
| ❌ | Niche at node level | default | `k8s.node.memory.page_faults` | Gauge | Enabled | Node memory page_faults |
| ✅ | Node RSS | default | `k8s.node.memory.rss` | Gauge | Enabled | Node memory rss |
| ✅ | Node total memory usage | default | `k8s.node.memory.usage` | Gauge | Enabled | Node memory usage |
| ✅ | Node working set | default | `k8s.node.memory.working_set` | Gauge | Enabled | Node memory working_set |
| ✅ | Network errors — alerts on NIC issues | default | `k8s.node.network.errors` | Sum | Enabled | Node network errors |
| ✅ | Network bytes — bandwidth monitoring | default | `k8s.node.network.io` | Sum | Enabled | Node network IO |
| ✅ | Pod-level cumulative CPU | default | `k8s.pod.cpu.time` | Sum | Enabled | Total cumulative CPU time (sum of all cores) spent by the container/pod/node ... |
| ✅ | Pod-level instant CPU usage | default | `k8s.pod.cpu.usage` | Gauge | Enabled | Total CPU usage (sum of all cores per second) averaged over the sample window |
| ✅ | Pod ephemeral storage remaining | default | `k8s.pod.filesystem.available` | Gauge | Enabled | Pod filesystem available |
| ✅ | Pod ephemeral storage total | default | `k8s.pod.filesystem.capacity` | Gauge | Enabled | Pod filesystem capacity |
| ✅ | Pod ephemeral storage used | default | `k8s.pod.filesystem.usage` | Gauge | Enabled | Pod filesystem usage |
| ✅ | Pod memory headroom | default | `k8s.pod.memory.available` | Gauge | Enabled | Pod memory available |
| ❌ | Niche at pod level | default | `k8s.pod.memory.major_page_faults` | Gauge | Enabled | Pod memory major_page_faults |
| ❌ | Niche at pod level | default | `k8s.pod.memory.page_faults` | Gauge | Enabled | Pod memory page_faults |
| ✅ | Pod RSS | default | `k8s.pod.memory.rss` | Gauge | Enabled | Pod memory rss |
| ✅ | Pod total memory usage | default | `k8s.pod.memory.usage` | Gauge | Enabled | Pod memory usage |
| ✅ | Pod working set — OOM kill threshold | default | `k8s.pod.memory.working_set` | Gauge | Enabled | Pod memory working_set |
| ✅ | Pod network errors | default | `k8s.pod.network.errors` | Sum | Enabled | Pod network errors |
| ✅ | Pod network bytes | default | `k8s.pod.network.io` | Sum | Enabled | Pod network IO |
| ✅ | PVC free space — volume pressure | default | `k8s.volume.available` | Gauge | Enabled | The number of available bytes in the volume. |
| ✅ | PVC total capacity | default | `k8s.volume.capacity` | Gauge | Enabled | The total capacity in bytes of the volume. |
| ❌ | Rarely queried, low value for most workloads | default | `k8s.volume.inodes` | Gauge | Enabled | The total inodes in the filesystem. |
| ❌ | Only matters for millions of small files | default | `k8s.volume.inodes.free` | Gauge | Enabled | The free inodes in the filesystem. |
| ❌ | Niche | default | `k8s.volume.inodes.used` | Gauge | Enabled | The inodes used by the filesystem. This may not equal inodes - free because f... |
| ❌ | Pod restart count from k8sattributes is more useful | optional | `container.uptime` | Sum | Disabled | The time since the container started |
| ❌ | Derivable: cpu.usage / node capacity | optional | `k8s.container.cpu.node.utilization` | Gauge | Disabled | Container cpu utilization as a ratio of the node's capacity |
| ❌ | Derivable: cpu.usage / CPU limit | optional | `k8s.container.cpu_limit_utilization` | Gauge | Disabled | Container cpu utilization as a ratio of the container's limits |
| ❌ | Derivable: cpu.usage / CPU request | optional | `k8s.container.cpu_request_utilization` | Gauge | Disabled | Container cpu utilization as a ratio of the container's requests |
| ❌ | Niche — ephemeral storage rarely needs monitoring at metric level | optional | `k8s.container.ephemeral_storage.usage` | Sum | Disabled | Ephemeral storage used by the container. |
| ❌ | Derivable: working_set / node capacity | optional | `k8s.container.memory.node.utilization` | Gauge | Disabled | Container memory utilization as a ratio of the node's capacity |
| ❌ | Derivable: working_set / memory limit | optional | `k8s.container.memory_limit_utilization` | Gauge | Disabled | Container memory utilization as a ratio of the container's limits |
| ❌ | Derivable: working_set / memory request | optional | `k8s.container.memory_request_utilization` | Gauge | Disabled | Container memory utilization as a ratio of the container's requests |
| ❌ | Niche — system container internals, not actionable | optional | `k8s.node.system_container.cpu.time` | Sum | Disabled | Total cumulative CPU time (sum of all cores) spent by the system container si... |
| ❌ | Niche — system container internals, not actionable | optional | `k8s.node.system_container.cpu.usage` | Gauge | Disabled | Total CPU usage (sum of all cores per second) averaged over the sample window... |
| ❌ | Niche — system container internals, not actionable | optional | `k8s.node.system_container.memory.usage` | Gauge | Disabled | System container memory usage |
| ❌ | Niche — system container internals, not actionable | optional | `k8s.node.system_container.memory.working_set` | Gauge | Disabled | System container memory working_set |
| ❌ | Available from cloud provider / node_exporter | optional | `k8s.node.uptime` | Sum | Disabled | The time since the node started |
| ❌ | Derivable: cpu.usage / node capacity | optional | `k8s.pod.cpu.node.utilization` | Gauge | Disabled | Pod cpu utilization as a ratio of the node's capacity |
| ❌ | Derivable: cpu.usage / sum(container limits) | optional | `k8s.pod.cpu_limit_utilization` | Gauge | Disabled | Pod cpu utilization as a ratio of the pod's total container limits. If any co... |
| ❌ | Derivable: cpu.usage / sum(container requests) | optional | `k8s.pod.cpu_request_utilization` | Gauge | Disabled | Pod cpu utilization as a ratio of the pod's total container requests. If any ... |
| ❌ | Derivable: working_set / node capacity | optional | `k8s.pod.memory.node.utilization` | Gauge | Disabled | Pod memory utilization as a ratio of the node's capacity |
| ❌ | Derivable: working_set / sum(container limits) | optional | `k8s.pod.memory_limit_utilization` | Gauge | Disabled | Pod memory utilization as a ratio of the pod's total container limits. If any... |
| ❌ | Derivable: working_set / sum(container requests) | optional | `k8s.pod.memory_request_utilization` | Gauge | Disabled | Pod memory utilization as a ratio of the pod's total container requests. If a... |
| ❌ | Pod age available from K8s API | optional | `k8s.pod.uptime` | Sum | Disabled | The time since the pod started |
| ❌ | volume.available + volume.capacity already kept | optional | `k8s.pod.volume.usage` | Sum | Disabled | The number of used bytes in the pod volume. |
