pipeline {
    agent {
        kubernetes {
            label 'docker-agent'
            defaultContainer 'docker'
            podTemplate(containers: [
                containerTemplate(
                    name: 'maven',
                    image: 'maven:3.6.3', // Specify a Maven version
                    command: 'cat',
                    ttyEnabled: true
                ),
                containerTemplate(
                    name: 'docker',
                    image: 'docker:19.03',
                    command: 'dockerd-entrypoint.sh',
                    ttyEnabled: true,
                    privileged: true,
                    volumeMounts: [
                        new org.csanchez.jenkins.plugins.kubernetes.VolumeMount(
                            mountPath: '/var/run/docker.sock',
                            name: 'docker-sock'
                        )
                    ]
                )
            ], volumes: [
                new org.csanchez.jenkins.plugins.kubernetes.volumes.HostPathVolume(
                    name: 'docker-sock',
                    path: '/var/run/docker.sock'
                )
            ])
        }
    }

    environment {
        SONAR_TOKEN = credentials('sonarqube-jenkins')
        S3_BUCKET = 'td-sample-java-app'
        AWS_REGION = 'us-west-2'
        DOCKER_CREDENTIALS_ID = 'docker-login'
        DOCKER_REGISTRY = 'docker.io'
        IMAGE_NAME = 'sample-java-app:latest'
    }

    stages {
        stage('Get a Maven project') {
            steps {
                git credentialsId: 'github_tsinghdevops', branch: 'main', url: 'https://github.com/tsingh-PIP/sample-java-app.git'
                container('maven') {
                    stage('Build a Maven project') {
                        sh 'ls -ltr'
                        sh 'mvn clean verify'
                        sh 'ls -ltra target/'
                    }
                }
            }
        }

        stage('Artifacts Upload') {
            steps {
                withAWS(credentials: 'aws-s3-upload', region: 'us-west-2') {
                    s3Upload(
                        file: "target/spring-boot-2-hello-world-1.0.2-SNAPSHOT.jar",
                        bucket: "${env.S3_BUCKET}",
                        path: ''
                    )
                }
            }
        }

        stage('Publish JaCoCo Report') {
            steps {
                jacoco(
                    execPattern: 'target/jacoco.exec',
                    classPattern: 'target/classes',
                    sourcePattern: 'src/main/java',
                    inclusionPattern: '**/*.java',
                    exclusionPattern: ''
                )
            }
        }

        stage('Publish Surefire Report') {
            steps {
                publishHTML([
                    reportDir: 'target/surefire-reports',
                    reportFiles: 'surefire-report.html',
                    reportName: 'Surefire Test Report',
                    keepAll: true,
                    alwaysLinkToLastBuild: true
                ])
            }
        }

        stage('Build Docker Image') {
            steps {
                container('docker') {
                    script {
                        // Build the Docker image
                        def customImage = docker.build("${env.IMAGE_NAME}")
                    }
                }
            }
        }

        /* Uncomment if you need to push the Docker image
        stage('Push Docker Image') {
            steps {
                container('docker') {
                    script {
                        docker.withRegistry("https://${env.DOCKER_REGISTRY}", "${env.DOCKER_CREDENTIALS_ID}") {
                            docker.image("${env.IMAGE_NAME}").push('latest')
                        }
                    }
                }
            }
        }
        */

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarCloud') {
                    sh """
                    mvn sonar:sonar \
                        -Dsonar.projectKey=sample-java-code \
                        -Dsonar.host.url=http://localhost:9000 \
                        -Dsonar.login=${env.SONAR_TOKEN}
                    """
                }
            }
        }

        /* Uncomment if you need to check the Quality Gate
        stage("Quality Gate") {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
        */
    }
}
