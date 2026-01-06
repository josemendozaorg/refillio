# Stage 1: Build
FROM gradle:8-jdk21 AS build
WORKDIR /app

# Copy source code
COPY . .

# Build application
RUN gradle build -x test --no-daemon

# Stage 2: Run
FROM eclipse-temurin:21-jre
WORKDIR /app

# Copy executable from build stage
COPY --from=build /app/build/libs/*.jar app.jar

# Expose port
EXPOSE 8080

# Run application
ENTRYPOINT ["java", "-jar", "app.jar"]
