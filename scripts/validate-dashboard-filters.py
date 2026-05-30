#!/usr/bin/env python3
"""
validate-dashboard-filters.py — Ensure dashboard metrics aren't dropped by collector filters.

Parses enabled Grafana dashboard JSON files to extract metric names from PromQL
expressions, then checks them against the metric_relabel_configs allowlists in
the OTel Collector receiver configs. Reports any metrics that a dashboard needs
but would be dropped by a filter.

Usage:
  python3 scripts/validate-dashboard-filters.py
  python3 scripts/validate-dashboard-filters.py --dashboards path/to/dashboards/
  python3 scripts/validate-dashboard-filters.py --receivers path/to/collector/
  python3 scripts/validate-dashboard-filters.py --verbose
  python3 scripts/validate-dashboard-filters.py --json

Exit codes:
  0 — All dashboard metrics pass through filters (or have no matching filter).
  1 — One or more dashboard metrics would be dropped by a filter.
  2 — Configuration/parse error.
"""

import json
import re
import sys
import argparse
from pathlib import Path
from dataclasses import dataclass, field

# ─── Defaults ───────────────────────────────────────────────────────────────

SCRIPT_DIR = Path(__file__).resolve().parent
INFRA_ROOT = SCRIPT_DIR.parent

DEFAULT_DASHBOARD_DIRS = [
    INFRA_ROOT / "platform" / "monitoring" / "grafana" / "dashboards" / "shared",
    INFRA_ROOT / "platform" / "monitoring" / "grafana" / "dashboards" / "gigapipe",
]

DEFAULT_RECEIVER_FILES = [
    INFRA_ROOT / "platform" / "monitoring" / "collector" / "receivers-infra.yaml",
    INFRA_ROOT / "platform" / "monitoring" / "collector" / "receivers-apps.yaml",
]


# ─── Data Structures ────────────────────────────────────────────────────────

@dataclass
class FilterRule:
    """A metric_relabel_configs keep rule from a receiver."""
    receiver: str       # e.g. "prometheus/cadvisor"
    job_name: str       # e.g. "kubernetes-cadvisor"
    file: str           # source file
    regex: str          # raw regex string
    compiled: re.Pattern = field(repr=False, default=None)


@dataclass
class DashboardMetric:
    """A metric name extracted from a dashboard query."""
    name: str
    dashboard: str      # dashboard title or filename
    panel: str          # panel title
    expr: str           # full PromQL expression (truncated for display)


# ─── PromQL Metric Extraction ───────────────────────────────────────────────

# Matches metric names in PromQL. Metric names start with a letter or underscore,
# followed by alphanumeric, underscore, or colon characters.
# We exclude known PromQL functions and keywords.
PROMQL_METRIC_RE = re.compile(
    r'\b([a-zA-Z_:][a-zA-Z0-9_:]*)\s*(?:\{|\[|$|\)|\s|,)'
)

PROMQL_FUNCTIONS = {
    # Aggregation operators
    'sum', 'min', 'max', 'avg', 'group', 'stddev', 'stdvar', 'count',
    'count_values', 'bottomk', 'topk', 'quantile', 'limitk', 'limit_ratio',
    # Functions
    'rate', 'irate', 'increase', 'delta', 'idelta', 'resets', 'changes',
    'deriv', 'predict_linear', 'histogram_quantile', 'histogram_avg',
    'histogram_count', 'histogram_sum', 'histogram_fraction',
    'histogram_stddev', 'histogram_stdvar',
    'abs', 'absent', 'absent_over_time', 'ceil', 'floor', 'round',
    'clamp', 'clamp_max', 'clamp_min', 'exp', 'ln', 'log2', 'log10',
    'sqrt', 'sgn', 'sign', 'scalar', 'vector', 'time', 'timestamp',
    'day_of_month', 'day_of_week', 'day_of_year', 'days_in_month',
    'hour', 'minute', 'month', 'year',
    'sort', 'sort_desc', 'sort_by_label', 'sort_by_label_desc',
    'label_join', 'label_replace',
    'avg_over_time', 'min_over_time', 'max_over_time', 'sum_over_time',
    'count_over_time', 'quantile_over_time', 'stddev_over_time',
    'stdvar_over_time', 'last_over_time', 'present_over_time',
    'mad_over_time',
    # Operators / keywords
    'by', 'without', 'on', 'ignoring', 'group_left', 'group_right',
    'bool', 'and', 'or', 'unless', 'offset', 'unless',
    # Special
    'inf', 'nan',
}

