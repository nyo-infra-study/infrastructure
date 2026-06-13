# aws-ec2-network — Metric Filter Decisions

> Version: ena-driver
> Docs: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/monitoring-network-performance-ena.html
> Generated from: `output/*/parsed/aws-ec2-network.csv`

---

| Use | Reason | metric_name | metric_type | description |
| --- | --- | --- | --- | --- |
| ✅ | Core — detect inbound bandwidth throttling, right-size instance types. Used in EaglePoint dashboard | `node_ethtool_bw_in_allowance_exceeded` | Counter | Inbound bandwidth exceeded EC2 instance type limit. From ethtool -S eth0. |
| ✅ | Core — detect outbound bandwidth throttling. Used in EaglePoint dashboard | `node_ethtool_bw_out_allowance_exceeded` | Counter | Outbound bandwidth exceeded EC2 instance type limit. From ethtool -S eth0. |
| ✅ | Core — detect PPS throttling on high-connection workloads. Used in EaglePoint dashboard | `node_ethtool_pps_allowance_exceeded` | Counter | Packets-per-second exceeded EC2 instance type limit. From ethtool -S eth0. |
| ✅ | Core — detect conntrack exhaustion on busy nodes. Used in EaglePoint dashboard | `node_ethtool_conntrack_allowance_exceeded` | Counter | Connection tracking table full. From ethtool -S eth0. |
| ✅ | Core — detect IMDS/DNS/NTP throttling. Used in EaglePoint dashboard | `node_ethtool_linklocal_allowance_exceeded` | Counter | Link-local service rate exceeded (IMDS, DNS, NTP). From ethtool -S eth0. |
