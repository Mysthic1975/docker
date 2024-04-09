# Verwenden Sie ein offizielles Maven-Image als Elternbild
FROM maven:3.8.1-openjdk-17-slim AS build

# Setzen Sie das Arbeitsverzeichnis im Container
WORKDIR /app

# Kopieren Sie die pom.xml und laden Sie die Abhängigkeiten herunter
COPY pom.xml .
RUN mvn dependency:go-offline

# Kopieren Sie den Rest des Anwendungscodes
COPY src ./src

# Bauen Sie die Anwendung
RUN mvn package

# Verwenden Sie ein offizielles Java-Laufzeitbild zum Ausführen der Anwendung
FROM openjdk:17-slim

# Setzen Sie das Arbeitsverzeichnis im Container
WORKDIR /app

# Kopieren Sie die gebaute Anwendung vom Build-Container
COPY --from=build /app/target/docker-1.0-SNAPSHOT.jar ./app.jar

# Exponieren Sie den Port, auf dem Ihre Anwendung läuft
EXPOSE 8080

# Führen Sie die Anwendung aus
CMD ["java", "-jar", "app.jar"]