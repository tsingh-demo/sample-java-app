 podTemplate(containers: [containerTemplate(image: 'maven', name: 'maven', command: 'cat', ttyEnabled: true)]) {

    environment {
        SONAR_TOKEN = credentials('sonarqube-jenkins')  // Use the SonarCloud token
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
        stage('SonarCloud Analysis') {
            steps {
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
        }

        stage("Quality Gate") {
            steps {
                // Wait for SonarCloud to complete analysis
                timeout(time: 5, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
    }
}