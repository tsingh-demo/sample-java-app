podTemplate(containers: [
    containerTemplate(
        name: 'ubuntu',
        image: 'ubuntu:latest',
        command: 'cat',
        ttyEnabled: true
    ),
    containerTemplate(
        name: 'maven',
        image: 'maven:3.8.4-openjdk-11',
        command: 'cat',
        ttyEnabled: true
    )
]) {
    pipeline {
        agent {
            kubernetes {
                label 'mypod'
            }
        }
        stages {
            stage('Checkout') {
                steps {
                    container('ubuntu') {
                        sh 'apt-get update && apt-get install -y git'  // Install Git if necessary
                        git branch: 'main', url: 'https://github.com/tsingh-PIP/sample-java-app.git'
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
}
