# OpenSearch Observability — Architecture & Tutorial

## Mental Model: Grafana vs OpenSearch

In Grafana world, each signal has its own specialized backend:

```mermaid
graph LR
    A[Apps] -->|OTLP| C[OTel Collector]
    C -->|metrics| P[Prometheus]
    C -->|logs| L[Loki]
    C -->|traces| T[Tempo]
    P --> G[Grafana UI]
    L --> G
    T --> G
```

In OpenSearch world, **everything goes into one system**:

```mermaid
graph LR
    A[Apps] -->|OTLP| C[OTel Collector]
    C -->|logs + traces| OS[OpenSearch]
    C -->|metrics| PR[Prometheus]
    OS --> OSD[OpenSearch Dashboards]
    PR --> OSD
```

The key difference: OpenSearch stores everything as **JSON documents in Lucene indices**. There's no separate database per signal — it's all searchable text in one place.

---

## Architecture (Your Setup)

```mermaid
graph TD
    subgraph Apps
        BS[backend-server]
        WF[web-frontend]
    end

    subgraph OTel[OTel Collector]
        RX[Receivers<br/>OTLP gRPC/HTTP]
        PR[Processors<br/>batch, filter]
        EX[Exporters]
    end

    subgraph Grafana Stack
        TEMPO[Tempo<br/>traces]
        LOKI[Loki<br/>logs]
        PROM[Prometheus<br/>metrics]
        GRAF[Grafana UI]
    end

    subgraph OpenSearch Stack
        OS[OpenSearch<br/>ss4o_traces + ss4o_logs]
        OSD[OpenSearch Dashboards<br/>opensearch.localhost]
    end

    BS -->|OTLP| RX
    WF -->|OTLP| RX
    RX --> PR --> EX

    EX -->|traces| TEMPO
    EX -->|logs| LOKI
    EX -->|metrics| PROM
    EX -->|traces + logs| OS

    TEMPO --> GRAF
    LOKI --> GRAF
    PROM --> GRAF
    OS --> OSD
```

---

## Index Naming Convention (SS4O)

The OTel Collector's `opensearch` exporter uses the **Simple Schema for Observability (SS4O)** format:

```
ss4o_{signal}-{dataset}-{namespace}
```

In your setup:
- `ss4o_traces-default-otel` — trace spans
- `ss4o_logs-default-otel` — log records

Each document in these indices is a JSON object with all OTel attributes flattened as fields.

---

## Tutorial: Viewing Your Data

### Step 1: Create Index Patterns

1. Go to `http://opensearch.localhost`
2. Click hamburger menu (☰) → **Management** → **Index Patterns**
3. Click **Create index pattern**
4. Enter: `ss4o_logs*` → Click **Next step**
5. Select time field: `@timestamp` → Click **Create index pattern**
6. Repeat for `ss4o_traces*`

### Step 2: Discover (Raw Log Search)

1. Click hamburger menu (☰) → **Discover**
2. Select `ss4o_logs*` from the dropdown (top-left)
3. Set time range to "Last 15 minutes" (top-right)
4. You should see log documents

**Search examples:**
- `http request` — full-text search across all fields
- `severity_text: ERROR` — filter by field
- `resource.service.name: backend-server` — filter by service
- `body: "database connection"` — search log message body

### Step 3: Trace Explorer

1. Click hamburger menu (☰) → **Observability** → **Traces**
2. This shows a trace list with latency, status, service
3. Click a trace to see the waterfall/gantt view (like Jaeger)

If Observability → Traces shows nothing, it might need the index pattern. Try:
1. Go to **Observability** → **Traces**
2. If prompted, set the trace index to `ss4o_traces*`

### Step 4: Alerting

1. Click hamburger menu (☰) → **Alerting** → **Monitors**
2. Click **Create monitor**
3. Choose "Per query monitor"
4. Define a query like: `severity_text: ERROR AND resource.service.name: backend-server`
5. Set condition: "IS ABOVE 5" (more than 5 errors)
6. Add action: webhook, Slack, email, etc.

---

## Query Language: DQL vs PPL

OpenSearch has two query languages:

### DQL (Dashboards Query Language) — used in Discover search bar
```
severity_text: ERROR
resource.service.name: backend-server AND body: "timeout"
span.status.code: 2
```

### PPL (Piped Processing Language) — used in Observability
```sql
source = ss4o_logs-default-otel
| where severity_text = 'ERROR'
| where resource.service.name = 'backend-server'
| stats count() by span_id
| sort - count()
```

