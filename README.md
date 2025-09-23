# Friendly Octo Lamp 🐙💡

A comprehensive Docker workflow demonstration project featuring containerized Node.js application with CI/CD pipeline.

## 🚀 프로젝트 개요

이 프로젝트는 Docker를 사용한 완전한 컨테이너화 워크플로우를 시연합니다:

- **도커 이미지 생성**: 멀티 스테이지 Dockerfile을 사용한 최적화된 이미지 빌드
- **파일 생성**: Node.js 애플리케이션 및 관련 구성 파일 자동 생성
- **빌드 프로세스**: 자동화된 빌드 스크립트 및 GitHub Actions 워크플로우
- **컨테이너 생성**: Docker Compose를 사용한 다중 서비스 컨테이너 오케스트레이션

## 📋 기능

- ✅ **멀티 스테이지 Docker 빌드**
- ✅ **Docker Compose 오케스트레이션** (App + Redis + Nginx)
- ✅ **GitHub Actions CI/CD 파이프라인**
- ✅ **보안 스캔 및 취약점 검사**
- ✅ **자동화된 배포 스크립트**
- ✅ **헬스 체크 및 모니터링**
- ✅ **로드 밸런싱 및 리버스 프록시**

## 🏗️ 아키텍처

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│     Nginx       │    │   Node.js App   │    │     Redis       │
│  (Port 80/443)  │◄──►│   (Port 3000)   │◄──►│   (Port 6379)   │
│  Reverse Proxy  │    │  Main Service   │    │  Cache/Session  │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## 🛠️ 시작하기

### 사전 요구사항

- Docker & Docker Compose
- Node.js 18+ (로컬 개발용)
- Git

### 1. 저장소 클론

```bash
git clone https://github.com/davidkims/friendly-octo-lamp.git
cd friendly-octo-lamp
```

### 2. 빠른 시작

#### Option A: Docker Compose 사용 (권장)

```bash
# 모든 서비스 시작
./scripts/docker-compose.sh start

# 또는
docker-compose up -d --build
```

#### Option B: 단일 Docker 컨테이너

```bash
# 빌드 및 실행
./scripts/docker-build.sh

# 또는 수동으로
docker build -t friendly-octo-lamp .
docker run -p 3000:3000 friendly-octo-lamp
```

#### Option C: 로컬 개발

```bash
npm install
npm start
```

### 3. 애플리케이션 접속

- **메인 애플리케이션**: http://localhost:3000
- **Nginx 프록시**: http://localhost:80 (Docker Compose 사용시)
- **헬스 체크**: http://localhost:3000/health
- **시스템 정보**: http://localhost:3000/info

## 📖 스크립트 사용법

### Docker Build 스크립트

```bash
# 전체 빌드 및 배포
./scripts/docker-build.sh

# 개별 명령어
./scripts/docker-build.sh cleanup  # 정리
./scripts/docker-build.sh build    # 빌드만
./scripts/docker-build.sh run      # 실행만
./scripts/docker-build.sh status   # 상태 확인
```

### Docker Compose 스크립트

```bash
# 서비스 관리
./scripts/docker-compose.sh start    # 시작
./scripts/docker-compose.sh stop     # 중지
./scripts/docker-compose.sh restart  # 재시작
./scripts/docker-compose.sh status   # 상태
./scripts/docker-compose.sh logs     # 로그 확인
./scripts/docker-compose.sh health   # 헬스 체크
./scripts/docker-compose.sh cleanup  # 정리
```

## 🔧 개발

### 로컬 개발 환경

```bash
# 의존성 설치
npm install

# 개발 서버 시작 (nodemon)
npm run dev

# 테스트 실행
npm test

# 빌드
npm run build
```

### 테스트

```bash
# 전체 테스트 실행
npm test

# 테스트 커버리지
npm run test:coverage
```

## 🚀 배포

### GitHub Actions

이 프로젝트는 자동화된 CI/CD 파이프라인을 포함합니다:

1. **테스트**: 코드 품질 검사 및 단위 테스트
2. **빌드**: Docker 이미지 빌드 및 레지스트리 푸시
3. **보안 스캔**: Trivy를 사용한 취약점 스캔
4. **배포**: 스테이징 및 프로덕션 환경 배포

### 수동 배포

```bash
# 프로덕션 이미지 빌드
docker build -t friendly-octo-lamp:prod .

# 프로덕션 배포
docker-compose -f docker-compose.prod.yml up -d
```

## 📁 프로젝트 구조

```
friendly-octo-lamp/
├── .github/
│   └── workflows/
│       └── docker-ci-cd.yml     # GitHub Actions 워크플로우
├── scripts/
│   ├── docker-build.sh          # Docker 빌드 스크립트
│   └── docker-compose.sh        # Docker Compose 관리 스크립트
├── src/
│   └── app.js                   # 메인 애플리케이션
├── public/
│   └── index.html               # 프론트엔드 UI
├── tests/
│   └── app.test.js              # 테스트 파일
├── Dockerfile                   # Docker 이미지 정의
├── docker-compose.yml           # 서비스 오케스트레이션
├── nginx.conf                   # Nginx 설정
├── healthcheck.js               # 헬스 체크 스크립트
├── package.json                 # Node.js 의존성
└── README.md                    # 프로젝트 문서
```

## 🔍 모니터링 및 로그

### 컨테이너 상태 확인

```bash
# Docker Compose 서비스 상태
docker-compose ps

# 개별 컨테이너 상태
docker ps
```

### 로그 확인

```bash
# 모든 서비스 로그
docker-compose logs -f

# 특정 서비스 로그
docker-compose logs -f app
docker-compose logs -f nginx
docker-compose logs -f redis
```

### 헬스 체크

```bash
# 스크립트를 통한 헬스 체크
./scripts/docker-compose.sh health

# 수동 헬스 체크
curl http://localhost:3000/health
curl http://localhost:80/nginx-health
```

## 🛡️ 보안

- 멀티 스테이지 빌드로 최소 공격 표면
- 비루트 사용자로 컨테이너 실행
- 보안 헤더 설정 (Nginx)
- 취약점 스캔 자동화 (Trivy)
- 레이트 리미팅 설정

## 🤝 기여

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 라이선스

이 프로젝트는 Apache 2.0 라이선스 하에 배포됩니다. 자세한 내용은 [LICENSE](LICENSE) 파일을 참조하세요.

## 🆘 트러블슈팅

### 일반적인 문제

1. **Docker 데몬이 실행되지 않음**
   ```bash
   sudo systemctl start docker
   ```

2. **포트가 이미 사용 중**
   ```bash
   # 사용 중인 포트 확인
   sudo netstat -tulpn | grep :3000
   # 프로세스 종료
   sudo kill -9 <PID>
   ```

3. **권한 문제**
   ```bash
   # 스크립트 실행 권한 부여
   chmod +x scripts/*.sh
   ```

4. **컨테이너 정리**
   ```bash
   # 모든 컨테이너 및 이미지 정리
   ./scripts/docker-compose.sh cleanup
   docker system prune -a
   ```

## 📞 지원

문제가 발생하거나 질문이 있으시면 [Issues](https://github.com/davidkims/friendly-octo-lamp/issues)를 통해 문의해 주세요.
