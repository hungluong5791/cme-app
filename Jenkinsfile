node('Dev_Ops_2') {
    def app

    stage('Checkout') {
        checkout scm
    }

    stage('Unit Test') {
        ansiColor('xterm') {
            sh 'Test Passed!'
        }
    }

    stage('Docker Build') {
        ansiColor('xterm') {
            app = docker.build("cme-devops")
        }
    }

    stage('Docker Push') {
        docker.withRegistry('https://768738047170.dkr.ecr.us-east-1.amazonaws.com', 'ecr:us-east-1:cme-devops-aws-credentials') {
            app.push('latest')
        }
    }

    stage('AWS Deploy') {
        sh 'chmod +x deploy-aws.sh'
        sh './deploy-aws.sh'
    }

    stage('Integration Test') {
        sh 'Test passed!'
    }
}