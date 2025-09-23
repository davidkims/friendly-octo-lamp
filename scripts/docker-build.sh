#!/bin/bash

# Docker Build and Deploy Script
# This script builds the Docker image and creates containers

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
IMAGE_NAME="friendly-octo-lamp"
CONTAINER_NAME="friendly-octo-lamp-container"
PORT=3000

# Functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Docker is running
check_docker() {
    log_info "Checking Docker status..."
    if ! docker info >/dev/null 2>&1; then
        log_error "Docker is not running. Please start Docker and try again."
        exit 1
    fi
    log_success "Docker is running"
}

# Clean up existing containers and images
cleanup() {
    log_info "Cleaning up existing containers and images..."
    
    # Stop and remove container if it exists
    if docker ps -a --format 'table {{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
        log_info "Stopping and removing existing container: ${CONTAINER_NAME}"
        docker stop ${CONTAINER_NAME} >/dev/null 2>&1 || true
        docker rm ${CONTAINER_NAME} >/dev/null 2>&1 || true
    fi
    
    # Remove image if it exists
    if docker images --format 'table {{.Repository}}:{{.Tag}}' | grep -q "^${IMAGE_NAME}:latest$"; then
        log_info "Removing existing image: ${IMAGE_NAME}:latest"
        docker rmi ${IMAGE_NAME}:latest >/dev/null 2>&1 || true
    fi
    
    log_success "Cleanup completed"
}

# Build Docker image
build_image() {
    log_info "Building Docker image: ${IMAGE_NAME}:latest"
    
    if docker build -t ${IMAGE_NAME}:latest .; then
        log_success "Docker image built successfully"
    else
        log_error "Failed to build Docker image"
        exit 1
    fi
}

# Run container
run_container() {
    log_info "Running Docker container: ${CONTAINER_NAME}"
    
    if docker run -d \
        --name ${CONTAINER_NAME} \
        -p ${PORT}:${PORT} \
        --restart unless-stopped \
        ${IMAGE_NAME}:latest; then
        log_success "Container started successfully"
        log_info "Application is available at: http://localhost:${PORT}"
    else
        log_error "Failed to start container"
        exit 1
    fi
}

# Show container status
show_status() {
    log_info "Container status:"
    docker ps --filter "name=${CONTAINER_NAME}"
    
    echo ""
    log_info "Container logs (last 20 lines):"
    docker logs --tail 20 ${CONTAINER_NAME}
}

# Main execution
main() {
    echo "🐙💡 Friendly Octo Lamp - Docker Build & Deploy Script"
    echo "=================================================="
    
    check_docker
    cleanup
    build_image
    run_container
    show_status
    
    echo ""
    log_success "Deployment completed successfully!"
    log_info "Use 'docker logs ${CONTAINER_NAME}' to view logs"
    log_info "Use 'docker stop ${CONTAINER_NAME}' to stop the container"
}

# Handle script arguments
case "${1:-}" in
    "cleanup")
        check_docker
        cleanup
        ;;
    "build")
        check_docker
        build_image
        ;;
    "run")
        check_docker
        run_container
        ;;
    "status")
        show_status
        ;;
    *)
        main
        ;;
esac