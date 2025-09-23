#!/bin/bash

# Quick Start Script for Friendly Octo Lamp
# 빠른 시작 스크립트

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

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

# Banner
echo "🐙💡 Friendly Octo Lamp - Quick Start"
echo "===================================="
echo ""

# Check prerequisites
check_prerequisites() {
    log_info "Checking prerequisites..."
    
    # Check Docker
    if ! command -v docker >/dev/null 2>&1; then
        log_error "Docker is not installed. Please install Docker first."
        exit 1
    fi
    
    # Check Docker Compose
    if ! docker compose version >/dev/null 2>&1 && ! command -v docker-compose >/dev/null 2>&1; then
        log_error "Docker Compose is not available. Please install Docker Compose."
        exit 1
    fi
    
    # Check if Docker is running
    if ! docker info >/dev/null 2>&1; then
        log_error "Docker is not running. Please start Docker and try again."
        exit 1
    fi
    
    log_success "All prerequisites met!"
}

# Show menu
show_menu() {
    echo ""
    echo "Please choose an option:"
    echo "1) Local Development (npm start)"
    echo "2) Single Docker Container"
    echo "3) Full Docker Compose (with Redis & Nginx)"
    echo "4) Run Tests"
    echo "5) Build Only"
    echo "6) Clean Up"
    echo "0) Exit"
    echo ""
    read -p "Enter your choice [0-6]: " choice
}

# Local development
start_local() {
    log_info "Starting local development server..."
    
    if [ ! -d "node_modules" ]; then
        log_info "Installing dependencies..."
        npm install
    fi
    
    log_info "Starting application on http://localhost:3000"
    npm start
}

# Single container
start_single_container() {
    log_info "Building and starting single Docker container..."
    ./scripts/docker-build.sh
}

# Docker compose
start_compose() {
    log_info "Starting full Docker Compose stack..."
    ./scripts/docker-compose.sh start
}

# Run tests
run_tests() {
    log_info "Running tests..."
    
    if [ ! -d "node_modules" ]; then
        log_info "Installing dependencies..."
        npm install
    fi
    
    npm test
}

# Build only
build_only() {
    log_info "Building Docker image..."
    ./scripts/docker-build.sh build
}

# Clean up
cleanup() {
    log_info "Cleaning up containers and images..."
    ./scripts/docker-compose.sh cleanup
    ./scripts/docker-build.sh cleanup
    log_success "Cleanup completed!"
}

# Main execution
main() {
    check_prerequisites
    
    while true; do
        show_menu
        
        case $choice in
            1)
                start_local
                break
                ;;
            2)
                start_single_container
                break
                ;;
            3)
                start_compose
                break
                ;;
            4)
                run_tests
                ;;
            5)
                build_only
                ;;
            6)
                cleanup
                ;;
            0)
                log_info "Goodbye! 👋"
                exit 0
                ;;
            *)
                log_error "Invalid option. Please try again."
                ;;
        esac
    done
}

# Handle direct arguments
case "${1:-}" in
    "local")
        check_prerequisites
        start_local
        ;;
    "docker")
        check_prerequisites
        start_single_container
        ;;
    "compose")
        check_prerequisites
        start_compose
        ;;
    "test")
        check_prerequisites
        run_tests
        ;;
    "build")
        check_prerequisites
        build_only
        ;;
    "clean")
        check_prerequisites
        cleanup
        ;;
    *)
        main
        ;;
esac