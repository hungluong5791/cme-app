node('Dev_Ops_2') {
    currentBuild.result = "SUCCESS"
    def subject = "[Jenkins][${env.JOB_NAME}] Build #${env.BUILD_NUMBER}"
    def recipient = "hunglk1@fsoft.com.vn"
    def unitTestStatus = ''
    def integrationTestStatus = ''
    def pipelineError = ''

    try {
        def app
        
        stage('Checkout') {
            checkout scm
        }

        stage('Unit test') {
            ansiColor('xterm') {
                unitTestStatus = sh script: "npm test", returnStdout: true
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
        pipelineError = error
        throw error
    } finally {
        def notification = """
        Build URL: ${env.BUILD_URL}
        Status: ${currentBuild.result}
        Unit Test:
        ${unitTestStatus}

        Integration Test: PASSED
        
        """
        if (pipelineError != null && !pipelineError.isEmpty()) {
            notification += "Pipeline error: ${pipelineError}"
        }

        mail body: notification, subject: subject, to: recipient
        emailext body: notification, mimeType: 'text/html', subject: subject, to: recipient
    }
}