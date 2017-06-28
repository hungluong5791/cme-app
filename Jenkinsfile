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
                checkout scm
                checkout([
                    $class: 'GitSCM', 
                    branches: [[name: 'xray-integrate']], 
                    doGenerateSubmoduleConfigurations: false, 
                    extensions: [[$class: 'CloneOption', depth: 1, noTags: false, reference: '', shallow: true], [$class: 'RelativeTargetDirectory', relativeTargetDir: 'CME-RnD']], 
                    submoduleCfg: [], 
                    userRemoteConfigs: [[credentialsId: 'ec4707cf-c32b-4b1e-a2bf-1409d60cf003', url: 'https://git.fsoft.com.vn/fsoft/CME-RnD.git']]])
            }
        }

        stage('Unit test') {
            steps {
                sh "npm install && MOCHAWESOME_REPORTDIR=reports MOCHAWESOME_REPORTFILENAME=mocha-report MOCHAWESOME_REPORTPAGETITLE='Build #${env.BUILD_NUMBER}' npm test"
            }
        }

        stage('Docker Build') {
            steps {
                script {
                    docker.build("cme-devops")
                }
            }
        }

        stage('Docker Push') {
            steps {
                script {
                    docker.withRegistry('https://768738047170.dkr.ecr.us-east-1.amazonaws.com', 'ecr:us-east-1:cme-devops-aws-credentials') {
                        docker.image('cme-devops').push('latest')
                    }
                }
            }
        }

        stage('AWS Deploy Staging') {
            environment {
                CLUSTER="cme-devops-app"
                SERVICE="cme-devops-app"
                TASK_FAMILY="cme-devops-app"

                DOCKER_REGISTRY="768738047170.dkr.ecr.us-east-1.amazonaws.com"
                DOCKER_REPO="cme-devops"
                DOCKER_TAG="latest"
                DOCKER_IMAGE="${DOCKER_REGISTRY}/${DOCKER_REPO}:${DOCKER_TAG}"
            }

            steps {
                sh 'chmod +x deploy-aws.sh'
                sh './deploy-aws.sh'
            }
        }

        stage('Integration Test') {
            steps {
                // sh 'git clone -b xray-integrate https://git.fsoft.com.vn/fsoft/CME-RnD.git --depth=1'
                sh 'cd CME-RnD && mvn install:install-file -Dfile=libs/z8-art-core-1.0.jar -DpomFile=libs/pom-core.xml'
                sh 'cd CME-RnD && mvn install:install-file -Dfile=libs/z8-art-ui-1.2.jar -DpomFile=libs/pom-ui.xml'
                sh 'cd CME-RnD && mvn clean install'
                sh 'cd CME-RnD && chmod +x drivers/chromedriver_linux64'
                sh 'cd CME-RnD && java -Dwebdriver.chrome.driver=drivers/chromedriver_linux64 -jar target/Z8.ART-1.0-jar-with-dependencies.jar -planFile Devops.xml -envFile env.properties'
                sh 'mv CME-RnD/reports/* reports/'
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

            echo "Upload test result to Jira"
            withCredentials([usernamePassword(credentialsId: "${JIRA_CREDENTIALS}", passwordVariable: 'JIRA_PASSWORD', usernameVariable: 'JIRA_USERNAME')]) {
                sh "curl -H 'Content-Type: application/json' -X POST -u ${JIRA_USERNAME}:${JIRA_PASSWORD} --data @CME-RnD/report/XrayReport.json ${JIRA_BASE_URL}/rest/raven/1.0/import/execution"
            }
            
            // Workaround while waiting for jiraAttach
            withCredentials([usernamePassword(credentialsId: "${JIRA_CREDENTIALS}", passwordVariable: 'JIRA_PASSWORD', usernameVariable: 'JIRA_USERNAME')]) {
                sh "find ./reports/ -regextype posix-extended -regex '.*\\.(html|xlxs)' -exec curl -D- -u ${JIRA_USERNAME}:${JIRA_PASSWORD} -X POST -H 'X-Atlassian-Token: no-check' -F 'file=@{}' ${JIRA_BASE_URL}/rest/api/2/issue/${env.BUILD_TICKET_ID}/attachments \\;"
            }
        }

        success {
            jiraEditIssue idOrKey: env.BUILD_TICKET_ID, issue: [
                fields: [
                    project: [key: "${JIRA_PROJECT_KEY}"],
                    customfield_10036: [value: 'SUCCESS'],
                    issuetype: [id: "${JIRA_ISSUE_TYPE_BUILD}"]
                ]
            ]
        }            

        failure {
            jiraEditIssue idOrKey: env.BUILD_TICKET_ID, issue: [
                fields: [
                    project: [key: "${JIRA_PROJECT_KEY}"],
                    customfield_10036: [value: 'FAILURE'],
                    issuetype: [id: "${JIRA_ISSUE_TYPE_BUILD}"]
                ]
            ]
        }
    }
}