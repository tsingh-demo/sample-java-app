# Use an official OpenJDK 17 runtime as a parent image
FROM openjdk:17-slim

# Set environment variables for Maven
ENV MAVEN_VERSION=3.9.5 \
    MAVEN_HOME=/usr/share/maven \
    PATH=$MAVEN_HOME/bin:$PATH

# Install dependencies: Git, Maven, curl, and any required tools
RUN apt-get update && \
    apt-get install -y git curl && \
    curl -fsSL https://apache.mirror.digitalpacific.com.au/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz -o /tmp/maven.tar.gz && \
    mkdir -p /usr/share/maven && \
    tar -xzf /tmp/maven.tar.gz -C /usr/share/maven --strip-components=1 && \
    ln -s /usr/share/maven/bin/mvn /usr/bin/mvn && \
    rm -rf /var/lib/apt/lists/* /tmp/maven.tar.gz

# Verify installations
RUN java -version && \
    mvn -version && \
    git --version

# Set the working directory inside the container
WORKDIR /app

# Copy the application code inside the container (optional)
# COPY . /app

# Define the entry point for your application
# ENTRYPOINT ["java", "-jar", "your-app.jar"]

# Default command (optional)
CMD ["/bin/bash"]
