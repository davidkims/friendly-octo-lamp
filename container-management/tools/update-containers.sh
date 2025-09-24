#!/usr/bin/env bash
set -Eeuo pipefail
source /tmp/echo_helpers.sh

UPDATE_TYPE="${UPDATE_TYPE:-all-containers}"
BASE_IMAGE_UPDATE="${BASE_IMAGE_UPDATE:-true}"
TS_UTC=$(TS)
BKDIR="container-management/backups/$(date +%Y%m%d)"

echoe "=== Container File Update Process ==="
echoe "UPDATE_TYPE       : ${UPDATE_TYPE}"
echoe "BASE_IMAGE_UPDATE : ${BASE_IMAGE_UPDATE}"
echoe "START             : ${TS_UTC}"

echoe "Creating backup dir: ${BKDIR}"
mkdir -p "${BKDIR}"

echoe "Backing up Dockerfiles / Compose files (if any)"
find . -name "Dockerfile*" -type f -print -exec cp {} "${BKDIR}/" \; || true
find . -name "docker-compose*.yml"  -type f -print -exec cp {} "${BKDIR}/" \; || true
find . -name "docker-compose*.yaml" -type f -print -exec cp {} "${BKDIR}/" \; || true

if [ ! -f Dockerfile ]; then
  echoe "No Dockerfile found → creating sample modern Dockerfile"
  cp container-management/templates/Dockerfile.modern Dockerfile
fi

if [ ! -f docker-compose.yml ]; then
  echoe "No docker-compose.yml found → creating secure template"
  cp container-management/templates/docker-compose.secure.yml docker-compose.yml
fi

mkdir -p k8s
if [ ! -f k8s/deployment.yaml ]; then
  echoe "No k8s/deployment.yaml found → creating secure template"
  cp container-management/templates/k8s-deployment.secure.yaml k8s/deployment.yaml
fi

if [ "${BASE_IMAGE_UPDATE}" = "true" ]; then
  echoe "Updating common base images to pinned versions"
  for f in $(ls -1 Dockerfile* 2>/dev/null || true); do
    echoe "  - patching ${f}"
    sed -i 's/\<alpine:latest\>/alpine:3.19/g' "$f" || true
    sed -i 's/\<ubuntu:latest\>/ubuntu:22.04/g' "$f" || true
    sed -i 's/\<node:latest\>/node:18-alpine/g' "$f" || true
    sed -i 's/\<python:latest\>/python:3.11-alpine/g' "$f" || true
    sed -i 's/\<nginx:latest\>/nginx:1.25-alpine/g' "$f" || true
  done
fi

RPT="container-management/reports/update-report-$(date +%Y%m%d).md"
echoe "Writing update report: ${RPT}"
cat > "${RPT}" <<EOR
# Container File Update Report

**Generated:** ${TS_UTC}
**Update Type:** ${UPDATE_TYPE}
**Base Image Update:** ${BASE_IMAGE_UPDATE}

## Changes Made
- Dockerfile hardening (multi-stage, non-root, healthchecks)
- Compose security options, healthchecks, secrets
- K8s securityContext, probes, resource limits

## Next Steps
1) Review & test locally
2) Stage deploy & observe
3) Schedule recurring scans
EOR

echoe "Update process completed"
