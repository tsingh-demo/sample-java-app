 podTemplate(containers: [containerTemplate(image: 'maven', name: 'maven', command: 'cat', ttyEnabled: true)]) {
    node(POD_LABEL) {
        stage('Get a Maven project') {
//            git 'https://github.com/tsingh-PIP/sample-java-app.git'
            container('maven') {
                stage('Build a Maven project') {
                    sh 'ls -ltr'
                    sh 'mvn clean package'
                    sh 'ls -ltra target/'
                }
            }
        }
    }
}