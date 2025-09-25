#!/usr/bin/env bash
set -Eeuo pipefail
source /tmp/echo_helpers.sh
TS_UTC=$(TS)
RPT="container-management/reports/security-scan-$(date +%Y%m%d).json"
echoe "Start security scan @ ${TS_UTC}"

cat > "${RPT}" <<JSON
{ "scan_metadata": { "timestamp": "${TS_UTC}", "scanner": "container-security-scanner", "scan_type": "dockerfile_analysis" },
  "scanned_files": [], "security_findings": [], "recommendations": [], "summary": { "total_files": 0, "critical_issues": 0, "high_issues": 0, "medium_issues": 0, "low_issues": 0 } }
JSON

count=0
while IFS= read -r -d '' f; do
  count=$((count+1))
  echoe "Scanning $f"
  # simple checks
  grep -qE '^FROM .*:latest' "$f" && echoe "  ⚠ latest tag: $f" && true
  grep -qE '^USER ' "$f" || echoe "  ⚠ missing USER (non-root): $f"
  grep -qE '^HEALTHCHECK ' "$f" || echoe "  ⚠ missing HEALTHCHECK: $f"
  grep -qE '^ADD http' "$f" && echoe "  ⚠ ADD with URL: $f" || true
done < <(find . -name "Dockerfile*" -type f -print0)

jq --arg c "$count" '.summary.total_files = ($c|tonumber)' "${RPT}" > tmp.$$.json && mv tmp.$$.json "${RPT}"
echoe "Security scan finished (files=$count) → ${RPT}"
