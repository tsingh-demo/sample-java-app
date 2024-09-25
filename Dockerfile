# Use an official OpenJDK image to run the application
FROM openjdk:17-jdk-alpine

# Set the working directory in the container
WORKDIR /app

# Copy the JAR file from the build stage
COPY target/spring-boot-2-hello-world-1.0.2-SNAPSHOT.jar /app/sample-java-app.jar

# Set the command to run the application
ENTRYPOINT ["java", "-jar", "/app/sample-java-app.jar"]
