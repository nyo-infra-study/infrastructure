# Grafana Dashboards (Gigapipe)

Import these JSON files manually in Grafana UI:
Dashboards → Import → Upload JSON file

## Datasource UIDs

When importing, map datasources to:
- `prometheus-pci` → Prometheus (PCI)
- `loki-pci` → Loki (PCI)
- `tempo-pci` → Tempo (PCI)
- `prometheus-nonpci` → Prometheus (Non-PCI)
- `loki-nonpci` → Loki (Non-PCI)
- `tempo-nonpci` → Tempo (Non-PCI)

## Available Dashboards

- `backend-server.json` — HTTP latency, request rate, Go runtime, logs, traces
- `infrastructure.json` — Node CPU/memory, container resources, pod status
- `clickhouse.json` — ClickHouse internal metrics (queries, memory, inserts)
