podTemplate(containers: [
    containerTemplate(
        name: 'ubuntu', 
        image: 'ubuntu:latest'
        )
  ]) {

    node(POD_LABEL) {
        stage("Checkout") {
            steps {
                    sh '''
                     git clone https://github.com/tsingh-PIP/sample-java-app.git
                    '''
            }
        }

        stage("Build") {
            steps {
                container("ubuntu") {
                        sh '''
                        echo "Go Build"
                        '''
                }
            }
        }

    }
}