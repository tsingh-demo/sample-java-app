podTemplate(containers: [
    containerTemplate(
        name: 'maven', 
        image: 'maven:latest'
        )
  ]) {

    node(POD_LABEL) {
        stage('Get a Maven project') {
            steps {
                    sh '''
                     git clone https://github.com/tsingh-PIP/sample-java-app.git
                    '''
            }
        }

        stage('Build the code') {
            steps {
                container('maven') {
                        sh '''
                        echo "Go Build"
                        '''
                }
            }
        }

    }
}