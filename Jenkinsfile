pipeline {
    agent {
        label 'Dev_Ops_2'
    }

    environment {
        JIRA_SITE = 'CME JIRA'
        JIRA_BASE_URL = 'http://10.88.96.79:8080'
        JIRA_CREDENTIALS = 'cme-jira-credentials'
        JIRA_PROJECT_KEY = 'CME'
        JIRA_ISSUE_TYPE_BUILD = 10011
        JIRA_TRANSITION_START = 11
        JIRA_TRANSITION_FINISH = 21
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
                script {
                    issue = [
                        fields: [
                            project: [key: "${JIRA_PROJECT_KEY}"],
                            summary: "JenkinsCI: Build #${env.BUILD_NUMBER}",
                            issuetype: [id: "${JIRA_ISSUE_TYPE_BUILD}"]
                        ]
                    ]
                    response = jiraNewIssue issue: issue
                    env.BUILD_TICKET_ID = response.data.id

                    transition =  [
                        transition: [
                            id: "${JIRA_TRANSITION_START}",
                        ]
                    ]
                    jiraTransitionIssue idOrKey: env.BUILD_TICKET_ID, input: transition
                }
            }
        }
        
        stage('Checkout') {
            steps {
                echo 'Placeholder'
                // checkout scm
                // sh 'rm -rf reports/*'
            }
        }

        stage('Unit test') {
            steps {
                echo 'Placeholder'
                // ansiColor('xterm') {
                //     sh "npm install && MOCHAWESOME_REPORTDIR=reports MOCHAWESOME_REPORTFILENAME=mocha-report MOCHAWESOME_REPORTPAGETITLE='Build #${env.BUILD_NUMBER}' npm test"
                // }
            }
        }

        stage('Docker Build') {
            steps {
                echo 'Placeholder'
                // ansiColor('xterm') {
                //     app = docker.build("cme-devops")
                // }
            }
        }

        stage('Docker Push') {
            steps {
                echo 'Placeholder'
                // docker.withRegistry('https://768738047170.dkr.ecr.us-east-1.amazonaws.com', 'ecr:us-east-1:cme-devops-aws-credentials') {
                //     app.push('latest')
                // }
            }
        }

        stage('AWS Deploy Staging') {
            steps {
                echo 'Placeholder'
                // sh 'chmod +x deploy-aws.sh'
                // sh './deploy-aws.sh'
            }
        }

        stage('Integration Test') {
            steps {
                echo 'Placeholder'
                // sleep 13
                // sh 'cd CME_DEMO_DEVOPS_AUTOTEST && mvn clean install && chmod +x drivers/chromedriver_linux64 && java -Dwebdriver.chrome.driver=drivers/chromedriver_linux64 -jar target/Z8.ART-1.0-jar-with-dependencies.jar -planFile Devops.xml -envFile env.properties'
                // sh 'mv CME_DEMO_DEVOPS_AUTOTEST/reports/* reports/'
            }
        }
    }

    post {
        always {
            jiraTransitionIssue idOrKey: env.BUILD_TICKET_ID, input: [
                transition: [
                    id: "${JIRA_TRANSITION_FINISH}",
                ]
            ]

            jiraEditIssue idOrKey: env.BUILD_TICKET_ID, issue: [
                fields: [
                    project: [key: "${JIRA_PROJECT_KEY}"],
                    customfield_10036: currentBuild.result,
                    issuetype: [id: "${JIRA_ISSUE_TYPE_BUILD}"]
                ]
            ]

            // Workaround while waiting for jiraAttach
            echo "${currentBuild.result}"
            withCredentials([usernamePassword(credentialsId: "${JIRA_CREDENTIALS}", passwordVariable: 'JIRA_PASSWORD', usernameVariable: 'JIRA_USERNAME')]) {
                sh "curl -D- -u ${JIRA_USERNAME}:${JIRA_PASSWORD} -X POST -H 'X-Atlassian-Token: no-check' -F 'file=@Jenkinsfile' ${JIRA_BASE_URL}/rest/api/2/issue/${env.BUILD_TICKET_ID}/attachments"
            }

            
        }
    }
}