# Common label names that appear in PromQL but are not metrics
KNOWN_LABELS = {
    'job', 'instance', 'namespace', 'pod', 'container', 'node', 'service',
    'mode', 'device', 'mountpoint', 'fstype', 'phase', 'reason', 'status',
    'verb', 'resource', 'code', 'method', 'handler', 'type', 'name',
    'version', 'endpoint', 'exported_namespace', 'label_values',
    'alertname', 'alertstate', 'alertgroup', 'severity', 'quantile',
    'grpc_code', 'grpc_method', 'grpc_service', 'request_type',
    'health_status', 'sync_status', 'dest_server', 'project', 'repo',
    'server', 'resource_kind', 'command', 'short_version',
    'service_name', 'exporter', 'processor', 'receiver', 'signal',
    'loki', 'prometheus', 'tempo',
}

# Template variables to ignore
TEMPLATE_VAR_RE = re.compile(r'^\$')


def extract_metric_names(expr: str) -> set[str]:
    """Extract metric names from a PromQL expression."""
    # Find all potential metric names
    candidates = set()

    # Strategy 1: regex for metric_name{ or metric_name[
    for match in PROMQL_METRIC_RE.finditer(expr):
        name = match.group(1)
        candidates.add(name)

    # Strategy 2: also catch bare metric names (no braces) like "up" or "node_load1"
    # Split on operators and parens, then check tokens
    tokens = re.split(r'[+\-*/^%=!<>(),\s]+', expr)
    for token in tokens:
        # Clean up any trailing { or [
        token = re.sub(r'[\{\[\]]+$', '', token)
        if re.match(r'^[a-zA-Z_:][a-zA-Z0-9_:]*$', token):
            candidates.add(token)

    # Filter out functions, keywords, labels, template vars, and numeric-like tokens
    metrics = set()
    for name in candidates:
        if name.lower() in PROMQL_FUNCTIONS:
            continue
        if name in KNOWN_LABELS:
            continue
        if TEMPLATE_VAR_RE.match(name):
            continue
        if name in ('le', 'NaN', 'Inf'):
            continue
        # Skip label names that appear in label matchers (heuristic: very short, no underscore)
        if len(name) <= 4 and '_' not in name and ':' not in name:
            continue
        metrics.add(name)

    return metrics


# ─── Dashboard Parsing ───────────────────────────────────────────────────────

def extract_queries_from_obj(obj, panel_title="", queries=None):
    """Recursively extract all PromQL expressions from a dashboard JSON object."""
    if queries is None:
        queries = []

    if isinstance(obj, dict):
        # Track panel title
        current_title = obj.get('title', panel_title)

        # Extract expressions
        for key in ('expr', 'query'):
            if key in obj and isinstance(obj[key], str) and obj[key].strip():
                queries.append((current_title, obj[key]))

        # Recurse
        for v in obj.values():
            if isinstance(v, (dict, list)):
                extract_queries_from_obj(v, current_title, queries)

    elif isinstance(obj, list):
        for item in obj:
            extract_queries_from_obj(item, panel_title, queries)

    return queries


