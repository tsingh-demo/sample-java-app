 podTemplate(containers: [containerTemplate(image: 'maven', name: 'maven', command: 'cat', ttyEnabled: true)]) {

    environment {
        SONAR_TOKEN = credentials('sonarqube-jenkins')  // Use the SonarCloud token
        S3_BUCKET = 'td-sample-java-app'
    }

    node(POD_LABEL) {
        stage('Get a Maven project') {
            git credentialsId: 'github_tsinghdevops', branch: 'main', url: 'https://github.com/tsingh-PIP/sample-java-app.git'
            container('maven') {
                stage('Build a Maven project') {
                    sh 'ls -ltr'
                    sh 'mvn clean package'
                    sh 'ls -ltra target/'
                }
            }
        }
        stage('Upload to S3') {
            withAWS(region: "${AWS_REGION}", credentials: 'aws-s3-upload') {  // Replace with your AWS Credentials ID
                s3Upload(file: 'target/spring-boot-2-hello-world-1.0.2-SNAPSHOT.jar', bucket: "${S3_BUCKET}", path: 'artifacts/')
            }
        }

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