FROM amazoncorretto:21-alpine AS builder
WORKDIR /app
COPY . .
RUN ./gradlew bootJar

FROM amazoncorretto:21-alpine
WORKDIR /app
COPY --from=builder /app/boot/build/libs/tp2intervals.jar /app/app.jar
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
