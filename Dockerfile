# 1. Compilar interfaz Angular
FROM node:20-alpine AS ui-builder

WORKDIR /app/ui

COPY ui/package*.json ./
RUN npm ci

COPY ui/ ./
RUN npm run build


# 2. Compilar Spring Boot
FROM amazoncorretto:21-alpine AS builder

WORKDIR /app

COPY . .

# Incorporar Angular a los recursos estáticos
COPY --from=ui-builder /app/ui/dist/ui/browser/ /app/boot/src/main/resources/static/

# Compilar Java
WORKDIR /app/boot

RUN chmod +x gradlew && ./gradlew bootJar --no-daemon


# 3. Imagen final
FROM amazoncorretto:21-alpine

WORKDIR /app

COPY --from=builder /app/boot/build/libs/tp2intervals.jar /app/app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "/app/app.jar"]
