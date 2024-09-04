podTemplate(containers: [
    containerTemplate(
        name: 'maven', 
        image: 'maven:3.9.6'
        ),
    containerTemplate(
        name: 'git', 
        image: 'alpine/git:latest',)
  ]) {

    node(POD_LABEL) {
        stage('Get a Maven project') {
            container('git') {
                    sh '''
                    echo "git checkout"
                    '''
            }
        }

        stage('Build the code') {
            container('maven') {
                    sh '''
                    echo "Go Build"
                    '''
            }
        }

    }
}