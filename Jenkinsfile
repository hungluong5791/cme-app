pipeline {
    agent {
        label 'Dev_Ops_2'
    }

    options {
        buildDiscarder(logRotator(numToKeepStr: '10'))
        skipDefaultCheckout()
        timeout(time: 1, unit: 'HOURS')
        timestamps()
        ansiColor('xterm')
    }

    stages {
        stage('Pre-Build') {
            steps {
                issue = [
                    fields: [
                        project: [key: 'CME'],
                        summary: "JenkinsCI: Build #${env.BUILD_NUMBER}",
                        issuetype: [id: '10011']
                    ]
                ]
                jiraNewIssue issue: issue, site: 'CME JIRA'
            }

            // env.BUILD_TICKET_ID = response.data.id

            // def updatedIssue = issue
            // updatedIssue.transition = ["id": "5"]

            // jiraEditIssue idOrKey: "${env.BUILD_TICKET_ID}", issue = updatedIssue
        }
        
        stage('Checkout') {
            steps {
                checkout scm
                sh 'rm -rf reports/*'
            }
        }

        stage('Unit test') {
            steps {
                // ansiColor('xterm') {
                //     sh "npm install && MOCHAWESOME_REPORTDIR=reports MOCHAWESOME_REPORTFILENAME=mocha-report MOCHAWESOME_REPORTPAGETITLE='Build #${env.BUILD_NUMBER}' npm test"
                // }
            }
        }

        stage('Docker Build') {
            steps {
                // ansiColor('xterm') {
                //     app = docker.build("cme-devops")
                // }
            }
        }

        stage('Docker Push') {
            steps {
                // docker.withRegistry('https://768738047170.dkr.ecr.us-east-1.amazonaws.com', 'ecr:us-east-1:cme-devops-aws-credentials') {
                //     app.push('latest')
                // }
            }
        }

        stage('AWS Deploy Staging') {
            steps {
                // sh 'chmod +x deploy-aws.sh'
                // sh './deploy-aws.sh'
            }
        }

        stage('Integration Test') {
            steps {
                // sleep 13
                // sh 'cd CME_DEMO_DEVOPS_AUTOTEST && mvn clean install && chmod +x drivers/chromedriver_linux64 && java -Dwebdriver.chrome.driver=drivers/chromedriver_linux64 -jar target/Z8.ART-1.0-jar-with-dependencies.jar -planFile Devops.xml -envFile env.properties'
                // sh 'mv CME_DEMO_DEVOPS_AUTOTEST/reports/* reports/'
            }
        }
    }

    post {
        always {
            echo 'Always'
        }
    }
}