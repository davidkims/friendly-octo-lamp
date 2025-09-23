# friendly-octo-lamp

A sample Java Spring Boot application with comprehensive Dependabot monitoring for Docker, Java, and Maven dependencies.

## Features

- **24/7 Dependency Monitoring**: Dependabot configured for daily updates
- **Java Spring Boot Application**: RESTful web service with health endpoints
- **Docker Support**: Multi-stage Docker build with health checks
- **Maven Build**: Standard Java project structure with Maven
- **CI/CD Pipeline**: GitHub Actions workflow for automated testing
- **Security Scanning**: Trivy vulnerability scanner integration

## Dependabot Configuration

This repository is configured with Dependabot to monitor and automatically update:

- **Maven Dependencies**: Daily monitoring of Java dependencies
- **Docker Dependencies**: Daily monitoring of base images and Docker dependencies  
- **GitHub Actions**: Daily monitoring of workflow dependencies

### Monitoring Schedule
- **Frequency**: Daily at 09:00 UTC
- **Auto-merge**: Disabled (requires manual review)
- **Security Updates**: High priority
- **Pull Request Limit**: 10 for Maven/Docker, 5 for GitHub Actions

## Getting Started

### Prerequisites
- Java 17+
- Maven 3.6+
- Docker (optional)

### Building the Application

```bash
# Build with Maven
mvn clean compile

# Run tests
mvn test

# Create JAR package
mvn clean package
```

### Running the Application

```bash
# Run with Maven
mvn spring-boot:run

# Or run the JAR directly
java -jar target/friendly-octo-lamp-1.0.0.jar
```

### Docker Support

```bash
# Build Docker image
docker build -t friendly-octo-lamp .

# Run with Docker
docker run -p 8080:8080 friendly-octo-lamp

# Run with docker-compose
docker-compose up
```

## API Endpoints

- `GET /` - Hello world endpoint
- `GET /health` - Health check endpoint

## Dependencies Monitored

The following dependencies are automatically monitored for updates:

### Java/Maven Dependencies
- Spring Boot Framework
- Jackson JSON processing
- JUnit Testing Framework
- SLF4J Logging
- Maven plugins and build tools

### Docker Dependencies
- Base images (OpenJDK, Maven)
- Multi-stage build dependencies

### GitHub Actions
- Checkout action
- Java setup action
- Cache action
- Security scanning actions

## License

Licensed under the Apache License, Version 2.0
