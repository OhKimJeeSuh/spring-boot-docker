# 🚀 Spring Boot 애플리케이션 도커화 예제  

이 프로젝트는 Spring Boot 애플리케이션을 Docker 컨테이너로 패키징하고, Docker Hub에 푸시 및 풀 하는 과정을 보여줍니다.  

## 📑 목차  

- [📌 사전 요구사항](#사전-요구사항)  
- [📂 프로젝트 구조](#프로젝트-구조)  
- [🐳 Docker 이미지 빌드](#docker-이미지-빌드)  
- [📤 Docker Hub에 이미지 푸시](#docker-hub에-이미지-푸시)  
- [📥 Docker Hub에서 이미지 풀](#docker-hub에서-이미지-풀)  
- [▶️ 컨테이너 실행](#컨테이너-실행)  
- [🛠 문제 해결](#문제-해결)  

## 📌 사전 요구사항  

- [🐳 Docker](https://www.docker.com/get-started) 설치  
- [📝 Docker Hub](https://hub.docker.com/) 계정  
- ☕ Java 17  
- ⚙️ Spring Boot 애플리케이션 JAR 파일  

## 📂 프로젝트 구조  

```
spring-boot-docker/
│
├── 🐳 Dockerfile                # Docker 이미지 설정 파일
├── 📦 step01_basic-0.0.1-SNAPSHOT.jar   # Spring Boot 애플리케이션 JAR
└── 📖 README.md                 # 프로젝트 설명 문서
```

## 🐳 Docker 이미지 빌드  

### 1. Dockerfile 작성  

프로젝트 루트 디렉토리에 다음 내용의 `Dockerfile`을 생성합니다:  

```dockerfile
# 실행 환경에서는 jre만 있어도 괜찮
FROM eclipse-temurin:17-jre-alpine

# 작업 디렉토리를 설정합니다.
WORKDIR /app

# JAR 파일을 컨테이너의 작업 디렉토리로 복사합니다.
COPY step01_basic_t-0.0.1-SNAPSHOT.jar app.jar

# 최적화용 환경 변수들을 만들어줍니다.
ENV JAVA_OPTS="-Xms256m -Xmx512m -XX:+UseG1GC -XX:MaxGCPauseMillis=200"

# 애플리케이션을 실행합니다.
ENTRYPOINT ["java", "${JAVA_OPTS}", "-jar", "app.jar"]
```

### 2. Docker 이미지 빌드  

다음 명령어로 Docker 이미지를 빌드합니다:  

```bash
docker build -t springboottest:1.0 .
```

이미지 빌드가 완료되면 다음 명령어로 생성된 이미지를 확인할 수 있습니다:  

```bash
docker images
```

📜 **결과 예시**  
```
REPOSITORY                           TAG       IMAGE ID       CREATED             SIZE
<YOUR-USERNAME>/springboottest       1.0       7472b57f1985   18 minutes ago      205MB
```

## 📤 Docker Hub에 이미지 푸시  

### 1. Docker Hub 로그인  

```bash
docker login
```

### 2. 이미지 태그 설정  

```bash
docker tag springboottest:1.0 <YOUR-USERNAME>/springboottest:1.0
```

### 3. Docker Hub에 이미지 푸시  

```bash
docker push <YOUR-USERNAME>/springboottest:1.0
```

푸시가 완료되면 Docker Hub 웹사이트에서 확인할 수 있습니다.  

## 📥 Docker Hub에서 이미지 풀  

### 1. Docker Hub에서 이미지 풀  

```bash
docker pull <YOUR-USERNAME>/springboottest:1.0
```

📜 **결과 예시**  
```
1.0: Pulling from <YOUR-USERNAME>/springboottest
1fe172e4850f: Already exists
44d3aa8d0766: Already exists
6ce99fdf16e8: Already exists
080a7b064695: Pull complete
e068efcc9803: Pull complete
Digest: sha256:a1b2c3d4e5...
Status: Downloaded newer image for YOUR-USERNAME/springboottest:1.0
```

## ▶️ 컨테이너 실행  

```bash
docker run -p 8080:8080 <YOUR-USERNAME>/springboottest:1.0
```

이 명령어는 호스트의 `8080` 포트를 컨테이너의 `8080` 포트에 매핑합니다.  

웹 브라우저에서 다음 URL로 접속할 수 있습니다:  
```
http://localhost:8080/woori/fisa
```

## 🛠 문제 해결  

### ⚠️ 포트 매핑 문제  

애플리케이션 로그에서 다음과 같은 출력을 확인할 수 있습니다:  
```
Tomcat initialized with port <portnumber> (http)
```

#### ✅ 해결책  

1️⃣ **애플리케이션 설정 변경**  
   `application.properties` 또는 `application.yml` 파일에서 포트를 `8080`으로 변경  
   ```
   server.port=8080
   ```

2️⃣ **Docker 실행 시 포트 매핑 변경**  
   ```bash
   docker run -p 8080:<portnumber> <YOUR-USERNAME>/springboottest:1.0
   ```
