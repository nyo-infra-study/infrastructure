# external-secrets — Metric Filter Decisions

> Version: 0.19.2
> Docs: https://external-secrets.io/latest/api/metrics/
> Generated from: `output/*/parsed/external-secrets.csv`

---

| Use | Reason | metric_name | metric_type | description |
| --- | --- | --- | --- | --- |
| ✅ | Core — detect unhealthy cluster-scoped secrets | `clusterexternalsecret_status_condition` | Gauge | The status condition of a specific Cluster External Secret |
| ✅ | Core — detect slow cluster secret reconciliation | `clusterexternalsecret_reconcile_duration` | Gauge | The duration time to reconcile the Cluster External Secret |
| ✅ | Core, track AWS SSM/SecretsManager call volume | `externalsecret_provider_api_calls_count` | Counter | Number of API calls made to an upstream secret provider API. The metric provi... |
| ✅ | Core, reconciliation rate | `externalsecret_sync_calls_total` | Counter | Total number of the External Secret sync calls |
| ✅ | Core, alert on sync failures | `externalsecret_sync_calls_error` | Counter | Total number of the External Secret sync errors |
| ✅ | Core, detect unhealthy secrets | `externalsecret_status_condition` | Gauge | The status condition of a specific External Secret |
| ✅ | Core, detect slow reconciliation | `externalsecret_reconcile_duration` | Gauge | The duration time to reconcile the External Secret |
| ✅ | Core — detect unhealthy push secrets | `pushsecret_status_condition` | Gauge | The status condition of a specific Push Secret |
| ✅ | Core — detect slow push secret reconciliation | `pushsecret_reconcile_duration` | Gauge | The duration time to reconcile the Push Secret |
| ✅ | Core — detect unhealthy cluster secret stores | `clustersecretstore_status_condition` | Gauge | The status condition of a specific Cluster Secret Store |
| ✅ | Core — detect slow cluster store reconciliation | `clustersecretstore_reconcile_duration` | Gauge | The duration time to reconcile the Cluster Secret Store |
| ✅ | Core — detect unhealthy secret stores | `secretstore_status_condition` | Gauge | The status condition of a specific Secret Store |
| ✅ | Core — detect slow store reconciliation | `secretstore_reconcile_duration` | Gauge | The duration time to reconcile the Secret Store |
