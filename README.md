# Java & Docker 종합 가이드

Java와 Docker에 대한 포괄적인 학습 자료와 실습 예제를 제공합니다.

## 📚 학습 자료

### [Java 완전 가이드](docs/java-guide.md)
Java 프로그래밍 언어에 대한 완전한 학습 가이드입니다.

**주요 내용:**
- Java 기본 문법과 객체지향 프로그래밍
- 고급 기능 (제네릭스, 람다, 스트림 API)
- Spring Framework와 JPA 활용
- 개발 도구 및 베스트 프랙티스
- 성능 최적화 및 보안 가이드라인

### [Docker 완전 가이드](docs/docker-guide.md)
Docker 컨테이너 기술에 대한 종합적인 학습 자료입니다.

**주요 내용:**
- Docker 기본 개념과 설치
- Dockerfile 작성 및 이미지 빌드
- Docker Compose를 활용한 멀티 컨테이너 환경
- 네트워킹, 볼륨, 보안 설정
- 실무 활용 및 베스트 프랙티스

## 🛠️ 실습 예제

### [Java + Docker 실습 예제](examples/java-docker-examples.md)
Java 애플리케이션을 Docker로 컨테이너화하는 실무 예제집입니다.

**포함된 예제:**
- 간단한 Java CLI 애플리케이션 Dockerizing
- Spring Boot 웹 애플리케이션 컨테이너화
- MySQL, Redis와 연동된 마이크로서비스 구성
- 멀티 스테이지 빌드 최적화
- Docker Compose를 활용한 전체 스택 구성

## 🚀 빠른 시작

### 1. 환경 준비
```bash
# Java 17 설치 확인
java -version

# Docker 설치 확인
docker --version
docker-compose --version
```

### 2. 예제 실행
```bash
# 저장소 클론
git clone https://github.com/davidkims/friendly-octo-lamp.git
cd friendly-octo-lamp

# 예제 디렉토리로 이동하여 실습
cd examples
```

### 3. 학습 순서 추천
1. **Java 기초** - [Java 가이드](docs/java-guide.md)의 기본 문법부터 시작
2. **Docker 기초** - [Docker 가이드](docs/docker-guide.md)의 기본 개념 학습
3. **실습** - [실습 예제](examples/java-docker-examples.md)로 직접 구현
4. **심화** - 프레임워크와 고급 기능 학습

## 📖 주요 주제

### Java 핵심 개념
- **객체지향 프로그래밍**: 클래스, 상속, 다형성, 캡슐화
- **컬렉션 프레임워크**: List, Set, Map 활용
- **함수형 프로그래밍**: Lambda, Stream API
- **동시성**: 멀티스레딩, ExecutorService
- **예외 처리**: try-catch, 사용자 정의 예외

### Spring Framework
- **Spring Boot**: 자동 설정, 스타터 의존성
- **Spring MVC**: REST API 개발
- **Spring Data JPA**: 데이터베이스 연동
- **Spring Security**: 인증 및 권한 관리

### Docker 핵심 개념
- **컨테이너화**: 애플리케이션 격리 및 배포
- **이미지 관리**: Dockerfile 최적화
- **오케스트레이션**: Docker Compose
- **네트워킹**: 컨테이너 간 통신
- **데이터 관리**: 볼륨과 바인드 마운트

### DevOps 연계
- **CI/CD**: GitHub Actions, Jenkins
- **모니터링**: Prometheus, Grafana
- **로깅**: ELK Stack
- **보안**: 컨테이너 보안, 시크릿 관리

## 🎯 학습 목표

이 가이드를 통해 다음을 달성할 수 있습니다:

1. **Java 전문성 향상**
   - 객체지향 설계 원칙 이해
   - Spring 생태계 활용 능력
   - 성능 최적화 및 트러블슈팅

2. **Docker 활용 능력**
   - 컨테이너 기반 개발 환경 구축
   - 마이크로서비스 아키텍처 구현
   - 프로덕션 환경 배포 준비

3. **실무 적용 능력**
   - 실제 프로젝트에 적용 가능한 지식
   - 베스트 프랙티스 이해
   - 문제 해결 능력 향상

## 🤝 기여하기

이 프로젝트는 지속적으로 업데이트됩니다. 다음과 같은 방법으로 기여할 수 있습니다:

- 오탈자나 오류 신고
- 새로운 예제나 내용 제안
- 실습 후기 및 개선 사항 공유

## 📝 라이선스

이 프로젝트는 [Apache License 2.0](LICENSE) 하에 제공됩니다.

## 📞 문의사항

질문이나 제안사항이 있으시면 Issues를 통해 문의해 주세요.

---

**Happy Coding with Java & Docker! 🎉**
