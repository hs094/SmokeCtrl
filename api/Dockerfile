# Use a base image with Java and Gradle
FROM gradle:7.5.1-jdk17 AS build


# Set the working directory inside the container
WORKDIR /app

# Copy your Gradle build files
COPY build.gradle settings.gradle ./
COPY src ./src

# Build the application
RUN gradle build --no-daemon

# Use a smaller base image for running the application
FROM openjdk:17-jdk-slim

# Set the working directory
WORKDIR /app

# Copy the built JAR file from the build stage
COPY --from=build /app/build/libs/*.jar app.jar

# Specify the command to run the application
ENTRYPOINT ["java", "-jar", "app.jar"]

# Optional: If you have other runtime dependencies, you can add them here
