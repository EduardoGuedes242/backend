# ============================
# 1) Stage de build
# ============================
FROM maven:3.9.6-eclipse-temurin-17 AS builder

WORKDIR /app

# Copia arquivos do Maven primeiro para aproveitar o cache
COPY pom.xml .
RUN mvn -q dependency:go-offline

# Copia o código do projeto
COPY src ./src

# Build do projeto
RUN mvn -q package -DskipTests


# ============================
# 2) Stage de execução
# ============================
FROM eclipse-temurin:17-jre

WORKDIR /app

# Copia o JAR gerado no stage anterior
COPY --from=builder /app/target/*.jar app.jar

EXPOSE 8080

# Comando que roda o serviço
ENTRYPOINT ["java", "-jar", "app.jar"]
