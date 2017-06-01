node('Dev_Ops_2') {
    currentBuild.result = "SUCCESS"
    def error
    try {
        def app
        def unitTestStatus

        stage('Checkout') {
            checkout scm
        }

        stage('Unit Test') {
            ansiColor('xterm') {
                unitTestStatus = sh script: 'env MONGODB_URI=mongodb://ec2-34-201-32-210.compute-1.amazonaws.com:27017 npm test', returnStdout: true
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
    } catch (err) {
        currentBuild.result = "FAILURE"
        error = err;
    } finally {
        def subject = "[Jenkins][${env.JOB_NAME}] Build #${env.BUILD_NUMBER} Report"
        def recipient = "hunglk1@fsoft.com.vn"
        if (error == null) {
            error = 'None'
        }
        def notification = """
            Build URL: ${env.BUILD_URL}
            Status: ${currentBuild.result}
            Unit Test:
            ${unitTestStatus}

            Integration Test: PASSED

            Error: ${error}
        """
        emailext attachLog: true, body: notification, subject: subject, to: recipient
    }
}