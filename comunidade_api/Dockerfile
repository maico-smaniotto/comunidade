# Etapa de build
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app
COPY . .
RUN ./mvnw clean package -DskipTests

# Etapa de runtime
FROM eclipse-temurin:21-jdk
WORKDIR /app
COPY --from=build /app/target/comunidade_api-0.0.1-SNAPSHOT.jar app.jar
COPY --from=build /app/src/main/resources /app/resources

# Variável obrigatória no Fly.io
ENV PORT=8080
EXPOSE 8080

CMD ["java", "-jar", "app.jar", "--server.address=0.0.0.0"]
