#!/bin/bash

# Docker Compose Management Script
# This script manages the docker-compose services

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

# Check if docker-compose is available
check_compose() {
    if command -v docker-compose >/dev/null 2>&1; then
        COMPOSE_CMD="docker-compose"
    elif docker compose version >/dev/null 2>&1; then
        COMPOSE_CMD="docker compose"
    else
        log_error "Docker Compose is not available. Please install Docker Compose."
        exit 1
    fi
    log_success "Using: $COMPOSE_CMD"
}

# Start services
start_services() {
    log_info "Starting all services with Docker Compose..."
    $COMPOSE_CMD up -d --build
    log_success "Services started successfully"
    show_status
}

# Stop services
stop_services() {
    log_info "Stopping all services..."
    $COMPOSE_CMD down
    log_success "Services stopped successfully"
}

# Restart services
restart_services() {
    log_info "Restarting all services..."
    $COMPOSE_CMD restart
    log_success "Services restarted successfully"
}

# Show service status
show_status() {
    log_info "Service status:"
    $COMPOSE_CMD ps
    
    echo ""
    log_info "Service logs (last 10 lines each):"
    $COMPOSE_CMD logs --tail=10
}

# Show logs
show_logs() {
    local service=${1:-}
    if [ -n "$service" ]; then
        log_info "Showing logs for service: $service"
        $COMPOSE_CMD logs -f $service
    else
        log_info "Showing logs for all services:"
        $COMPOSE_CMD logs -f
    fi
}

# Build services
build_services() {
    log_info "Building all services..."
    $COMPOSE_CMD build --no-cache
    log_success "Build completed successfully"
}

# Pull latest images
pull_images() {
    log_info "Pulling latest images..."
    $COMPOSE_CMD pull
    log_success "Images pulled successfully"
}

# Clean up
cleanup() {
    log_info "Cleaning up containers, networks, and volumes..."
    $COMPOSE_CMD down -v --remove-orphans
    docker system prune -f
    log_success "Cleanup completed"
}

# Health check
health_check() {
    log_info "Performing health check..."
    
    # Check if app is responding
    if curl -f http://localhost:3000/health >/dev/null 2>&1; then
        log_success "Application is healthy"
    else
        log_error "Application health check failed"
    fi
    
    # Check if nginx is responding
    if curl -f http://localhost:80/nginx-health >/dev/null 2>&1; then
        log_success "Nginx is healthy"
    else
        log_warning "Nginx health check failed"
    fi
}

# Show help
show_help() {
    echo "🐙💡 Friendly Octo Lamp - Docker Compose Management Script"
    echo "========================================================="
    echo ""
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  start     Start all services"
    echo "  stop      Stop all services"
    echo "  restart   Restart all services"
    echo "  status    Show service status"
    echo "  logs      Show logs for all services"
    echo "  logs [service]  Show logs for specific service"
    echo "  build     Build all services"
    echo "  pull      Pull latest images"
    echo "  cleanup   Clean up containers, networks, and volumes"
    echo "  health    Perform health check"
    echo "  help      Show this help message"
    echo ""
    echo "Services:"
    echo "  app       Main application"
    echo "  redis     Redis cache"
    echo "  nginx     Nginx reverse proxy"
}

# Main execution
main() {
    check_compose
    
    case "${1:-start}" in
        "start")
            start_services
            ;;
        "stop")
            stop_services
            ;;
        "restart")
            restart_services
            ;;
        "status")
            show_status
            ;;
        "logs")
            show_logs "${2:-}"
            ;;
        "build")
            build_services
            ;;
        "pull")
            pull_images
            ;;
        "cleanup")
            cleanup
            ;;
        "health")
            health_check
            ;;
        "help"|"-h"|"--help")
            show_help
            ;;
        *)
            log_error "Unknown command: $1"
            show_help
            exit 1
            ;;
    esac
}

main "$@"