### SQL (yes, actual SQL)
```sql
SELECT severity_text, body, @timestamp
FROM ss4o_logs-default-otel
WHERE resource.service.name = 'backend-server'
  AND severity_text = 'ERROR'
ORDER BY @timestamp DESC
LIMIT 50
```

---

## Key Differences from Grafana

| Concept | Grafana LGTM | OpenSearch |
|---------|-------------|------------|
| **Log query** | `{service_name="backend-server"} \|= "error"` (LogQL) | `resource.service.name: backend-server AND body: error` (DQL) |
| **Trace search** | TraceQL: `{resource.service.name="backend-server" && duration > 100ms}` | DQL: `resource.service.name: backend-server AND durationInNanos > 100000000` |
| **Metrics** | PromQL: `rate(http_requests_total[5m])` | Not ideal — use Prometheus for metrics |
| **Full-text search** | ❌ Loki can't search arbitrary substrings efficiently | ✅ Every word in every field is indexed |
| **Storage model** | Each signal has optimized storage (TSDB, chunks, object store) | Everything is Lucene inverted index |
| **Dashboard creation** | Visual panel editor, many chart types | Visualize tab, fewer chart types |
| **Alerting** | Grafana Alerting (multi-datasource) | OpenSearch Alerting (query-based monitors) |

---

## When to Use Which

**Use Grafana for:**
- Metrics dashboards (PromQL is unmatched)
- Quick label-based log filtering
- Trace waterfall views (Tempo + Traces Drilldown is excellent)
- Alerting on metrics thresholds

**Use OpenSearch for:**
- Full-text log search ("find this error UUID across all services")
- Compliance/audit (document-level RBAC, field masking)
- Ad-hoc investigation when you don't know which labels to filter by
- Long-term log retention with ILM tiering

**In your setup, both run side-by-side:**
- Same data flows to both (OTel Collector fans out)
- Use Grafana for day-to-day monitoring
- Use OpenSearch when you need to search for something specific in logs

---

## Metrics in OpenSearch?

OpenSearch CAN store metrics, but it's not great at it:
- No native TSDB (time-series database) optimizations
- No PromQL equivalent for aggregations
- Storage is 5-10x more expensive than Prometheus for metrics

The recommended approach (and what your setup does):
- **Metrics → Prometheus** (efficient, PromQL, Grafana dashboards)
- **Logs + Traces → OpenSearch** (full-text search, RBAC)

If you really want metrics in OpenSearch, the official stack uses **Prometheus as a sidecar** and OpenSearch Dashboards has a Prometheus plugin to query it. But it's simpler to just use Grafana for metrics.

---

## Production Considerations

For production, you'd enable:
1. **Security plugin** — RBAC, SAML/OIDC, audit logs, field-level security
2. **Multiple nodes** — 3 master + 2 data minimum for HA
3. **ILM policies** — hot (SSD, 7d) → warm (HDD, 30d) → cold (S3, 90d) → delete
4. **Snapshot repository** — S3 backups for disaster recovery
5. **Data Prepper** — between OTel Collector and OpenSearch for enrichment/sampling

### ILM (Index Lifecycle Management) Flow

```mermaid
graph LR
    H[HOT<br/>SSD, 0-7 days<br/>Active writes + queries] -->|rollover| W[WARM<br/>HDD, 7-30 days<br/>Read-only, less frequent]
    W -->|shrink + force merge| C[COLD<br/>S3 snapshot, 30-90 days<br/>Searchable via restore]
    C -->|TTL| D[DELETE<br/>Gone forever]
```

### Production Architecture

```mermaid
graph TD
    subgraph Ingestion
        APP[Applications] -->|OTLP| OTEL[OTel Collector]
        OTEL -->|OTLP| DP[Data Prepper<br/>sampling, enrichment]
    end

    subgraph OpenSearch Cluster
        DP --> M1[Master 1]
        DP --> M2[Master 2]
        DP --> M3[Master 3]
        M1 --- D1[Data Node 1<br/>HOT - SSD]
        M2 --- D2[Data Node 2<br/>HOT - SSD]
        M3 --- D3[Data Node 3<br/>WARM - HDD]
        D3 --- S3[S3<br/>COLD snapshots]
    end

    subgraph Access
        OSD[OpenSearch Dashboards] --> M1
        SAML[SAML/OIDC Provider] --> OSD
    end
```
