# 🚀 Spring Boot 애플리케이션 도커화 예제  

이 프로젝트는 Spring Boot 애플리케이션을 Docker 컨테이너로 패키징하고, Docker Hub에 푸시 및 풀 하는 과정을 보여줍니다.  

<br>

## 📑 목차  

- [📌 사전 요구사항](#-사전-요구사항)  
- [📂 프로젝트 구조](#-프로젝트-구조)  
- [🐳 Docker 이미지 빌드](#-docker-이미지-빌드)  
- [📤 Docker Hub에 이미지 푸시](#-docker-hub에-이미지-푸시)  
- [📥 Docker Hub에서 이미지 풀](#-docker-hub에서-이미지-풀)  
- [▶️ 컨테이너 실행](#%EF%B8%8F-컨테이너-실행)  
- [🛠 문제 해결](#-문제-해결)  
<br>

## 📌 사전 요구사항  

- [Docker](https://www.docker.com/get-started) 설치  
- [Docker Hub](https://hub.docker.com/) 계정  
- Java 17  
- Spring Boot 애플리케이션 JAR 파일  
<br>

## 📂 프로젝트 구조  

```
spring-boot-docker/
│
├── Dockerfile                # Docker 이미지 설정 파일
├── step01_basic-0.0.1-SNAPSHOT.jar   # Spring Boot 애플리케이션 JAR
└── README.md                 # 프로젝트 설명 문서
```
<br>

## 🐳 Docker 이미지 빌드  

### 1. Dockerfile 작성  

프로젝트 루트 디렉토리에 Dockerfile을 생성합니다.  

```dockerfile
# 실행 환경이므로 JDK보다 가벼운 JRE 사용합니다.
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
<br>

### 2. Docker 이미지 빌드  

다음 명령어로 Docker 이미지를 빌드합니다:  

```bash
docker build -t springboottest:1.0 .
docker build -t springboottest:2.0 .
docker build -t springboottest:3.0 .
docker build -t springboottest:4.0 .
```

이미지 빌드가 완료되면 다음 명령어로 생성된 이미지를 확인할 수 있습니다:  

```bash
docker images
```

📜 **결과 예시**  
```
REPOSITORY           TAG       IMAGE ID       CREATED             SIZE
springboottest       4.0       7472b57f1985   18 minutes ago      205MB
springboottest       3.0       3263a10fa5ec   19 minutes ago      288MB
springboottest       2.0       578cca89ef8b   22 minutes ago      433MB
springboottest       1.0       bf0036a0ea3b   25 minutes ago      496MB
```
<br>
위 사이즈의 크기 차이는 최적화 유무로 인해 나타난 것으로, 어떤 jdk 혹은 jre가 탑재된 이미지를 사용했느냐에 따라 달라진다.<br><br>

|Tag|Image|
|---|-----|
|4.0|eclipse-temurin:17-jre-alpine|
|3.0|eclipse-temurin:17-jre|
|2.0|openjdk:17-slim|
|1.0|openjdk:17|

<br>

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

<br>

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
<br>

## ▶️ 컨테이너 실행  

```bash
docker run -p 8080:8080 <YOUR-USERNAME>/springboottest:1.0
```

이 명령어는 호스트의 `8080` 포트를 컨테이너의 `8080` 포트에 매핑합니다.  

웹 브라우저에서 다음 URL로 접속할 수 있습니다:  
```
http://localhost:8080/woori/fisa
```
<br>

## 🛠 문제 해결  

### ⚠️ 포트 매핑 문제  

애플리케이션 로그에서 다음과 같은 출력을 확인할 수 있습니다:  
```
Tomcat initialized with port <portnumber> (http)
```
<br>

#### ✅ 해결책  

1. **애플리케이션 설정 변경**  
   `application.properties` 또는 `application.yml` 파일에서 포트를 `8080`으로 변경  
   ```
   server.port=8080
   ```

2. **Docker 실행 시 포트 매핑 변경**  
   ```bash
   docker run -p 8080:<portnumber> <YOUR-USERNAME>/springboottest:1.0
   ```