def parse_dashboard(path: Path) -> list[DashboardMetric]:
    """Parse a dashboard JSON file and return all metrics used."""
    with open(path) as f:
        data = json.load(f)

    title = data.get('title', path.stem)
    queries = extract_queries_from_obj(data)

    metrics = []
    seen = set()

    for panel_title, expr in queries:
        for metric_name in extract_metric_names(expr):
            key = (metric_name, title)
            if key not in seen:
                seen.add(key)
                metrics.append(DashboardMetric(
                    name=metric_name,
                    dashboard=title,
                    panel=panel_title,
                    expr=expr[:120],
                ))

    return metrics


# ─── Receiver/Filter Parsing ────────────────────────────────────────────────

def parse_receiver_filters(path: Path) -> list[FilterRule]:
    """Parse a receiver YAML file and extract metric_relabel_configs keep rules.

    We do a simple text-based parse since the YAML may contain Helm templates
    that break strict YAML parsers.
    """
    filters = []
    content = path.read_text()

    # Find all scrape_configs sections and their metric_relabel_configs
    # We parse line by line tracking indentation context
    lines = content.split('\n')

    current_receiver = ""
    current_job = ""
    in_metric_relabel = False
    in_relabel_entry = False
    current_action = ""
    current_regex = ""

    for i, line in enumerate(lines):
        stripped = line.strip()

        # Track receiver name (e.g. "prometheus/cadvisor:")
        if re.match(r'^    prometheus/\S+:', line) or re.match(r'^    prometheus:', line):
            receiver_match = re.match(r'^    (prometheus\S*):', line)
            if receiver_match:
                current_receiver = receiver_match.group(1).rstrip(':')

        # Track job_name
        job_match = re.match(r"\s*- job_name:\s*['\"]?([^'\"]+)['\"]?", line)
        if job_match:
            current_job = job_match.group(1)

        # Detect metric_relabel_configs section
        if 'metric_relabel_configs:' in stripped:
            in_metric_relabel = True
            continue

        if in_metric_relabel:
            # New list entry in relabel configs
            if stripped.startswith('- source_labels:') or stripped.startswith('- action:'):
                # Save previous entry if complete
                if current_action == 'keep' and current_regex:
                    filters.append(FilterRule(
                        receiver=current_receiver,
                        job_name=current_job,
                        file=str(path.name),
                        regex=current_regex,
                    ))
                current_action = ""
                current_regex = ""
                in_relabel_entry = True

            # Detect action
            action_match = re.match(r"\s*action:\s*(\w+)", line)
            if action_match and in_relabel_entry:
                current_action = action_match.group(1)

            # Detect regex
            regex_match = re.match(r"\s*regex:\s*['\"]?(.+?)['\"]?\s*$", line)
            if regex_match and in_relabel_entry:
                current_regex = regex_match.group(1)

            # Exit metric_relabel_configs when we hit a non-indented line or new section
            # Heuristic: if indentation drops back to job level or new receiver
            if (stripped and not stripped.startswith('-') and not stripped.startswith('#')
                    and ':' in stripped
                    and not stripped.startswith('source_labels')
                    and not stripped.startswith('action')
                    and not stripped.startswith('regex')
                    and not stripped.startswith('replacement')
                    and not stripped.startswith('target_label')
                    and not stripped.startswith('separator')):
                # Save last entry
                if current_action == 'keep' and current_regex:
                    filters.append(FilterRule(
                        receiver=current_receiver,
                        job_name=current_job,
                        file=str(path.name),
                        regex=current_regex,
                    ))
                    current_action = ""
                    current_regex = ""
                in_metric_relabel = False
                in_relabel_entry = False

    # Don't forget the last entry
    if in_metric_relabel and current_action == 'keep' and current_regex:
        filters.append(FilterRule(
            receiver=current_receiver,
            job_name=current_job,
            file=str(path.name),
            regex=current_regex,
        ))

    # Compile regexes
    for f in filters:
        try:
            f.compiled = re.compile(f'^({f.regex})$')
        except re.error:
            print(f"  ⚠ Invalid regex in {f.file} ({f.receiver}): {f.regex}", file=sys.stderr)
            f.compiled = re.compile(r'^$')  # won't match anything

    return filters


