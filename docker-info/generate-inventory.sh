#!/bin/bash

# Docker Image Information Generator
set -euo pipefail

REGISTRY="${1:-docker.io}"
PATTERN="${2:-*}"
INCLUDE_VULNS="${3:-true}"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

echo "=== Docker Image Information Generator ==="
echo "Registry: $REGISTRY"
echo "Pattern: $PATTERN"
echo "Include Vulnerabilities: $INCLUDE_VULNS"
echo "Timestamp: $TIMESTAMP"
echo ""

# Create inventory file
INVENTORY_FILE="docker-info/images/inventory-$(date +%Y%m%d).json"

cat > "$INVENTORY_FILE" << EOL
{
  "metadata": {
    "generated_at": "$TIMESTAMP",
    "registry": "$REGISTRY",
    "pattern": "$PATTERN",
    "scan_type": "automated",
    "generator": "github-actions"
  },
  "images": [],
  "summary": {
    "total_images": 0,
    "vulnerable_images": 0,
    "critical_vulnerabilities": 0,
    "high_vulnerabilities": 0,
    "medium_vulnerabilities": 0,
    "low_vulnerabilities": 0
  }
}
EOL

# Common base images to scan
COMMON_IMAGES=(
  "alpine:latest"
  "ubuntu:latest"
  "debian:latest"
  "nginx:latest"
  "node:latest"
  "python:latest"
  "openjdk:latest"
  "postgres:latest"
  "redis:latest"
  "mongo:latest"
)

# Generate image information for each common image
for image in "${COMMON_IMAGES[@]}"; do
  echo "Processing image: $image"
  
  # Pull image metadata
  if docker pull "$image" 2>/dev/null; then
    IMAGE_ID=$(docker images "$image" --format "{{.ID}}" | head -1)
    SIZE=$(docker images "$image" --format "{{.Size}}" | head -1)
    CREATED=$(docker images "$image" --format "{{.CreatedAt}}" | head -1)
    
    # Create individual image info file
    IMAGE_INFO_FILE="docker-info/images/${image//[:\/]/_}-info.json"
    
    cat > "$IMAGE_INFO_FILE" << EOL
{
  "image": "$image",
  "image_id": "$IMAGE_ID",
  "size": "$SIZE",
  "created": "$CREATED",
  "registry": "$REGISTRY",
  "scanned_at": "$TIMESTAMP",
  "architectures": [],
  "layers": [],
  "vulnerabilities": {
    "total": 0,
    "critical": 0,
    "high": 0,
    "medium": 0,
    "low": 0,
    "details": []
  },
  "dependencies": [],
  "security_scan": {
    "trivy_scan": null,
    "docker_scout_scan": null
  }
}
EOL
    
    # Get image manifest for architecture info
    if command -v docker &> /dev/null; then
      docker inspect "$image" > "docker-info/images/${image//[:\/]/_}-inspect.json" 2>/dev/null || true
    fi
    
    echo "  ✓ Generated info for $image"
  else
    echo "  ✗ Failed to pull $image"
  fi
done

echo ""
echo "=== Image inventory generation completed ==="
echo "Files created in docker-info/images/"
ls -la docker-info/images/
