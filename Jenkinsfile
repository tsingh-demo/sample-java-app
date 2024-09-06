 podTemplate(containers: [containerTemplate(image: 'maven', name: 'maven', command: 'cat', ttyEnabled: true)]) {

    environment {
        SONAR_TOKEN = credentials('sonarqube-jenkins')  // Use the SonarCloud token
        S3_BUCKET = 'td-sample-java-app'
        AWS_REGION = 'us-west-2'
        DOCKER_CREDENTIALS_ID = 'docker-login' // ID of Docker credentials in Jenkins
        DOCKER_REGISTRY = 'https://hub.docker.com/' // E.g., 'docker.io' or your private registry URL
        IMAGE_NAME = 'sample-java-app' // Docker image name
    }

    node(POD_LABEL) {
        stage('Get a Maven project') {
            git credentialsId: 'github_tsinghdevops', branch: 'main', url: 'https://github.com/tsingh-PIP/sample-java-app.git'
            container('maven') {
                stage('Build a Maven project') {
                    sh 'ls -ltr'
                    sh 'mvn clean verify'
                    sh 'ls -ltra target/'
                }
            }
        }
        stage('Artifacts Upload'){
            withAWS(credentials:'aws-s3-upload', region:'us-west-2') {
            s3Upload(
              file: "target/spring-boot-2-hello-world-1.0.2-SNAPSHOT.jar",
              bucket: 'td-sample-java-app',
              path: ''
              )
          }
        }
        stage('Publish JaCoCo Report') {
            jacoco(
                execPattern: 'target/jacoco.exec',
                classPattern: 'target/classes',
                sourcePattern: 'src/main/java',
                inclusionPattern: '**/*.java',
                exclusionPattern: ''
            )
        }
        stage('Publish Surefire Report') {
            publishHTML([
                reportDir: 'target/surefire-reports',  // Correct directory
                reportFiles: 'surefire-report.html',  // HTML report file
                reportName: 'Surefire Test Report',   // Name of the report in Jenkins
                keepAll: true,
                alwaysLinkToLastBuild: true
            ])
        }
        stage('Push Docker Image') {
            script {
                docker.withRegistry("https://"+${DOCKER_REGISTRY}, ${DOCKER_CREDENTIALS_ID}) {
                    docker.image(${IMAGE_NAME}+":latest").push('latest')
                }
            }
        }
        /*stage('Upload to S3') {
            withCredentials([[
                $class: 'AmazonWebServicesCredentialsBinding',
                credentialsId: "aws-s3-upload",
                accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
            ]]) {  // Replace with your AWS Credentials ID
                s3Upload(file: 'target/spring-boot-2-hello-world-1.0.2-SNAPSHOT.jar', bucket: "${env.S3_BUCKET}"", path: "/")
            }
        }*/

        /*stage('SonarCloud Analysis') {
            withSonarQubeEnv('SonarCloud') {  // The name you gave the SonarQube instance in Jenkins settings
                sh """
                mvn sonar:sonar \
                    -Dsonar.projectKey=tsingh-PIP_sample-java-app \
                    -Dsonar.organization=tsingh-PIP \
                    -Dsonar.host.url=https://sonarcloud.io \
                    -Dsonar.login=${env.SONAR_TOKEN}
                """
            }
        }

        stage("Quality Gate") {
            // Wait for SonarCloud to complete analysis
            timeout(time: 5, unit: 'MINUTES') {
                waitForQualityGate abortPipeline: true
            }
        }*/
    }
}