# ─── Metric-to-Filter Mapping ───────────────────────────────────────────────

# Map metric prefixes to the receiver/job that scrapes them.
# This tells us which filter to check a metric against.
METRIC_RECEIVER_MAP = [
    # (metric prefix pattern, receiver name or job_name pattern)
    (r'^container_', 'cadvisor'),
    (r'^kubelet_', 'kubelet'),
    (r'^volume_manager_', 'kubelet'),
    (r'^node_', 'node-exporter'),
    (r'^kube_', 'kube-state-metrics'),
    (r'^coredns_', 'coredns'),
    (r'^argocd_', 'argocd'),
    (r'^grpc_server_', 'argocd'),
    (r'^workqueue_', 'argocd'),
    (r'^ClickHouse', 'clickhouse'),
]


def find_applicable_filters(metric_name: str, all_filters: list[FilterRule]) -> list[FilterRule]:
    """Find which filter rules apply to a given metric based on its prefix."""
    applicable = []

    for prefix_re, receiver_hint in METRIC_RECEIVER_MAP:
        if re.match(prefix_re, metric_name):
            for f in all_filters:
                if (receiver_hint in f.receiver.lower() or
                        receiver_hint in f.job_name.lower()):
                    applicable.append(f)
            break  # Only match first prefix

    return applicable


def metric_passes_filter(metric_name: str, filter_rule: FilterRule) -> bool:
    """Check if a metric name would pass through a keep filter."""
    if filter_rule.compiled is None:
        return True
    return bool(filter_rule.compiled.match(metric_name))


# ─── Main Logic ─────────────────────────────────────────────────────────────

