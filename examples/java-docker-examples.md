# Java + Docker 실습 예제

## 목차
1. [간단한 Java 애플리케이션 Dockerizing](#간단한-java-애플리케이션-dockerizing)
2. [Spring Boot 웹 애플리케이션](#spring-boot-웹-애플리케이션)
3. [Java + MySQL + Redis 마이크로서비스](#java--mysql--redis-마이크로서비스)
4. [멀티 스테이지 빌드 예제](#멀티-스테이지-빌드-예제)
5. [Docker Compose로 전체 스택 구성](#docker-compose로-전체-스택-구성)

## 간단한 Java 애플리케이션 Dockerizing

### Java 애플리케이션 작성

#### HelloWorld.java
```java
public class HelloWorld {
    public static void main(String[] args) {
        System.out.println("=================================");
        System.out.println("  Docker에서 실행되는 Java 앱!");
        System.out.println("=================================");
        
        // 환경 변수 읽기
        String environment = System.getenv("ENVIRONMENT");
        if (environment != null) {
            System.out.println("현재 환경: " + environment);
        }
        
        // 시스템 정보 출력
        System.out.println("Java 버전: " + System.getProperty("java.version"));
        System.out.println("OS: " + System.getProperty("os.name"));
        System.out.println("사용자: " + System.getProperty("user.name"));
        
        // 무한 루프 (컨테이너가 종료되지 않도록)
        while (true) {
            try {
                Thread.sleep(30000); // 30초 대기
                System.out.println("애플리케이션이 정상 동작 중... " + new java.util.Date());
            } catch (InterruptedException e) {
                System.out.println("애플리케이션 종료 중...");
                break;
            }
        }
    }
}
```

#### Dockerfile
```dockerfile
# JDK를 사용한 컴파일 단계
FROM openjdk:17-jdk-slim AS build

WORKDIR /app

# 소스 파일 복사
COPY HelloWorld.java .

# Java 컴파일
RUN javac HelloWorld.java

# 실행 환경 (JRE만 사용)
FROM openjdk:17-jre-slim

WORKDIR /app

# 컴파일된 클래스 파일 복사
COPY --from=build /app/HelloWorld.class .

# 환경 변수 설정
ENV ENVIRONMENT=production

# 애플리케이션 실행
CMD ["java", "HelloWorld"]
```

#### 빌드 및 실행
```bash
# 이미지 빌드
docker build -t java-hello-world .

# 컨테이너 실행
docker run -d --name hello-app java-hello-world

# 로그 확인
docker logs -f hello-app

# 환경 변수와 함께 실행
docker run -d --name hello-app-dev -e ENVIRONMENT=development java-hello-world
```

## Spring Boot 웹 애플리케이션

### 프로젝트 구조
```
spring-boot-app/
├── src/
│   └── main/
│       └── java/
│           └── com/
│               └── example/
│                   └── demo/
│                       ├── DemoApplication.java
│                       └── controller/
│                           └── HelloController.java
├── pom.xml
├── Dockerfile
└── docker-compose.yml
```

### DemoApplication.java
```java
package com.example.demo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class DemoApplication {
    public static void main(String[] args) {
        SpringApplication.run(DemoApplication.class, args);
    }
}
```

### HelloController.java
```java
package com.example.demo.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;
import java.util.HashMap;
import java.util.Map;
import java.time.LocalDateTime;

@RestController
public class HelloController {
    
    @GetMapping("/")
    public Map<String, Object> home() {
        Map<String, Object> response = new HashMap<>();
        response.put("message", "Docker에서 실행되는 Spring Boot 애플리케이션입니다!");
        response.put("timestamp", LocalDateTime.now());
        response.put("version", "1.0.0");
        return response;
    }
    
    @GetMapping("/hello/{name}")
    public Map<String, Object> hello(@PathVariable String name) {
        Map<String, Object> response = new HashMap<>();
        response.put("greeting", "안녕하세요, " + name + "님!");
        response.put("timestamp", LocalDateTime.now());
        return response;
    }
    
    @GetMapping("/health")
    public Map<String, String> health() {
        Map<String, String> status = new HashMap<>();
        status.put("status", "UP");
        status.put("service", "demo-app");
        return status;
    }
}
```

### pom.xml
```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 
         http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    
    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>3.1.0</version>
        <relativePath/>
    </parent>
    
    <groupId>com.example</groupId>
    <artifactId>demo</artifactId>
    <version>1.0.0</version>
    <name>demo</name>
    <description>Docker Spring Boot Demo</description>
    
    <properties>
        <java.version>17</java.version>
    </properties>
    
    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-actuator</artifactId>
        </dependency>
        
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>
    </dependencies>
    
    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>
</project>
```

### Dockerfile (Spring Boot용)
```dockerfile
# 멀티 스테이지 빌드
FROM maven:3.8.6-openjdk-17 AS build

WORKDIR /app

# pom.xml 먼저 복사 (의존성 캐싱)
COPY pom.xml .
RUN mvn dependency:go-offline -B

# 소스 코드 복사 및 빌드
COPY src ./src
RUN mvn clean package -DskipTests

# 실행 환경
FROM openjdk:17-jre-slim

# 필요한 패키지 설치
RUN apt-get update && \
    apt-get install -y curl && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# JAR 파일 복사
COPY --from=build /app/target/*.jar app.jar

# 애플리케이션 사용자 생성
RUN groupadd -r appgroup && \
    useradd -r -g appgroup appuser && \
    chown appuser:appgroup /app

USER appuser

# 포트 노출
EXPOSE 8080

# 헬스체크
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
    CMD curl -f http://localhost:8080/health || exit 1

# JVM 옵션 설정
ENV JAVA_OPTS="-Xmx512m -Xms256m"

# 애플리케이션 실행
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]
```

### docker-compose.yml (단일 애플리케이션)
```yaml
version: '3.8'

services:
  app:
    build: .
    ports:
      - "8080:8080"
    environment:
      - SPRING_PROFILES_ACTIVE=docker
      - JAVA_OPTS=-Xmx512m -Xms256m
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8080/health"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 30s
    restart: unless-stopped
```

## Java + MySQL + Redis 마이크로서비스

### 향상된 Spring Boot 애플리케이션

#### application.yml
```yaml
spring:
  profiles:
    active: default
  datasource:
    url: jdbc:mysql://localhost:3306/demoapp
    username: appuser
    password: apppassword
    driver-class-name: com.mysql.cj.jdbc.Driver
  jpa:
    hibernate:
      ddl-auto: update
    show-sql: true
    properties:
      hibernate:
        dialect: org.hibernate.dialect.MySQL8Dialect
  redis:
    host: localhost
    port: 6379
    password:
    timeout: 2000

management:
  endpoints:
    web:
      exposure:
        include: health,info,metrics
  endpoint:
    health:
      show-details: always

logging:
  level:
    com.example.demo: DEBUG
  pattern:
    console: "%d{HH:mm:ss.SSS} [%thread] %-5level %logger{36} - %msg%n"

---
spring:
  profiles: docker
  datasource:
    url: jdbc:mysql://db:3306/demoapp
    username: appuser
    password: apppassword
  redis:
    host: redis
    port: 6379
```

#### User Entity
```java
package com.example.demo.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "users")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false)
    private String name;
    
    @Column(unique = true, nullable = false)
    private String email;
    
    @Column(name = "created_at")
    private LocalDateTime createdAt;
    
    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
    }
    
    // 생성자, getter, setter
    public User() {}
    
    public User(String name, String email) {
        this.name = name;
        this.email = email;
    }
    
    // getter와 setter 메서드들...
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
```

#### User Repository
```java
package com.example.demo.repository;

import com.example.demo.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByEmail(String email);
    boolean existsByEmail(String email);
}
```

#### Redis Service
```java
package com.example.demo.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;
import java.util.concurrent.TimeUnit;

@Service
public class CacheService {
    
    @Autowired
    private RedisTemplate<String, Object> redisTemplate;
    
    public void set(String key, Object value) {
        redisTemplate.opsForValue().set(key, value);
    }
    
    public void set(String key, Object value, long timeout, TimeUnit unit) {
        redisTemplate.opsForValue().set(key, value, timeout, unit);
    }
    
    public Object get(String key) {
        return redisTemplate.opsForValue().get(key);
    }
    
    public void delete(String key) {
        redisTemplate.delete(key);
    }
    
    public boolean hasKey(String key) {
        return Boolean.TRUE.equals(redisTemplate.hasKey(key));
    }
}
```

#### User Service
```java
package com.example.demo.service;

import com.example.demo.entity.User;
import com.example.demo.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Optional;
import java.util.concurrent.TimeUnit;

@Service
public class UserService {
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private CacheService cacheService;
    
    public List<User> findAll() {
        String cacheKey = "users:all";
        
        // 캐시에서 먼저 확인
        if (cacheService.hasKey(cacheKey)) {
            return (List<User>) cacheService.get(cacheKey);
        }
        
        // DB에서 조회 후 캐시에 저장
        List<User> users = userRepository.findAll();
        cacheService.set(cacheKey, users, 5, TimeUnit.MINUTES);
        
        return users;
    }
    
    public Optional<User> findById(Long id) {
        String cacheKey = "user:" + id;
        
        if (cacheService.hasKey(cacheKey)) {
            return Optional.of((User) cacheService.get(cacheKey));
        }
        
        Optional<User> user = userRepository.findById(id);
        user.ifPresent(u -> cacheService.set(cacheKey, u, 10, TimeUnit.MINUTES));
        
        return user;
    }
    
    public User save(User user) {
        User savedUser = userRepository.save(user);
        
        // 캐시 무효화
        cacheService.delete("users:all");
        if (savedUser.getId() != null) {
            cacheService.delete("user:" + savedUser.getId());
        }
        
        return savedUser;
    }
    
    public void deleteById(Long id) {
        userRepository.deleteById(id);
        
        // 캐시 무효화
        cacheService.delete("users:all");
        cacheService.delete("user:" + id);
    }
}
```

#### User Controller
```java
package com.example.demo.controller;

import com.example.demo.entity.User;
import com.example.demo.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

@RestController
@RequestMapping("/api/users")
public class UserController {
    
    @Autowired
    private UserService userService;
    
    @GetMapping
    public List<User> getAllUsers() {
        return userService.findAll();
    }
    
    @GetMapping("/{id}")
    public ResponseEntity<User> getUserById(@PathVariable Long id) {
        return userService.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }
    
    @PostMapping
    public User createUser(@RequestBody User user) {
        return userService.save(user);
    }
    
    @PutMapping("/{id}")
    public ResponseEntity<User> updateUser(@PathVariable Long id, @RequestBody User userDetails) {
        return userService.findById(id)
                .map(user -> {
                    user.setName(userDetails.getName());
                    user.setEmail(userDetails.getEmail());
                    return ResponseEntity.ok(userService.save(user));
                })
                .orElse(ResponseEntity.notFound().build());
    }
    
    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteUser(@PathVariable Long id) {
        return userService.findById(id)
                .map(user -> {
                    userService.deleteById(id);
                    Map<String, String> response = new HashMap<>();
                    response.put("message", "사용자가 삭제되었습니다.");
                    return ResponseEntity.ok(response);
                })
                .orElse(ResponseEntity.notFound().build());
    }
}
```

### 업데이트된 pom.xml
```xml
<dependencies>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
    
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-data-jpa</artifactId>
    </dependency>
    
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-data-redis</artifactId>
    </dependency>
    
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-actuator</artifactId>
    </dependency>
    
    <dependency>
        <groupId>mysql</groupId>
        <artifactId>mysql-connector-java</artifactId>
        <version>8.0.33</version>
    </dependency>
    
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-test</artifactId>
        <scope>test</scope>
    </dependency>
</dependencies>
```

## Docker Compose로 전체 스택 구성

### docker-compose.yml (전체 스택)
```yaml
version: '3.8'

services:
  app:
    build:
      context: .
      dockerfile: Dockerfile
    ports:
      - "8080:8080"
    environment:
      - SPRING_PROFILES_ACTIVE=docker
      - SPRING_DATASOURCE_URL=jdbc:mysql://db:3306/demoapp
      - SPRING_DATASOURCE_USERNAME=appuser
      - SPRING_DATASOURCE_PASSWORD=apppassword
      - SPRING_REDIS_HOST=redis
      - JAVA_OPTS=-Xmx512m -Xms256m
    depends_on:
      db:
        condition: service_healthy
      redis:
        condition: service_started
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8080/actuator/health"]
      interval: 30s
      timeout: 10s
      retries: 5
      start_period: 60s
    restart: unless-stopped
    networks:
      - app-network
    volumes:
      - app-logs:/app/logs

  db:
    image: mysql:8.0
    environment:
      - MYSQL_ROOT_PASSWORD=rootpassword
      - MYSQL_DATABASE=demoapp
      - MYSQL_USER=appuser
      - MYSQL_PASSWORD=apppassword
      - MYSQL_CHARACTER_SET_SERVER=utf8mb4
      - MYSQL_COLLATION_SERVER=utf8mb4_unicode_ci
    ports:
      - "3306:3306"
    volumes:
      - mysql-data:/var/lib/mysql
      - ./docker/mysql/init:/docker-entrypoint-initdb.d
      - ./docker/mysql/conf.d:/etc/mysql/conf.d
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost", "-u", "appuser", "-papppassword"]
      interval: 10s
      timeout: 5s
      retries: 10
      start_period: 30s
    restart: unless-stopped
    networks:
      - app-network

  redis:
    image: redis:7-alpine
    command: redis-server --appendonly yes --requirepass redispassword
    ports:
      - "6379:6379"
    volumes:
      - redis-data:/data
      - ./docker/redis/redis.conf:/usr/local/etc/redis/redis.conf
    healthcheck:
      test: ["CMD", "redis-cli", "auth", "redispassword", "ping"]
      interval: 10s
      timeout: 5s
      retries: 3
    restart: unless-stopped
    networks:
      - app-network

  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./docker/nginx/nginx.conf:/etc/nginx/nginx.conf:ro
      - ./docker/nginx/ssl:/etc/nginx/ssl:ro
      - nginx-logs:/var/log/nginx
    depends_on:
      - app
    restart: unless-stopped
    networks:
      - app-network

  # 모니터링 도구들
  prometheus:
    image: prom/prometheus:latest
    ports:
      - "9090:9090"
    volumes:
      - ./docker/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml:ro
      - prometheus-data:/prometheus
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'
      - '--web.console.libraries=/etc/prometheus/console_libraries'
      - '--web.console.templates=/etc/prometheus/consoles'
    networks:
      - monitoring-network
      - app-network

  grafana:
    image: grafana/grafana:latest
    ports:
      - "3000:3000"
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin123
    volumes:
      - grafana-data:/var/lib/grafana
      - ./docker/grafana/dashboards:/etc/grafana/provisioning/dashboards
      - ./docker/grafana/datasources:/etc/grafana/provisioning/datasources
    networks:
      - monitoring-network

volumes:
  mysql-data:
    driver: local
  redis-data:
    driver: local
  prometheus-data:
    driver: local
  grafana-data:
    driver: local
  app-logs:
    driver: local
  nginx-logs:
    driver: local

networks:
  app-network:
    driver: bridge
  monitoring-network:
    driver: bridge
```

### Nginx 설정
```nginx
# docker/nginx/nginx.conf
events {
    worker_connections 1024;
}

http {
    upstream app {
        server app:8080;
    }
    
    server {
        listen 80;
        server_name localhost;
        
        location / {
            proxy_pass http://app;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }
        
        location /health {
            access_log off;
            proxy_pass http://app/actuator/health;
        }
    }
}
```

### 실행 및 테스트

#### 전체 스택 시작
```bash
# 전체 서비스 시작
docker-compose up -d

# 서비스 상태 확인
docker-compose ps

# 로그 확인
docker-compose logs -f app

# 특정 서비스 재시작
docker-compose restart app
```

#### API 테스트
```bash
# 사용자 생성
curl -X POST http://localhost:8080/api/users \
  -H "Content-Type: application/json" \
  -d '{"name":"김자바","email":"kim@example.com"}'

# 사용자 목록 조회
curl http://localhost:8080/api/users

# 특정 사용자 조회
curl http://localhost:8080/api/users/1

# 헬스체크
curl http://localhost:8080/actuator/health
```

#### 데이터베이스 연결 확인
```bash
# MySQL 컨테이너에 접속
docker-compose exec db mysql -u appuser -papppassword demoapp

# 테이블 확인
SHOW TABLES;
SELECT * FROM users;
```

#### Redis 연결 확인
```bash
# Redis 컨테이너에 접속
docker-compose exec redis redis-cli -a redispassword

# 캐시 확인
KEYS *
GET users:all
```

이 예제들은 Java와 Docker를 실제 프로젝트에서 어떻게 활용하는지 보여줍니다. 단순한 Hello World부터 완전한 마이크로서비스 스택까지 점진적으로 발전시킬 수 있습니다.