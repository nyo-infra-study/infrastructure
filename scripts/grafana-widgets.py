#!/usr/bin/env python3
"""
Grafana Widget Info Extractor

Extracts widget/panel information from Grafana dashboard JSON files.
Outputs structured info about each widget: title, type, queries, and query settings.
"""

import json
import sys
from pathlib import Path
from typing import Optional

try:
    import yaml
    HAS_YAML = True
except ImportError:
    HAS_YAML = False


def extract_query_info(target: dict) -> dict:
    """Extract query information from a target."""
    return {
        "refId": target.get("refId", ""),
        "expr": target.get("expr", ""),
        "legendFormat": target.get("legendFormat", ""),
        "format": target.get("format", "time_series"),
        "instant": target.get("instant", False),
        "range": target.get("range", True),
        "interval": target.get("interval", ""),
        "intervalFactor": target.get("intervalFactor"),
    }


def extract_widget_info(panel: dict) -> dict:
    """Extract information from a single panel/widget."""
    widget = {
        "id": panel.get("id"),
        "title": panel.get("title", ""),
        "type": panel.get("type", ""),
        "description": panel.get("description", ""),
    }
    
    # Extract datasource
    ds = panel.get("datasource", {})
    if isinstance(ds, dict):
        widget["datasource"] = {
            "type": ds.get("type", ""),
            "uid": ds.get("uid", ""),
        }
    else:
        widget["datasource"] = {"uid": ds} if ds else {}
    
    # Extract queries/targets
    targets = panel.get("targets", [])
    widget["queries"] = [extract_query_info(t) for t in targets]
    
    # For text panels, include content
    if panel.get("type") == "text":
        options = panel.get("options", {})
        widget["content"] = options.get("content", "")
    
    # Extract transformations if present
    transformations = panel.get("transformations", [])
    if transformations:
        widget["transformations"] = [
            {"id": t.get("id", ""), "options": t.get("options", {})}
            for t in transformations
        ]
    
    return widget


def extract_all_widgets(json_path: Path) -> dict:
    """Extract all widgets from a dashboard JSON."""
    with open(json_path, "r") as f:
        data = json.load(f)
    
    result = {
        "dashboard": {
            "title": data.get("title", ""),
            "uid": data.get("uid", ""),
            "tags": data.get("tags", []),
            "refresh": data.get("refresh", ""),
            "time": data.get("time", {}),
        },
        "variables": [],
        "widgets": [],
    }
    
    # Extract variables
    templating = data.get("templating", {})
    for var in templating.get("list", []):
        result["variables"].append({
            "name": var.get("name", ""),
            "type": var.get("type", ""),
            "label": var.get("label", ""),
            "query": var.get("query", ""),
        })
    
    # Extract panels (including nested)
    def process_panels(panels_list: list):
        for panel in panels_list:
            if panel.get("type") == "row":
                # Add row as a widget
                result["widgets"].append({
                    "id": panel.get("id"),
                    "title": panel.get("title", ""),
                    "type": "row",
                    "collapsed": panel.get("collapsed", False),
                })
                # Process nested panels
                nested = panel.get("panels", [])
                if nested:
                    process_panels(nested)
            else:
                result["widgets"].append(extract_widget_info(panel))
    
    process_panels(data.get("panels", []))
    
    return result


def get_single_widget(json_path: Path, widget_id: int) -> Optional[dict]:
    """Get info for a single widget by ID."""
    all_data = extract_all_widgets(json_path)
    for widget in all_data["widgets"]:
        if widget.get("id") == widget_id:
            return widget
    return None


def main():
    if len(sys.argv) < 2:
        print("Usage:")
        print("  grafana-widgets.py <dashboard.json>                    # All widgets to stdout")
        print("  grafana-widgets.py <dashboard.json> -o <output.yaml>   # All widgets to YAML file")
        print("  grafana-widgets.py <dashboard.json> <widget_id>        # Single widget")
        print("  grafana-widgets.py <dashboard.json> --list             # List widget IDs and titles")
        sys.exit(1)
    
    json_path = Path(sys.argv[1])
    
    if not json_path.exists():
        print(f"Error: File not found: {json_path}")
        sys.exit(1)
    
    # Check for output file option
    output_file = None
    args = sys.argv[2:]
    if "-o" in args:
        idx = args.index("-o")
        if idx + 1 < len(args):
            output_file = Path(args[idx + 1])
            args = args[:idx] + args[idx + 2:]
    
    if args and args[0] == "--list":
        # List mode: show ID and title only
        data = extract_all_widgets(json_path)
        print(f"Dashboard: {data['dashboard']['title']} ({data['dashboard']['uid']})")
        print("-" * 60)
        for w in data["widgets"]:
            prefix = "📁" if w["type"] == "row" else "📊"
            print(f"{prefix} [{w['id']:>3}] {w['title']} ({w['type']})")
    elif args and args[0].isdigit():
        # Single widget mode
        widget_id = int(args[0])
        widget = get_single_widget(json_path, widget_id)
        if widget:
            output_data(widget, output_file)
        else:
            print(f"Widget with ID {widget_id} not found")
            sys.exit(1)
    else:
        # Full output
        data = extract_all_widgets(json_path)
        output_data(data, output_file)


def output_data(data: dict, output_file: Optional[Path]):
    """Output data as YAML to file or JSON to stdout."""
    if output_file:
        if not HAS_YAML:
            print("Error: PyYAML not installed. Run: pip install pyyaml")
            sys.exit(1)
        
        with open(output_file, "w") as f:
            yaml.dump(data, f, default_flow_style=False, allow_unicode=True, sort_keys=False)
        print(f"Written to: {output_file}")
    else:
        # Default to JSON on stdout
        print(json.dumps(data, indent=2))


if __name__ == "__main__":
    main()
