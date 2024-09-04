podTemplate(containers: [
    containerTemplate(
        name: 'maven', 
        image: 'maven:3.9.6'
        )
  ]) {

    node(POD_LABEL) {
        stage('Checkout') {
            container('jnlp') {
                    sh '''
                    echo "Checkout"
                    '''
            }
        }

        stage('Build') {
            container('maven') {
                    sh '''
                    echo "Go Build"
                    '''
            }
        }
    }
}