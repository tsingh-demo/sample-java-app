# Use an official OpenJDK image to run the application
FROM openjdk:17-jdk-slim

# Set the working directory in the container
WORKDIR /app

# Copy the JAR file from the build stage
COPY target/spring-boot-2-hello-world-1.0.2-SNAPSHOT.jar /app/sample-java-app.jar

#Expose the application port
EXPOSE 9090

# Set the command to run the application
ENTRYPOINT ["java", "-jar", "/app/sample-java-app.jar"]
