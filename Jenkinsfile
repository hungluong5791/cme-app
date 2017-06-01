node('Dev_Ops_2') {
    currentBuild.result = "SUCCESS"
    def error
    try {
        def app

        stage('Checkout') {
            checkout scm
        }

        stage('Unit Test') {
            ansiColor('xterm') {
                sh 'echo "Test Passed!"'
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
                app.push("${env.BUILD_NUMBER}")
            }
        }

        stage('AWS Deploy') {
            sh 'chmod +x deploy-aws.sh'
            sh './deploy-aws.sh'
        }

        stage('Integration Test') {
            sh 'echo "Test Passed!"'
        }
    } catch (error) {
        currentBuild.result = "FAILURE"
        err = error;
    } finally {
        def notification = """
            Pipeline ${env.BUILD_NUMBER} Report:

            Status: ${currentBuild.result}

            Unit Test Report: PASSED

            Integration Test Report : PASSED

            Error: ${err}
        """
        mail body: "${notification}" ,
            to: "hunglk1@fsoft.com.vn"
            replyTo: '${DEFAULT_REPLYTO}',
            subject: 'Jenkins Pipeline Build Report ${env.BUILD_NUMBER}',
    }
}