# Docker 완전 가이드

## 목차
1. [Docker 소개](#docker-소개)
2. [Docker 설치](#docker-설치)
3. [Docker 기본 개념](#docker-기본-개념)
4. [Docker 명령어](#docker-명령어)
5. [Dockerfile 작성](#dockerfile-작성)
6. [Docker Compose](#docker-compose)
7. [Docker 네트워킹](#docker-네트워킹)
8. [Docker 볼륨](#docker-볼륨)
9. [Docker 보안](#docker-보안)
10. [실무 활용 및 베스트 프랙티스](#실무-활용-및-베스트-프랙티스)

## Docker 소개

### Docker란?
Docker는 애플리케이션을 컨테이너화하여 개발, 배포, 실행을 단순화하는 플랫폼입니다. 2013년에 출시되어 현재 가장 인기 있는 컨테이너 기술입니다.

### Docker의 장점
- **일관성**: 개발, 테스트, 운영 환경에서 동일한 실행 환경 제공
- **격리**: 각 컨테이너는 독립적인 실행 환경
- **효율성**: VM보다 가볍고 빠른 시작 시간
- **확장성**: 마이크로서비스 아키텍처에 최적화
- **이식성**: 어떤 환경에서든 동일하게 동작

### Docker vs Virtual Machine
| 특징 | Docker | Virtual Machine |
|------|--------|-----------------|
| 리소스 사용량 | 낮음 | 높음 |
| 시작 시간 | 초 단위 | 분 단위 |
| OS 공유 | 호스트 OS 공유 | 각각 독립 OS |
| 격리 수준 | 프로세스 레벨 | 하드웨어 레벨 |

## Docker 설치

### Windows
1. **Docker Desktop for Windows** 다운로드
2. 설치 파일 실행
3. WSL 2 백엔드 활성화
4. 재시작 후 Docker Desktop 실행

```powershell
# 설치 확인
docker --version
docker run hello-world
```

### macOS
```bash
# Homebrew를 통한 설치
brew install --cask docker

# 또는 Docker Desktop 직접 다운로드
# https://www.docker.com/products/docker-desktop
```

### Linux (Ubuntu/Debian)
```bash
# 이전 버전 제거
sudo apt-get remove docker docker-engine docker.io containerd runc

# 필수 패키지 설치
sudo apt-get update
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Docker 공식 GPG 키 추가
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# 저장소 추가
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Docker 설치
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io

# 사용자를 docker 그룹에 추가
sudo usermod -aG docker $USER

# 설치 확인
docker --version
```

## Docker 기본 개념

### 핵심 용어
- **Image**: 컨테이너를 생성하기 위한 템플릿
- **Container**: 이미지의 실행 인스턴스
- **Registry**: 이미지를 저장하고 공유하는 저장소 (Docker Hub)
- **Dockerfile**: 이미지를 빌드하기 위한 명령어 스크립트
- **Volume**: 데이터 지속성을 위한 저장소

### Docker 아키텍처
```
┌─────────────────┐
│   Docker Client │
└─────────────────┘
         │
         │ Docker API
         ▼
┌─────────────────┐    ┌─────────────────┐
│  Docker Daemon  │◄──►│   Registry      │
│                 │    │   (Docker Hub)  │
└─────────────────┘    └─────────────────┘
         │
         ▼
┌─────────────────┐
│   Containers    │
│   Images        │
│   Networks      │
│   Volumes       │
└─────────────────┘
```

## Docker 명령어

### 기본 명령어

#### 이미지 관리
```bash
# 이미지 검색
docker search nginx

# 이미지 다운로드
docker pull nginx:latest
docker pull ubuntu:20.04

# 로컬 이미지 목록
docker images
docker image ls

# 이미지 삭제
docker rmi nginx:latest
docker image rm ubuntu:20.04

# 사용하지 않는 이미지 정리
docker image prune
```

#### 컨테이너 관리
```bash
# 컨테이너 실행
docker run nginx
docker run -d nginx  # 백그라운드 실행
docker run -it ubuntu:20.04 /bin/bash  # 대화형 모드

# 실행 중인 컨테이너 목록
docker ps
docker container ls

# 모든 컨테이너 목록 (중지된 것 포함)
docker ps -a
docker container ls -a

# 컨테이너 중지
docker stop <container_id>
docker stop <container_name>

# 컨테이너 시작
docker start <container_id>

# 컨테이너 재시작
docker restart <container_id>

# 컨테이너 삭제
docker rm <container_id>

# 실행 중인 컨테이너에 명령 실행
docker exec -it <container_id> /bin/bash

# 컨테이너 로그 보기
docker logs <container_id>
docker logs -f <container_id>  # 실시간 로그
```

#### 실용적인 예제
```bash
# 웹 서버 실행 (포트 매핑)
docker run -d -p 8080:80 --name my-nginx nginx

# MySQL 데이터베이스 실행
docker run -d \
  --name mysql-db \
  -e MYSQL_ROOT_PASSWORD=password \
  -e MYSQL_DATABASE=myapp \
  -p 3306:3306 \
  mysql:8.0

# Redis 실행
docker run -d --name redis-server -p 6379:6379 redis:alpine

# 볼륨 마운트하여 파일 공유
docker run -d -p 8080:80 -v /path/to/html:/usr/share/nginx/html nginx
```

### 고급 명령어

#### 네트워크 관리
```bash
# 네트워크 목록
docker network ls

# 사용자 정의 네트워크 생성
docker network create my-network

# 네트워크에 컨테이너 연결
docker run -d --network my-network --name app1 nginx
docker run -d --network my-network --name app2 nginx

# 네트워크 정보 확인
docker network inspect my-network
```

#### 볼륨 관리
```bash
# 볼륨 목록
docker volume ls

# 볼륨 생성
docker volume create my-volume

# 볼륨 정보 확인
docker volume inspect my-volume

# 볼륨 사용
docker run -d -v my-volume:/data alpine

# 볼륨 삭제
docker volume rm my-volume
```

## Dockerfile 작성

### 기본 구조
```dockerfile
# 베이스 이미지 지정
FROM ubuntu:20.04

# 메타데이터 설정
LABEL maintainer="your-email@example.com"
LABEL version="1.0"
LABEL description="샘플 애플리케이션"

# 환경 변수 설정
ENV NODE_ENV=production
ENV PORT=3000

# 작업 디렉토리 설정
WORKDIR /app

# 파일 복사
COPY package*.json ./
COPY . .

# 패키지 설치
RUN apt-get update && \
    apt-get install -y nodejs npm && \
    npm install && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 포트 노출
EXPOSE 3000

# 사용자 설정 (보안상 권장)
RUN useradd -m appuser
USER appuser

# 컨테이너 시작 시 실행될 명령
CMD ["npm", "start"]
```

### Java 애플리케이션 Dockerfile
```dockerfile
# Multi-stage build
FROM maven:3.8.6-openjdk-17 AS build

WORKDIR /app
COPY pom.xml .
COPY src ./src

# 애플리케이션 빌드
RUN mvn clean package -DskipTests

# 실행 환경
FROM openjdk:17-jre-slim

WORKDIR /app

# 빌드된 JAR 파일 복사
COPY --from=build /app/target/*.jar app.jar

# 비루트 사용자 생성
RUN groupadd -r appgroup && useradd -r -g appgroup appuser
RUN chown -R appuser:appgroup /app
USER appuser

# 포트 노출
EXPOSE 8080

# 애플리케이션 실행
ENTRYPOINT ["java", "-jar", "app.jar"]
```

### Spring Boot 애플리케이션 Dockerfile
```dockerfile
FROM openjdk:17-jre-slim

# 시간대 설정
ENV TZ=Asia/Seoul
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

WORKDIR /app

# JAR 파일 복사
COPY target/*.jar app.jar

# 애플리케이션 사용자 생성
RUN addgroup --system spring && adduser --system spring --ingroup spring
USER spring:spring

# 헬스체크
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8080/actuator/health || exit 1

EXPOSE 8080

ENTRYPOINT ["java", "-Xmx512m", "-jar", "app.jar"]
```

### 베스트 프랙티스
```dockerfile
# 좋은 예: 레이어 최적화
FROM node:16-alpine

WORKDIR /app

# 의존성 먼저 복사 (캐시 활용)
COPY package*.json ./
RUN npm ci --only=production

# 소스 코드는 나중에 복사
COPY . .

# 멀티 스테이지 빌드 활용
FROM node:16-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

FROM node:16-alpine AS production
WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY package*.json ./

USER node
EXPOSE 3000
CMD ["npm", "start"]
```

### .dockerignore 파일
```dockerignore
# Git
.git
.gitignore

# 문서
README.md
*.md

# 의존성
node_modules
npm-debug.log

# 빌드 파일
target/
build/
dist/

# IDE
.idea/
.vscode/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# 로그
*.log

# 환경 설정
.env
.env.local
```

## Docker Compose

### docker-compose.yml 기본 구조
```yaml
version: '3.8'

services:
  web:
    build: .
    ports:
      - "8080:8080"
    environment:
      - NODE_ENV=production
    depends_on:
      - db
      - redis
    networks:
      - app-network
    volumes:
      - ./logs:/app/logs

  db:
    image: mysql:8.0
    environment:
      - MYSQL_ROOT_PASSWORD=rootpassword
      - MYSQL_DATABASE=myapp
      - MYSQL_USER=appuser
      - MYSQL_PASSWORD=apppassword
    volumes:
      - mysql-data:/var/lib/mysql
      - ./init.sql:/docker-entrypoint-initdb.d/init.sql
    networks:
      - app-network

  redis:
    image: redis:alpine
    command: redis-server --appendonly yes
    volumes:
      - redis-data:/data
    networks:
      - app-network

volumes:
  mysql-data:
  redis-data:

networks:
  app-network:
    driver: bridge
```

### Java 웹 애플리케이션 예제
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
      - SPRING_DATASOURCE_URL=jdbc:mysql://db:3306/myapp
      - SPRING_DATASOURCE_USERNAME=appuser
      - SPRING_DATASOURCE_PASSWORD=apppassword
      - SPRING_REDIS_HOST=redis
    depends_on:
      db:
        condition: service_healthy
      redis:
        condition: service_started
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8080/actuator/health"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
    restart: unless-stopped
    networks:
      - backend

  db:
    image: mysql:8.0
    environment:
      - MYSQL_ROOT_PASSWORD=rootpassword
      - MYSQL_DATABASE=myapp
      - MYSQL_USER=appuser
      - MYSQL_PASSWORD=apppassword
    volumes:
      - mysql-data:/var/lib/mysql
      - ./docker/mysql/init:/docker-entrypoint-initdb.d
    ports:
      - "3306:3306"
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost"]
      interval: 10s
      timeout: 5s
      retries: 5
    restart: unless-stopped
    networks:
      - backend

  redis:
    image: redis:7-alpine
    command: redis-server --appendonly yes
    volumes:
      - redis-data:/data
    ports:
      - "6379:6379"
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 5s
      retries: 3
    restart: unless-stopped
    networks:
      - backend

  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./docker/nginx/nginx.conf:/etc/nginx/nginx.conf
      - ./docker/nginx/ssl:/etc/nginx/ssl
    depends_on:
      - app
    restart: unless-stopped
    networks:
      - backend
      - frontend

volumes:
  mysql-data:
  redis-data:

networks:
  backend:
    internal: true
  frontend:
```

### Compose 명령어
```bash
# 서비스 시작
docker-compose up
docker-compose up -d  # 백그라운드 실행

# 특정 서비스만 시작
docker-compose up db redis

# 서비스 중지
docker-compose down

# 볼륨까지 삭제
docker-compose down -v

# 서비스 재시작
docker-compose restart

# 로그 확인
docker-compose logs
docker-compose logs -f app  # 특정 서비스 로그

# 스케일링
docker-compose up --scale app=3

# 이미지 빌드
docker-compose build
docker-compose build --no-cache

# 서비스 상태 확인
docker-compose ps
```

## Docker 네트워킹

### 네트워크 드라이버 유형
1. **bridge**: 기본 네트워크 드라이버
2. **host**: 호스트 네트워크 스택 사용
3. **overlay**: 멀티 호스트 네트워킹
4. **none**: 네트워킹 비활성화

### 네트워크 예제
```bash
# 사용자 정의 브리지 네트워크 생성
docker network create --driver bridge my-bridge-network

# 서브넷과 게이트웨이 지정
docker network create \
  --driver bridge \
  --subnet=172.20.0.0/16 \
  --ip-range=172.20.240.0/20 \
  --gateway=172.20.0.1 \
  my-custom-network

# 컨테이너를 네트워크에 연결
docker run -d --name web1 --network my-bridge-network nginx
docker run -d --name web2 --network my-bridge-network nginx

# 실행 중인 컨테이너를 네트워크에 연결
docker network connect my-bridge-network existing-container
```

### 컨테이너 간 통신
```yaml
# docker-compose.yml
version: '3.8'

services:
  frontend:
    build: ./frontend
    ports:
      - "3000:3000"
    networks:
      - frontend-network
      - backend-network

  backend:
    build: ./backend
    ports:
      - "8080:8080"
    environment:
      - DATABASE_URL=postgresql://db:5432/myapp
    networks:
      - backend-network

  db:
    image: postgres:13
    environment:
      - POSTGRES_DB=myapp
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=password
    networks:
      - backend-network

networks:
  frontend-network:
  backend-network:
    internal: true  # 외부 접근 차단
```

## Docker 볼륨

### 볼륨 유형
1. **Named Volume**: Docker가 관리하는 볼륨
2. **Bind Mount**: 호스트 디렉토리 마운트
3. **tmpfs Mount**: 메모리 기반 임시 저장소

### 볼륨 사용 예제
```bash
# Named Volume
docker volume create my-data
docker run -d -v my-data:/data alpine

# Bind Mount
docker run -d -v /host/path:/container/path alpine

# tmpfs Mount (Linux만)
docker run -d --tmpfs /tmp alpine
```

### 데이터베이스 볼륨 관리
```yaml
# docker-compose.yml
version: '3.8'

services:
  mysql:
    image: mysql:8.0
    environment:
      - MYSQL_ROOT_PASSWORD=password
    volumes:
      # 데이터 지속성
      - mysql-data:/var/lib/mysql
      # 초기화 스크립트
      - ./init-scripts:/docker-entrypoint-initdb.d:ro
      # 설정 파일
      - ./mysql.cnf:/etc/mysql/conf.d/custom.cnf:ro
      # 백업 디렉토리
      - ./backups:/backups

  postgres:
    image: postgres:13
    environment:
      - POSTGRES_DB=myapp
    volumes:
      - postgres-data:/var/lib/postgresql/data
      - ./postgres-init:/docker-entrypoint-initdb.d:ro

volumes:
  mysql-data:
    driver: local
  postgres-data:
    driver: local
```

### 볼륨 백업 및 복구
```bash
# 볼륨 백업
docker run --rm -v mysql-data:/data -v $(pwd):/backup alpine \
  tar czf /backup/mysql-backup.tar.gz -C /data .

# 볼륨 복구
docker run --rm -v mysql-data:/data -v $(pwd):/backup alpine \
  tar xzf /backup/mysql-backup.tar.gz -C /data
```

## Docker 보안

### 보안 베스트 프랙티스

#### 1. 최소 권한 원칙
```dockerfile
# 전용 사용자 생성
FROM ubuntu:20.04

RUN groupadd -r appgroup && \
    useradd -r -g appgroup -s /bin/false appuser && \
    mkdir -p /app && \
    chown -R appuser:appgroup /app

USER appuser
WORKDIR /app
```

#### 2. 보안 스캔
```bash
# Trivy를 사용한 취약점 스캔
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
  aquasec/trivy image my-app:latest

# Clair를 사용한 스캔
docker run -d --name clair-db postgres:latest
docker run -d --name clair --link clair-db:postgres arminc/clair-local-scan
```

#### 3. 안전한 이미지 사용
```dockerfile
# 공식 이미지 사용
FROM node:16-alpine

# 특정 태그 사용 (latest 지양)
FROM nginx:1.21.6-alpine

# 멀티 스테이지 빌드로 크기 최소화
FROM node:16-alpine AS builder
# ... 빌드 과정

FROM node:16-alpine AS runtime
COPY --from=builder /app/dist /app
```

#### 4. 시크릿 관리
```yaml
# docker-compose.yml
version: '3.8'

services:
  app:
    image: my-app
    secrets:
      - db_password
      - api_key
    environment:
      - DB_PASSWORD_FILE=/run/secrets/db_password

secrets:
  db_password:
    file: ./secrets/db_password.txt
  api_key:
    external: true
```

#### 5. 네트워크 보안
```yaml
services:
  web:
    networks:
      - frontend

  app:
    networks:
      - frontend
      - backend

  db:
    networks:
      - backend  # 외부 접근 차단

networks:
  frontend:
  backend:
    internal: true
```

### 보안 설정 예제
```bash
# 읽기 전용 루트 파일시스템
docker run --read-only -v /tmp:/tmp my-app

# 권한 제한
docker run --cap-drop=ALL --cap-add=NET_BIND_SERVICE my-app

# 사용자 네임스페이스 사용
docker run --user 1000:1000 my-app

# 보안 옵션 설정
docker run --security-opt=no-new-privileges my-app
```

## 실무 활용 및 베스트 프랙티스

### 개발 환경 구성
```yaml
# docker-compose.dev.yml
version: '3.8'

services:
  app:
    build:
      context: .
      dockerfile: Dockerfile.dev
    volumes:
      - .:/app
      - /app/node_modules
    environment:
      - NODE_ENV=development
      - DEBUG=app:*
    ports:
      - "3000:3000"
      - "9229:9229"  # 디버깅 포트

  db:
    image: postgres:13
    environment:
      - POSTGRES_DB=myapp_dev
    volumes:
      - postgres-dev-data:/var/lib/postgresql/data
      - ./sample-data.sql:/docker-entrypoint-initdb.d/sample-data.sql

volumes:
  postgres-dev-data:
```

### 프로덕션 환경 구성
```yaml
# docker-compose.prod.yml
version: '3.8'

services:
  app:
    image: my-registry.com/my-app:${VERSION}
    deploy:
      replicas: 3
      resources:
        limits:
          memory: 512M
          cpus: '0.5'
      restart_policy:
        condition: on-failure
        delay: 5s
        max_attempts: 3
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000/health"]
      interval: 30s
      timeout: 10s
      retries: 3
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"

  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
      - ./ssl:/etc/nginx/ssl:ro
    depends_on:
      - app
```

### CI/CD 파이프라인 예제
```yaml
# .github/workflows/docker.yml
name: Docker Build and Push

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build-and-push:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v2
    
    - name: Set up Docker Buildx
      uses: docker/setup-buildx-action@v1
    
    - name: Login to DockerHub
      uses: docker/login-action@v1
      with:
        username: ${{ secrets.DOCKERHUB_USERNAME }}
        password: ${{ secrets.DOCKERHUB_TOKEN }}
    
    - name: Build and push
      uses: docker/build-push-action@v2
      with:
        context: .
        push: true
        tags: |
          my-app:latest
          my-app:${{ github.sha }}
        cache-from: type=gha
        cache-to: type=gha,mode=max
```

### 모니터링 스택
```yaml
# monitoring.yml
version: '3.8'

services:
  prometheus:
    image: prom/prometheus
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
      - prometheus-data:/prometheus

  grafana:
    image: grafana/grafana
    ports:
      - "3000:3000"
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin
    volumes:
      - grafana-data:/var/lib/grafana

  node-exporter:
    image: prom/node-exporter
    ports:
      - "9100:9100"
    volumes:
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /:/rootfs:ro

volumes:
  prometheus-data:
  grafana-data:
```

### 성능 최적화 팁

#### 1. 이미지 크기 최적화
```dockerfile
# Alpine 이미지 사용
FROM node:16-alpine

# 불필요한 파일 제거
RUN apk add --no-cache python3 make g++ && \
    npm install && \
    apk del python3 make g++

# 멀티 스테이지 빌드
FROM node:16-alpine AS dependencies
COPY package*.json ./
RUN npm ci --only=production

FROM node:16-alpine AS runtime
COPY --from=dependencies /app/node_modules ./node_modules
COPY . .
```

#### 2. 빌드 캐시 활용
```dockerfile
# 의존성을 먼저 복사하여 캐시 활용
COPY package*.json ./
RUN npm install

# 소스 코드는 나중에 복사
COPY . .
```

#### 3. 리소스 제한
```yaml
services:
  app:
    deploy:
      resources:
        limits:
          memory: 1G
          cpus: '1.0'
        reservations:
          memory: 512M
          cpus: '0.5'
```

### 디버깅 및 트러블슈팅

#### 컨테이너 디버깅
```bash
# 컨테이너 내부 접근
docker exec -it <container_id> /bin/bash

# 컨테이너 정보 확인
docker inspect <container_id>

# 리소스 사용량 확인
docker stats

# 컨테이너 프로세스 확인
docker top <container_id>

# 네트워크 연결 확인
docker exec <container_id> netstat -an
```

#### 로그 분석
```bash
# 실시간 로그 모니터링
docker logs -f <container_id>

# 특정 시간 이후 로그
docker logs --since="2023-01-01T00:00:00" <container_id>

# 로그 줄 수 제한
docker logs --tail=100 <container_id>
```

이 가이드는 Docker의 기본 개념부터 실무 활용까지 포괄적으로 다룹니다. Docker를 통해 효율적인 개발 및 배포 환경을 구축할 수 있습니다.