podTemplate(containers: [
    containerTemplate(
        name: 'maven', 
        image: 'maven:latest'
        )
  ]) {

    node(POD_LABEL) {
        stage('Get a Maven project') {
            container('maven') {
                    sh '''
                    mvn clean package
                    '''
            }
        }

        /*stage('Build the code') {
            container('maven') {
                    sh '''
                    echo "Go Build"
                    '''
            }
        }*/

    }
}