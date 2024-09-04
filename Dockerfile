FROM openjdk:8
COPY target/spring-boot-2-hello-world-1.0.2-SNAPSHOT.jar app.jar
EXPOSE 8888
ENTRYPOINT ["java","-jar","/app.jar"]
