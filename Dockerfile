# Multi-stage build for Java application
FROM maven:3.9.5-openjdk-17-slim AS build

# Set working directory
WORKDIR /app

# Copy Maven configuration
COPY pom.xml .

# Copy source code
COPY src ./src

# Build the application
RUN mvn clean package -DskipTests

# Runtime stage
FROM openjdk:17-jdk-slim

# Set working directory
WORKDIR /app

# Copy the built application from build stage
COPY --from=build /app/target/friendly-octo-lamp-1.0.0.jar app.jar

# Expose port
EXPOSE 8080

# Define health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8080/health || exit 1

# Run the application
CMD ["java", "-jar", "app.jar"]