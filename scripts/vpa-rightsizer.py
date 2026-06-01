#!/usr/bin/env python3
"""
VPA Right-Sizer

Reads VPA target recommendations and sets deployment resources
with a configurable overhead multiplier (default: 1.5x).

Usage:
  ./vpa-rightsizer.py [options] [namespace]

Options:
  --dry-run       Preview changes without applying
  --overhead N    Overhead multiplier (default: 1.5)
  --vpa NAME      Target a specific VPA (default: all in namespace)

Examples:
  ./vpa-rightsizer.py dev
  ./vpa-rightsizer.py --dry-run dev
  ./vpa-rightsizer.py --overhead 2.0 dev
  ./vpa-rightsizer.py --vpa vpa-dev-web-frontend dev

Logic:
  request = VPA target recommendation
  limit   = target × overhead
  VPA minAllowed = target × 0.5
  VPA maxAllowed = target × 3
"""

import argparse
import json
import math
import subprocess
import sys


def parse_cpu(val: str) -> int:
    """Parse CPU string to millicores."""
    if val.endswith("m"):
        return int(val[:-1])
    if val.endswith("n"):
        return max(int(val[:-1]) // 1_000_000, 1)
    return int(float(val) * 1000)


def parse_mem(val: str) -> int:
    """Parse memory string to MiB."""
    if val.endswith("Gi"):
        return int(float(val[:-2]) * 1024)
    if val.endswith("Mi"):
        return int(val[:-2])
    if val.endswith("Ki"):
        return max(int(float(val[:-2]) / 1024), 1)
    if val.endswith("G"):
        return int(float(val[:-1]) * 1000)
    if val.endswith("M"):
        return int(val[:-1])
    return max(int(int(val) / 1048576), 1)


def kubectl(*args) -> tuple[bool, str]:
    """Run a kubectl command, return (success, output)."""
    result = subprocess.run(
        ["kubectl", *args],
        capture_output=True, text=True
    )
    output = result.stdout.strip() or result.stderr.strip()
    return result.returncode == 0, output


def kubectl_json(*args) -> dict:
    """Run kubectl and parse JSON output."""
    ok, output = kubectl(*args, "-o", "json")
    if not ok:
        print(f"Error: {output}", file=sys.stderr)
        sys.exit(1)
    return json.loads(output)


def kubectl_patch(resource: str, name: str, namespace: str, patch: dict) -> tuple[bool, str]:
    """Apply a merge patch. Uses --type=merge for VPA (doesn't support strategic)."""
    patch_type = "merge" if resource == "vpa" else "strategic"
    return kubectl(
        "patch", resource, name,
        "-n", namespace,
        f"--type={patch_type}",
        "-p", json.dumps(patch)
    )


def main():
    parser = argparse.ArgumentParser(description="VPA Right-Sizer")
    parser.add_argument("namespace", nargs="?", default="dev", help="Kubernetes namespace")
    parser.add_argument("--dry-run", action="store_true", help="Preview without applying")
    parser.add_argument("--overhead", type=float, default=1.5, help="Limit overhead multiplier")
    parser.add_argument("--vpa", dest="target_vpa", help="Target a specific VPA by name")
    args = parser.parse_args()

    print("━" * 56)
    print("VPA Right-Sizer")
    print("━" * 56)
    print(f"  Namespace:  {args.namespace}")
    print(f"  Overhead:   {args.overhead}x")
    print(f"  Dry run:    {args.dry_run}")
    if args.target_vpa:
        print(f"  Target VPA: {args.target_vpa}")
    print("━" * 56)
    print()

    # Fetch VPAs
    if args.target_vpa:
        vpa = kubectl_json("get", "vpa", args.target_vpa, "-n", args.namespace)
        items = [vpa]
    else:
        data = kubectl_json("get", "vpa", "-n", args.namespace)
        items = data.get("items", [])

    if not items:
        print("No VPAs found.")
        return

    total_saved_cpu = 0
    total_saved_mem = 0

    for vpa in items:
        name = vpa["metadata"]["name"]
        spec = vpa.get("spec", {})
        target_ref = spec.get("targetRef", {})
        target_kind = target_ref.get("kind", "Deployment")
        target_name = target_ref.get("name", "")

        recs = (
            vpa.get("status", {})
            .get("recommendation", {})
            .get("containerRecommendations", [])
        )

        if not recs:
            print(f"⚠️  {name}: no recommendation yet — skipping")
            print()
            continue

        print(f"┌─ {name} → {target_kind}/{target_name}")

        for rec in recs:
            container = rec["containerName"]
            target_cpu = parse_cpu(rec["target"]["cpu"])
            target_mem = parse_mem(rec["target"]["memory"])

            # Upper bound as proxy for current over-provisioning
            upper_cpu = parse_cpu(rec.get("upperBound", {}).get("cpu", rec["target"]["cpu"]))
            upper_mem = parse_mem(rec.get("upperBound", {}).get("memory", rec["target"]["memory"]))

            # Right-sized values
            req_cpu = max(target_cpu, 1)
            req_mem = max(target_mem, 8)
            lim_cpu = max(math.ceil(target_cpu * args.overhead), 2)
            lim_mem = max(math.ceil(target_mem * args.overhead), 16)

            # VPA bounds
            min_cpu = max(math.ceil(target_cpu * 0.5), 1)
            min_mem = max(math.ceil(target_mem * 0.5), 8)
            max_cpu = max(math.ceil(target_cpu * 3), lim_cpu)
            max_mem = max(math.ceil(target_mem * 3), lim_mem)

            # Savings estimate
            saved_cpu = max(upper_cpu - req_cpu, 0)
            saved_mem = max(upper_mem - req_mem, 0)
            total_saved_cpu += saved_cpu
            total_saved_mem += saved_mem

            print(f"│  Container: {container}")
            print(f"│    VPA target:    cpu={target_cpu}m  mem={target_mem}Mi")
            print(f"│    Right-sized:   requests=({req_cpu}m, {req_mem}Mi)  limits=({lim_cpu}m, {lim_mem}Mi)")
            print(f"│    VPA bounds:    min=({min_cpu}m, {min_mem}Mi)  max=({max_cpu}m, {max_mem}Mi)")

            if args.dry_run:
                print(f"│    📋 [DRY RUN] would patch {target_kind}/{target_name}")
            else:
                # Patch deployment
                deploy_patch = {
                    "spec": {"template": {"spec": {"containers": [{
                        "name": container,
                        "resources": {
                            "requests": {"cpu": f"{req_cpu}m", "memory": f"{req_mem}Mi"},
                            "limits": {"cpu": f"{lim_cpu}m", "memory": f"{lim_mem}Mi"},
                        },
                    }]}}}
                }
                ok, err = kubectl_patch(target_kind.lower(), target_name, args.namespace, deploy_patch)
                if ok:
                    print(f"│    ✅ Patched {target_kind}/{target_name}")
                else:
                    print(f"│    ❌ Deploy patch failed: {err}")

                # Patch VPA bounds
                vpa_patch = {
                    "spec": {"resourcePolicy": {"containerPolicies": [{
                        "containerName": container,
                        "minAllowed": {"cpu": f"{min_cpu}m", "memory": f"{min_mem}Mi"},
                        "maxAllowed": {"cpu": f"{max_cpu}m", "memory": f"{max_mem}Mi"},
                    }]}}
                }
                ok, err = kubectl_patch("vpa", name, args.namespace, vpa_patch)
                if ok:
                    print(f"│    ✅ Updated VPA bounds")
                else:
                    print(f"│    ❌ VPA patch failed: {err}")

        print("└─")
        print()

    # Summary
    print("━" * 56)
    print(f"Summary: {len(items)} VPA(s) processed")
    if total_saved_cpu > 0 or total_saved_mem > 0:
        print(f"Potential savings: ~{total_saved_cpu}m CPU, ~{total_saved_mem}Mi memory")
    print("━" * 56)


if __name__ == "__main__":
    main()
