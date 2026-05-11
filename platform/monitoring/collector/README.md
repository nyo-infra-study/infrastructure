# OpenTelemetry Collector — Modular Configuration

Central telemetry pipeline for the local dev cluster. Receives OTLP from apps,
scrapes infrastructure metrics, collects pod logs, and forwards everything to
the Grafana LGTM stack (Prometheus, Loki, Tempo).

## File Layout

```
collector/
├── README.md                  ← You are here
├── values.yaml                ← Base config (image, mode, security, volumes, resources, RBAC)
├── receivers-infra.yaml       ← Prometheus scrape receivers for infra (cAdvisor, kubelet, node-exporter, KSM, CoreDNS)
├── receivers-blackbox.yaml    ← Blackbox Exporter probe targets (uptime checks)
├── receivers-apps.yaml        ← OTLP receiver + LGTM/ArgoCD/Pyroscope self-monitoring scrapers
├── receivers-logs.yaml        ← Filelog receiver (pod log collection)
├── processors.yaml            ← All processors (batch, memory_limiter, k8sattributes, filters, resource enrichment)
├── exporters.yaml             ← Exporter definitions (Tempo, Loki, Prometheus remote write)
└── pipelines.yaml             ← Service pipelines wiring receivers → processors → exporters
```

## How It Works

ArgoCD merges all value files in order (last wins for overlapping keys).
The `monitoring-otel.yaml` Application references each file:

```yaml
helm:
  valueFiles:
    - $values/platform/monitoring/common-values.yaml
    - $values/platform/monitoring/collector/values.yaml
    - $values/platform/monitoring/collector/receivers-infra.yaml
    - $values/platform/monitoring/collector/receivers-blackbox.yaml
    - $values/platform/monitoring/collector/receivers-apps.yaml
    - $values/platform/monitoring/collector/receivers-logs.yaml
    - $values/platform/monitoring/collector/processors.yaml
    - $values/platform/monitoring/collector/exporters.yaml
    - $values/platform/monitoring/collector/pipelines.yaml
```

Helm deep-merges YAML maps, so `config.receivers` from each file gets merged
into a single receivers map. Same for `config.processors`, `config.exporters`,
and `config.service.pipelines`.

## Adding a New Scrape Target

1. Decide which file it belongs in (infra metric → `receivers-infra.yaml`,
   uptime probe → `receivers-blackbox.yaml`, app/stack self-monitoring →
   `receivers-apps.yaml`).
2. Add the `prometheus/<name>` receiver with its scrape config.
3. Add the corresponding `resource/<name>` processor in `processors.yaml`.
4. Wire the pipeline in `pipelines.yaml`.

## Adding a New Blackbox Probe

Edit `receivers-blackbox.yaml` and add a new job under
`config.receivers.prometheus/blackbox.config.scrape_configs`. Follow the
existing pattern — the relabel config is identical for all targets.

## Notes

- The collector runs as a **DaemonSet** (required for filelog receiver).
- Memory is capped at 512Mi with backpressure via `memory_limiter`.
- Noisy Go runtime / process metrics from apps are dropped by `filter/metrics`.
- cAdvisor + KSM metrics use an allowlist (`filter/infra-allow`) to keep only
  actionable signals.