def main():
    parser = argparse.ArgumentParser(
        description='Validate that dashboard metrics are not dropped by collector filters.'
    )
    parser.add_argument(
        '--dashboards', nargs='*', type=Path,
        help='Dashboard directories or JSON files to check (default: shared/ + gigapipe/)'
    )
    parser.add_argument(
        '--receivers', nargs='*', type=Path,
        help='Receiver YAML files to parse for filters (default: receivers-infra.yaml + receivers-apps.yaml)'
    )
    parser.add_argument('--verbose', '-v', action='store_true', help='Show all metrics and their status')
    parser.add_argument('--json', action='store_true', help='Output results as JSON')
    parser.add_argument('--list-filters', action='store_true', help='List all parsed filter rules and exit')

    args = parser.parse_args()

    # Resolve paths
    dashboard_paths = args.dashboards or DEFAULT_DASHBOARD_DIRS
    receiver_paths = args.receivers or DEFAULT_RECEIVER_FILES

    # Collect dashboard JSON files
    dashboard_files = []
    for p in dashboard_paths:
        if p.is_file() and p.suffix == '.json':
            dashboard_files.append(p)
        elif p.is_dir():
            dashboard_files.extend(sorted(p.glob('*.json')))
        else:
            print(f"⚠ Skipping {p} (not found or not a JSON file/directory)", file=sys.stderr)

    if not dashboard_files:
        print("❌ No dashboard files found.", file=sys.stderr)
        sys.exit(2)

    # Parse receiver filters
    all_filters = []
    for p in receiver_paths:
        if p.is_file():
            all_filters.extend(parse_receiver_filters(p))
        else:
            print(f"⚠ Receiver file not found: {p}", file=sys.stderr)

    if not all_filters:
        print("⚠ No filter rules found in receiver configs. Nothing to validate.", file=sys.stderr)
        sys.exit(0)

    # List filters mode
    if args.list_filters:
        print(f"Parsed {len(all_filters)} keep-filter rules:\n")
        for f in all_filters:
            print(f"  [{f.file}] {f.receiver} / {f.job_name}")
            print(f"    regex: {f.regex}\n")
        sys.exit(0)

    # Parse dashboards
    all_metrics: list[DashboardMetric] = []
    for df in dashboard_files:
        try:
            all_metrics.extend(parse_dashboard(df))
        except (json.JSONDecodeError, KeyError) as e:
            print(f"⚠ Failed to parse {df}: {e}", file=sys.stderr)

    if not all_metrics:
        print("⚠ No metrics extracted from dashboards.", file=sys.stderr)
        sys.exit(2)

    # Validate each metric against applicable filters
    blocked = []    # (DashboardMetric, FilterRule)
    passed = []     # (DashboardMetric, FilterRule or None)
    no_filter = []  # DashboardMetric — no applicable filter (assumed OK)

    seen_metrics = set()
    for dm in all_metrics:
        if dm.name in seen_metrics:
            continue
        seen_metrics.add(dm.name)

        applicable = find_applicable_filters(dm.name, all_filters)

        if not applicable:
            no_filter.append(dm)
            continue

        # A metric passes if ANY applicable filter allows it
        passes_any = False
        blocking_filter = None
        for f in applicable:
            if metric_passes_filter(dm.name, f):
                passes_any = True
                passed.append((dm, f))
                break
            else:
                blocking_filter = f

        if not passes_any and blocking_filter:
            blocked.append((dm, blocking_filter))

    # Output
    if args.json:
        output = {
            "summary": {
                "total_metrics": len(seen_metrics),
                "passed": len(passed),
                "blocked": len(blocked),
                "no_filter": len(no_filter),
            },
            "blocked": [
                {
                    "metric": dm.name,
                    "dashboard": dm.dashboard,
                    "panel": dm.panel,
                    "filter_file": f.file,
                    "filter_receiver": f.receiver,
                    "filter_job": f.job_name,
                    "filter_regex": f.regex,
                }
                for dm, f in blocked
            ],
            "no_filter": [dm.name for dm in no_filter],
        }
        print(json.dumps(output, indent=2))
    else:
        print(f"\n{'='*70}")
        print(f"  Dashboard ↔ Filter Validation")
        print(f"{'='*70}")
        print(f"\n  Dashboards scanned: {len(dashboard_files)}")
        print(f"  Unique metrics found: {len(seen_metrics)}")
        print(f"  Filter rules loaded: {len(all_filters)}")
        print(f"\n  ✅ Passed (metric allowed by filter): {len(passed)}")
        print(f"  ❌ BLOCKED (metric would be dropped):  {len(blocked)}")
        print(f"  ⚪ No filter (no applicable keep rule): {len(no_filter)}")

        if blocked:
            print(f"\n{'─'*70}")
            print(f"  ❌ BLOCKED METRICS — These will break dashboards!")
            print(f"{'─'*70}\n")
            for dm, f in sorted(blocked, key=lambda x: (x[1].file, x[0].name)):
                print(f"  Metric:    {dm.name}")
                print(f"  Dashboard: {dm.dashboard} → {dm.panel}")
                print(f"  Filter:    {f.file} ({f.receiver} / {f.job_name})")
                print(f"  Regex:     {f.regex}")
                print()

            print(f"{'─'*70}")
            print(f"  💡 Fix: Add the blocked metrics to the keep regex in the filter,")
            print(f"     or remove the panel from the dashboard if it's not needed.")
            print(f"{'─'*70}")

        if args.verbose:
            if passed:
                print(f"\n  ✅ Passed metrics:")
                for dm, f in sorted(passed, key=lambda x: x[0].name):
                    print(f"    {dm.name} (via {f.receiver}/{f.job_name})")

            if no_filter:
                print(f"\n  ⚪ Metrics with no applicable filter (always pass):")
                for dm in sorted(no_filter, key=lambda x: x.name):
                    print(f"    {dm.name} ({dm.dashboard})")

        print()

    # Exit code
    sys.exit(1 if blocked else 0)


if __name__ == '__main__':
    main()
