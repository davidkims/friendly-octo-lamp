#!/usr/bin/env python3
import os, yaml, json, logging
from pathlib import Path
from datetime import datetime

logging.basicConfig(level=logging.INFO, format='[%(asctime)s] %(levelname)s: %(message)s')
log = logging.getLogger("analyzer")

class Analyzer:
    def __init__(self, registry="docker.io"):
        self.registry = registry
        self.root = Path.cwd()
        self.out = {
            "dockerfiles": [], "compose_files": [], "kubernetes_manifests": [], "helm_charts": [],
            "summary": {"total_files": 0, "outdated_images": 0, "security_issues": 0, "recommendations": []},
            "meta": {"registry": registry, "generated_at": datetime.utcnow().isoformat()+"Z"}
        }

    def _echo(self, msg): log.info(msg)

    def scan(self):
        self._echo("Scanning repository for container files")
        for p in self.root.rglob("Dockerfile*"):
            if p.is_file(): self.out["dockerfiles"].append({"file": str(p)})
        for pat in ("docker-compose*.yml","docker-compose*.yaml"):
            for p in self.root.rglob(pat): self.out["compose_files"].append({"file": str(p)})
        for p in self.root.rglob("*.yml"):
            if any(x in str(p) for x in ("k8s","kubernetes","manifests")): self.out["kubernetes_manifests"].append({"file": str(p)})
        for p in self.root.rglob("*.yaml"):
            if any(x in str(p) for x in ("k8s","kubernetes","manifests")): self.out["kubernetes_manifests"].append({"file": str(p)})
        for p in self.root.rglob("Chart.yaml"): self.out["helm_charts"].append({"file": str(p)})
        self.out["summary"]["total_files"] = sum(len(self.out[k]) for k in ("dockerfiles","compose_files","kubernetes_manifests","helm_charts"))
        self._echo(f"Found {self.out['summary']['total_files']} container-related files")
        return self.out

if __name__ == "__main__":
    import argparse
    ap = argparse.ArgumentParser()
    ap.add_argument("--registry", default="docker.io")
    ap.add_argument("--output", default="container-management/reports/container-analysis.json")
    args = ap.parse_args()
    a = Analyzer(registry=args.registry)
    res = a.scan()
    Path(args.output).parent.mkdir(parents=True, exist_ok=True)
    with open(args.output, "w") as f: json.dump(res, f, indent=2)
    print(f"Analysis complete: {args.output}")
