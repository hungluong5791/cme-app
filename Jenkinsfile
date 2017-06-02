node('Dev_Ops_2') {
    currentBuild.result = "SUCCESS"
    def subject = "[Jenkins][${env.JOB_NAME}] Build #${env.BUILD_NUMBER}"
    def recipient = "hunglk1@fsoft.com.vn"

    try {
        def app
        
        stage('Checkout') {
            checkout scm
            sh 'rm reports/*'
        }

        stage('Unit test') {
            ansiColor('xterm') {
                sh "npm install && MOCHAWESOME_REPORTDIR=reports MOCHAWESOME_REPORTFILENAME=mocha-report MOCHAWESOME_REPORTPAGETITLE='Build #${env.BUILD_NUMBER}' npm test"
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

        stage('AWS Deploy Staging') {
            sh 'chmod +x deploy-aws.sh'
            sh './deploy-aws.sh'
        }

        stage('Integration Test') {
            sleep 13
            sh 'cd CME_DEMO_DEVOPS_AUTOTEST && mvn clean install && chmod +x drivers/chromedriver_linux64 && java -Dwebdriver.chrome.driver=drivers/chromedriver_linux64 -jar target/Z8.ART-1.0-jar-with-dependencies.jar -planFile Devops.xml -envFile env.properties'
            sh 'mv CME_DEMO_DEVOPS_AUTOTEST/reports/* reports/'
        }
    } catch (error) {
        currentBuild.result = "FAILURE"
    } finally {
        def notification = """
        <p>Build URL: ${env.BUILD_URL}</p>

        <p>Status: ${currentBuild.result}</p>

        Please find attached the Log and Test Reports for this build.
        """

        emailext body: notification, mimeType: 'text/html', subject: subject, to: recipient, attachLog: true, attachmentsPattern: "reports/*"
    }
}