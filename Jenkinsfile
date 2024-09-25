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
              - name: docker
                image: docker:20.10.8
                command:
                - cat
                tty: true
              volumes:
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
                    publishHTML([reportDir: 'target/site', reportFiles: 'index.html', reportName: 'HTML Report'])
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

        /*stage('Publish Artifacts') {
            steps {
                container('maven') {
                    sh "curl -u ${DOCKER_CREDENTIALS_ID} -T target/myapp.jar ${ARTIFACTORY_URL}/my-repo/myapp.jar"
                }
            }
        }*/

        stage('Artifacts Upload'){
          steps{
            withAWS(credentials:'aws_keys', region:'us-west-2') {
            s3Upload(
              file: "target/*.jar",
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
                        docker.build("sample-java-app:${env.BUILD_ID}").push("sample-java-app:latest")
                    }
                }
            }
        }

        /*stage('Deploy to Cloud') {
            steps {
                container('maven') {
                    // Assuming you have Kubernetes configurations and AWS CLI installed
                    sh 'kubectl apply -f k8s-deployment.yaml'
                }
            }
        }*/
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
