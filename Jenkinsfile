pipeline {
    agent {
        kubernetes {
            label 'java-pipeline'
            yaml """
            apiVersion: v1
            kind: Pod
            spec:
              containers:
              - name: maven
                image: maven:3.8.1-jdk-11
                command:
                - cat
                tty: true
                volumeMounts:
                - name: maven-cache
                  mountPath: /root/.m2
                - name: shared-workspace
                  mountPath: /workspace  # Mounting shared path in Maven container
              - name: docker
                image: docker:20.10.8
                command:
                - cat
                tty: true
                volumeMounts:
                - name: shared-workspace
                  mountPath: /workspace  # Mounting shared path in Docker container
                - name: docker-sock
                  mountPath: /var/run/docker.sock
              - name: kubectl
                image: bitnami/kubectl:latest
                command:
                - cat
                tty: true
              volumes:
              - name: shared-workspace
                emptyDir: {}  # An empty directory for sharing data between containers
              - name: maven-cache
                emptyDir: {}
              - name: docker-sock
                hostPath:
                  path: /var/run/docker.sock
            """
        }
    }
    
    environment {
        DOCKER_CREDENTIALS_ID = 'tushar3569-docker'  // DockerHub or JFrog credentials
        SONARQUBE_CREDENTIALS_ID = 'sonarqube-credentials' // SonarQube credentials
        ARTIFACTORY_URL = 'https://<your-artifactory-url>' // JFrog Artifactory URL
        AWS_CREDENTIALS = 'aws_keys'
    }

    stages {
        stage('Checkout Code') {
            steps {
                container('maven') {
                    git credentialsId: 'tsingh.devops-github', branch: 'main', url: 'https://github.com/tsingh-PIP/sample-java-app.git'
                }
            }
        }

        stage('Maven Build') {
            steps {
                container('maven') {
                    sh 'mvn clean install'
                }
            }
        }

        stage('Run Unit Tests') {
            steps {
                container('maven') {
                    sh 'mvn test'
                    junit '**/target/surefire-reports/*.xml'
                    publishHTML([reportDir: 'target/site', reportFiles: 'index.html', reportName: 'HTML Report',keepAll: 'true',alwaysLinkToLastBuild: 'true', allowMissing: 'false'])
                }
            }
        }

        stage('Code Coverage') {
            steps {
                container('maven') {
                    sh 'mvn jacoco:report'
                    jacoco(execPattern: '**/target/*.exec', classPattern: '**/target/classes', sourcePattern: '**/src/main/java', exclusionPattern: '**/src/test*')
                }
            }
        }

        /*stage('Static Code Analysis') {
            steps {
                container('maven') {
                    withSonarQubeEnv('SonarQube') {
                        sh 'mvn sonar:sonar'
                    }
                }
            }
        }*/

        stage('Artifacts Upload'){
          steps{
            withAWS(credentials:'aws_keys', region:'us-west-2') {
            s3Upload(
              file: "target/spring-boot-2-hello-world-1.0.2-SNAPSHOT.jar",
              bucket: 'td-sample-java-app',
              path: ''
              )
            }
          }
        }

        stage('Docker Build & Push') {
            steps {
                container('docker') {
                    script {
                        withCredentials([usernamePassword(credentialsId: "${DOCKER_CREDENTIALS_ID}", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                            sh 'docker login -u $DOCKER_USER -p $DOCKER_PASS'
                            def image = docker.build("tushar3569/sample-java-app:latest")
                            image.push("latest")
                            sh 'docker logout'
                        }
                    }
                }
            }
        }

        stage('Deploy to Cloud') {
            steps {
                container('maven') {
                    // Assuming you have Kubernetes configurations and AWS CLI installed
                    sh 'curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"'
                    sh 'curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"'
                    sh 'sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl'
                    sh 'kubectl create namespace java-app'
                    sh 'kubectl apply -f k8s/sample-java-app-deployment.yaml -n java-app'
                    sh 'kubectl apply -f k8s/sample-java-app-service.yaml -n java-app'
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
        success {
            echo 'Build and Deployment succeeded!'
        }
        failure {
            echo 'Build or Deployment failed.'
        }
    }
}
