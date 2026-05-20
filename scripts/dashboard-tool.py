#!/usr/bin/env python3
"""
Dashboard Tool — Manipulate Grafana dashboard JSON files.

Usage:
  python3 scripts/dashboard-tool.py list <file.json>
  python3 scripts/dashboard-tool.py datasources <file.json>
  python3 scripts/dashboard-tool.py replace-ds <file.json> --from <old-uid> --to <new-uid>
  python3 scripts/dashboard-tool.py replace-ds-all <file.json> --to <new-uid>
  python3 scripts/dashboard-tool.py replace-job <file.json> --from <old-job> --to <new-job>
  python3 scripts/dashboard-tool.py panels <file.json>
  python3 scripts/dashboard-tool.py queries <file.json>
  python3 scripts/dashboard-tool.py fix-for-gigapipe <file.json>

Commands:
  list          Show dashboard title, uid, panel count
  datasources   List all datasource UIDs referenced
  replace-ds    Replace a specific datasource UID
  replace-ds-all Replace ALL datasource UIDs with one
  replace-job   Replace job label values in queries
  panels        List all panels with title and type
  queries       Show all raw SQL/PromQL queries
  fix-for-gigapipe  Auto-fix common issues for Gigapipe:
                    - Replace datasource UIDs to prometheus-pci/loki-pci/tempo-pci
                    - Fix job label mismatches
"""

import json
import sys
import argparse
import re
from pathlib import Path


def load_dashboard(path):
    with open(path, 'r') as f:
        return json.load(f)


def save_dashboard(path, data):
    with open(path, 'w') as f:
        json.dump(data, f, indent=2)
    print(f"  Saved: {path}")


def find_all_datasources(obj, found=None):
    """Recursively find all datasource UIDs in the dashboard."""
    if found is None:
        found = set()
    if isinstance(obj, dict):
        if 'datasource' in obj and isinstance(obj['datasource'], dict):
            uid = obj['datasource'].get('uid', '')
            ds_type = obj['datasource'].get('type', '')
            if uid and uid != '-- Mixed --':
                found.add((uid, ds_type))
        for v in obj.values():
            find_all_datasources(v, found)
    elif isinstance(obj, list):
        for item in obj:
            find_all_datasources(item, found)
    return found


def replace_datasource_uid(obj, old_uid, new_uid):
    """Recursively replace datasource UIDs."""
    count = 0
    if isinstance(obj, dict):
        if 'datasource' in obj and isinstance(obj['datasource'], dict):
            if obj['datasource'].get('uid') == old_uid:
                obj['datasource']['uid'] = new_uid
                count += 1
        for v in obj.values():
            count += replace_datasource_uid(v, old_uid, new_uid)
    elif isinstance(obj, list):
        for item in obj:
            count += replace_datasource_uid(item, old_uid, new_uid)
    return count


def replace_all_datasource_uids(obj, new_uid, ds_type=None):
    """Replace ALL datasource UIDs with a single one."""
    count = 0
    if isinstance(obj, dict):
        if 'datasource' in obj and isinstance(obj['datasource'], dict):
            uid = obj['datasource'].get('uid', '')
            if uid and uid != '-- Mixed --' and uid != '$datasource':
                if ds_type is None or obj['datasource'].get('type') == ds_type:
                    obj['datasource']['uid'] = new_uid
                    count += 1
        for v in obj.values():
            count += replace_all_datasource_uids(v, new_uid, ds_type)
    elif isinstance(obj, list):
        for item in obj:
            count += replace_all_datasource_uids(item, new_uid, ds_type)
    return count


def replace_in_queries(obj, old_str, new_str):
    """Replace strings in all query expressions."""
    count = 0
    if isinstance(obj, dict):
        for key in ['expr', 'rawSql', 'query']:
            if key in obj and isinstance(obj[key], str):
                if old_str in obj[key]:
                    obj[key] = obj[key].replace(old_str, new_str)
                    count += 1
        for v in obj.values():
            count += replace_in_queries(v, old_str, new_str)
    elif isinstance(obj, list):
        for item in obj:
            count += replace_in_queries(item, old_str, new_str)
    return count


def list_panels(obj, panels=None, depth=0):
    """Recursively list all panels."""
    if panels is None:
        panels = []
    if isinstance(obj, dict):
        if 'type' in obj and 'title' in obj:
            panels.append({
                'title': obj.get('title', ''),
                'type': obj.get('type', ''),
                'id': obj.get('id', ''),
            })
        if 'panels' in obj:
            for p in obj['panels']:
                list_panels(p, panels, depth + 1)
    elif isinstance(obj, list):
        for item in obj:
            list_panels(item, panels, depth)
    return panels


