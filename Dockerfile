# 멀티 스테이지 빌드를 해준다 (jar 파일이 아닌 java 파일을 할 때 씀씀)
# 빌드와 실행 단계를 분리하여 최종 이미지의 크기를 줄인다
# maven을 사용하여 빌드한 후 최종 이미지를 JRE로 설정

# 빌드 단계

# FROM maven:3.8.1-openjdk-17 AS build
# WORKDIR /app
# COPY . .
# RUN mvn clean package -DskipTests

# 실행 단계

# jdk가 아닌 jre를 사용합니다.
# jdk는 개발 도구를 포함하고 있기 때문에
# 실행 환경에서는 jre만 있어도 괜찮
FROM eclipse-temurin:17-jre-alpine

# 작업 디렉토리를 설정합니다.
WORKDIR /app

# JAR 파일을 컨테이너의 작업 디렉토리로 복사합니다.
COPY step01_basic_t-0.0.1-SNAPSHOT.jar app.jar

# 최적화용 환경 변수들을 만들어줍니다.
# -Xmx 및 -Xms: 최대 및 초기 힙 메모리 크기를 설정
# -XX:+UseG1GC: G1 가비지 컬렉터를 사용하도록 설정
# -XX:MaxGCPauseMillis: 가비지 컬렉션의 최대 일시 중지 시간을 설정
ENV JAVA_OPTS="-Xms256m -Xmx512m -XX:+UseG1GC -XX:MaxGCPauseMillis=200"

# 애플리케이션을 실행합니다.
ENTRYPOINT ["java", "${JAVA_OPTS}", "-jar", "app.jar"]