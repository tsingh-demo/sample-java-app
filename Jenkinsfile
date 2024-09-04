pipeline {
    agent {
        kubernetes {
            podTemplate(containers: [
                containerTemplate(
                    name: 'ubuntu', 
                    image: 'ubuntu:latest', 
                    ttyEnabled: true, 
                    command: 'cat'
                ),
                containerTemplate(
                    name: 'maven', 
                    image: 'maven:3.8.4-openjdk-11', 
                    ttyEnabled: true, 
                    command: 'cat'
                )
            ]) 
        }
    }
    stages {
        stage('Checkout') {
            steps {
                container('ubuntu') {
                    sh 'apt-get update && apt-get install -y git'  // Install Git if necessary
                    git branch: 'main', url: 'https://github.com/your-repo/your-project.git'
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
    }
    post {
        always {
            cleanWs()
        }
    }
}