def extract_queries(obj, queries=None):
    """Extract all query expressions."""
    if queries is None:
        queries = []
    if isinstance(obj, dict):
        for key in ['expr', 'rawSql', 'query']:
            if key in obj and isinstance(obj[key], str) and obj[key].strip():
                queries.append({
                    'type': key,
                    'value': obj[key],
                    'refId': obj.get('refId', ''),
                })
        if 'targets' in obj:
            for t in obj['targets']:
                extract_queries(t, queries)
        for v in obj.values():
            if isinstance(v, (dict, list)):
                extract_queries(v, queries)
    elif isinstance(obj, list):
        for item in obj:
            extract_queries(item, queries)
    return queries


def fix_for_gigapipe(data):
    """Auto-fix dashboard for Gigapipe compatibility."""
    changes = []

    # Map common datasource types to our UIDs
    ds_map = {
        'prometheus': 'prometheus-pci',
        'loki': 'loki-pci',
        'tempo': 'tempo-pci',
    }

    # Replace datasources by type
    for ds_type, new_uid in ds_map.items():
        count = replace_all_datasource_uids(data, new_uid, ds_type)
        if count > 0:
            changes.append(f"  Replaced {count} {ds_type} datasource refs → {new_uid}")

    # Fix common job label mismatches
    job_fixes = {
        'argocd-server-metrics': 'argocd',
        'argocd-repo-server-metrics': 'argocd',
        'argocd-metrics': 'argocd',
    }
    for old_job, new_job in job_fixes.items():
        count = replace_in_queries(data, f'job="{old_job}"', f'job="{new_job}"')
        if count > 0:
            changes.append(f"  Fixed job label: {old_job} → {new_job} ({count} queries)")

    # Fix namespace label (Gigapipe uses namespace not exported_namespace)
    count = replace_in_queries(data, 'namespace=~"$namespace"', 'namespace=~"$namespace"')

    return changes


def main():
    parser = argparse.ArgumentParser(description='Grafana Dashboard Tool')
    parser.add_argument('command', choices=[
        'list', 'datasources', 'replace-ds', 'replace-ds-all',
        'replace-job', 'panels', 'queries', 'fix-for-gigapipe'
    ])
    parser.add_argument('file', help='Dashboard JSON file')
    parser.add_argument('--from', dest='from_val', help='Value to replace from')
    parser.add_argument('--to', dest='to_val', help='Value to replace to')

    args = parser.parse_args()
    path = Path(args.file)

    if not path.exists():
        print(f"Error: {path} not found")
        sys.exit(1)

    data = load_dashboard(path)

    if args.command == 'list':
        print(f"  Title: {data.get('title', 'N/A')}")
        print(f"  UID: {data.get('uid', 'N/A')}")
        panels = list_panels(data)
        print(f"  Panels: {len(panels)}")
        print(f"  Tags: {data.get('tags', [])}")

    elif args.command == 'datasources':
        ds = find_all_datasources(data)
        print(f"  Datasources ({len(ds)}):")
        for uid, ds_type in sorted(ds):
            print(f"    {uid} ({ds_type})")

    elif args.command == 'replace-ds':
        if not args.from_val or not args.to_val:
            print("Error: --from and --to required")
            sys.exit(1)
        count = replace_datasource_uid(data, args.from_val, args.to_val)
        print(f"  Replaced {count} occurrences: {args.from_val} → {args.to_val}")
        save_dashboard(path, data)

    elif args.command == 'replace-ds-all':
        if not args.to_val:
            print("Error: --to required")
            sys.exit(1)
        count = replace_all_datasource_uids(data, args.to_val)
        print(f"  Replaced {count} datasource refs → {args.to_val}")
        save_dashboard(path, data)

    elif args.command == 'replace-job':
        if not args.from_val or not args.to_val:
            print("Error: --from and --to required")
            sys.exit(1)
        count = replace_in_queries(data, args.from_val, args.to_val)
        print(f"  Replaced {count} occurrences in queries: {args.from_val} → {args.to_val}")
        save_dashboard(path, data)

    elif args.command == 'panels':
        panels = list_panels(data)
        print(f"  Panels ({len(panels)}):")
        for p in panels:
            print(f"    [{p['type']}] {p['title']}")

    elif args.command == 'queries':
        queries = extract_queries(data)
        print(f"  Queries ({len(queries)}):")
        for q in queries:
            expr = q['value'][:100] + ('...' if len(q['value']) > 100 else '')
            print(f"    [{q['type']}] {expr}")

    elif args.command == 'fix-for-gigapipe':
        changes = fix_for_gigapipe(data)
        if changes:
            print("  Changes:")
            for c in changes:
                print(f"    {c}")
            save_dashboard(path, data)
        else:
            print("  No changes needed.")


if __name__ == '__main__':
    main()
