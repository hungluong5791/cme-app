pipeline {
    agent {
        label 'Dev_Ops_2'
    }

    environment {
        JIRA_SITE = 'CME JIRA'
        JIRA_BASE_URL = 'http://10.88.96.77:8080'
        JIRA_CREDENTIALS = 'cme-jira-credentials'
        JIRA_PROJECT_KEY = 'CMET'
        JIRA_ISSUE_TYPE_BUILD = 10011
        JIRA_TRANSITION_START = 11
        JIRA_TRANSITION_FINISH = 31
        
        DOCKER_IMAGE_NAME = 'cme-devops'
        DOCKER_IMAGE_TAG = 'latest'
        DOCKER_IMAGE_REGISTRY = 'https://768738047170.dkr.ecr.us-east-1.amazonaws.com'
        DOCKER_ECR_CREDENTIALS = 'ecr:us-east-1:cme-devops-aws-credentials'
        DOCKER_REGISTRY_REPO = 'cme-devops'
        DOCKER_IMAGE_URL = "${DOCKER_IMAGE_REGISTRY}/${DOCKER_REGISTRY_REPO}:${DOCKER_IMAGE_TAG}"
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
                    // Create new JIRA build issue
                    issue = [
                        fields: [
                            project: [key: "${JIRA_PROJECT_KEY}"],
                            summary: "[JenkinsCI][STAGING] Build #${env.BUILD_NUMBER}",
                            labels: [
                                "STAGING",
                            ],
                            // assignee: [name: "JenkinsCI"],
                            issuetype: [id: "${JIRA_ISSUE_TYPE_BUILD}"]
                        ]
                    ]
                    // response = jiraNewIssue issue: issue
                    env.BUILD_TICKET_ID = response.data.id

                    // Start the JIRA build issue
                    // jiraTransitionIssue idOrKey: env.BUILD_TICKET_ID, input: [
                    //     transition: [
                    //         id: "${JIRA_TRANSITION_START}",
                    //     ]
                    // ]
                }
            }
        }

        stage('Checkout') {
            steps {
                // Checkout app code
                checkout scm
                // Checkout ART code
                checkout ([
                    $class: 'GitSCM',
                    branches: [[name: 'xray-integrate']],
                    doGenerateSubmoduleConfigurations: false,
                    extensions: [[$class: 'CloneOption', depth: 1, noTags: false, reference: '', shallow: true], [$class: 'RelativeTargetDirectory', relativeTargetDir: 'CME-RnD'],[$class: 'CleanBeforeCheckout']],
                    submoduleCfg: [],
                    userRemoteConfigs: [[credentialsId: 'ec4707cf-c32b-4b1e-a2bf-1409d60cf003', url: 'https://git.fsoft.com.vn/fsoft/CME-RnD.git']]]
                )
                sh 'rm -rf reports/*'
            }
        }

        stage('Unit test') {
            steps {
                // sh "npm install && MOCHAWESOME_REPORTDIR=reports MOCHAWESOME_REPORTFILENAME=mocha-report MOCHAWESOME_REPORTPAGETITLE='Build #${env.BUILD_NUMBER}' npm test"
                sh 'npm install'
                sh 'npm test'
                sh 'mv report.json reports/'
            }
        }

        stage('SonarQube Analysis') {
            environment {
                SONAR_HOME = tool('Sonar')
                // SONAR_HOME = tool('Sonar-Dev')
                SONAR_ENV = 'Sonar'
                SONAR_PROJECT_NAME = 'CME_DEMO'
                SONAR_PROJECT_KEY = 'CME_DEMO'
                SONAR_PROJECT_VERSION = '1.0'
                SONAR_SOURCE = "${env.WORKSPACE}"
                // SONAR_SCM_DISABLED = 'true'
                SONAR_EXCLUSION = "test/**, node_modules/**, CME-RnD/**"
            }

            steps {
                withSonarQubeEnv("${SONAR_ENV}") {
                    sh "${SONAR_HOME}/bin/sonar-scanner -Dsonar.login=${SONAR_LOGIN} -Dsonar.password=${SONAR_PASSWORD} -Dsonar.jdbc.url=\"${SONAR_JDBC_URL}\" -Dsonar.jdbc.username=${SONAR_JDBC_USERNAME} -Dsonar.jdbc.password=${SONAR_JDBC_PASSWORD} -Dsonar.projectName=${SONAR_PROJECT_NAME} -Dsonar.projectVersion=${SONAR_PROJECT_KEY} -Dsonar.projectKey=${SONAR_PROJECT_KEY} -Dsonar.sources=${SONAR_SOURCE} -Dsonar.exclusions=\"${SONAR_EXCLUSION}\""
                }
            }
        }

        stage('Docker Build') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE_NAME}")
                }
            }
        }

        stage('Docker Push') {
            steps {
                script {
                    docker.withRegistry("${DOCKER_IMAGE_REGISTRY}", "${DOCKER_ECR_CREDENTIALS}") {
                        docker.image("${DOCKER_IMAGE_NAME}").push("${DOCKER_IMAGE_TAG}")
                    }
                }
            }
        }

        stage('AWS Deploy Staging') {
            steps {
                sh 'chmod +x deploy-aws.sh'
                sh './deploy-aws.sh'
            }
        }

        stage('Integration Test') {
            steps {
                parallel(
                    chrome: {
                        sh 'cd CME-RnD && mvn install:install-file -Dfile=libs/z8-art-core-1.0.jar -DpomFile=libs/pom-core.xml'
                        sh 'cd CME-RnD && mvn install:install-file -Dfile=libs/z8-art-ui-1.2.jar -DpomFile=libs/pom-ui.xml'
                        sh 'cd CME-RnD && mvn clean install'
                        sh 'cd CME-RnD && chmod +x drivers/chromedriver_linux64'
                        sh 'cd CME-RnD && java -Dwebdriver.chrome.driver=drivers/chromedriver_linux64 -jar target/Z8.ART-1.0-jar-with-dependencies.jar -planFile Devops.xml -envFile env.properties'
                        sh 'mv -t reports CME-RnD/reports/*.xlsx CME-RnD/reports/*.html CME-RnD/reports/*.json'
                    },
                    firefox: {
                        sleep 105
                    },
                    ie: {
                        sleep 100
                    },
                    failFast: false
                )
            }
        }
    }

    post {
        always {
            // Mark Build as Done
            // jiraTransitionIssue idOrKey: env.BUILD_TICKET_ID, input: [
            //     transition: [
            //         id: "${JIRA_TRANSITION_FINISH}",
            //     ]
            // ]

            // Upload Xray result
            // withCredentials([usernamePassword(credentialsId: "${JIRA_CREDENTIALS}", passwordVariable: 'JIRA_PASSWORD', usernameVariable: 'JIRA_USERNAME')]) {
            //     sh "curl -H 'Content-Type: application/json' -X POST -u ${JIRA_USERNAME}:${JIRA_PASSWORD} --data @reports/XrayReport.json ${JIRA_BASE_URL}/rest/raven/1.0/import/execution"
            // }

            // Workaround while waiting for jiraAttach
            // withCredentials([usernamePassword(credentialsId: "${JIRA_CREDENTIALS}", passwordVariable: 'JIRA_PASSWORD', usernameVariable: 'JIRA_USERNAME')]) {
            //     sh "find ./reports/ -regextype posix-extended -regex '.*\\.(html|xlsx)' -exec curl -D- -u ${JIRA_USERNAME}:${JIRA_PASSWORD} -X POST -H 'X-Atlassian-Token: no-check' -F 'file=@{}' ${JIRA_BASE_URL}/rest/api/2/issue/${env.BUILD_TICKET_ID}/attachments \\;"
            // }

            // Archive reports
            // archiveArtifacts allowEmptyArchive: true, artifacts: 'reports/*'

            // Include test reports in issue description
            script {
                env.testCasesExecutionSummary = """
                *UNIT TEST EXECUTION SUMMARY*

                | *Test Case* | *Status* |
                """
                def mochaReport = readJSON file: 'reports/report.json'
                def mochaFailures = mochaReport.failures
                def mochaPasses = mochaReport.passes

                for (mochaTest in mochaFailures) {
                    def testCaseTitle = mochaTest.fullTitle
                    def testCaseStatus = "FAIL"
                    testRunSummary = "| ${testCaseTitle} | ${testCaseStatus} | \n"
                    env.testCasesExecutionSummary += testRunSummary
                }
                for (mochaTest in mochaPasses) {
                    def testCaseTitle = mochaTest.fullTitle
                    def testCaseStatus = "PASS"
                    testRunSummary = "| ${testCaseTitle} | ${testCaseStatus} | \n"
                    env.testCasesExecutionSummary += testRunSummary
                }

                env.testCasesExecutionSummary += "\n\n"

                env.testCasesExecutionSummary += """
                *INTEGRATION TEST EXECUTION SUMMARY*

                | *Test Case* | *Status* |
                """

                def xrayReport = readJSON file: 'reports/XrayReport.json'
                def xrayTests = xrayReport.tests

                for (xrayTest in xrayTests) {
                    def testCaseId = xrayTest.testKey
                    def testCaseUrl = env.JIRA_BASE_URL + "/browse/${testCaseId}"
                    def testCaseStatus = xrayTest.status

                    testRunSummary = "| [${testCaseId}|${testCaseUrl}] | ${testCaseStatus} | \n"
                    env.testCasesExecutionSummary += testRunSummary
                }
            }
            // jiraEditIssue idOrKey: env.BUILD_TICKET_ID, issue: [
            //     fields: [
            //         project: [key: "${JIRA_PROJECT_KEY}"],
            //         description: "${env.testCasesExecutionSummary}",
            //         issuetype: [id: "${JIRA_ISSUE_TYPE_BUILD}"]
            //     ]
            // ]
        }

        success {
            // jiraEditIssue idOrKey: env.BUILD_TICKET_ID, issue: [
            //     fields: [
            //         project: [key: "${JIRA_PROJECT_KEY}"],
            //         customfield_10036: [value: 'SUCCESS'],
            //         issuetype: [id: "${JIRA_ISSUE_TYPE_BUILD}"]
            //     ]
            // ]

            emailext body: """
            <p>Build URL: ${env.BUILD_URL}</p>

            <p>Status: SUCCESS</p>

            <p>Please find attached the Log and Test Reports for this build.</p>

            <p>To promote this build to Production please visit: http://10.88.96.73:8081/jenkins/job/CME_DevOps_Demo_Production/</p>
            """, mimeType: 'text/html', subject: "[Jenkins][${env.JOB_NAME}] Build #${env.BUILD_NUMBER}", to: "hunglk1@fsoft.com.vn,dunghv2@fsoft.com.vn", attachLog: true, attachmentsPattern: "reports/*"
        }

        failure {
            // jiraEditIssue idOrKey: env.BUILD_TICKET_ID, issue: [
            //     fields: [
            //         project: [key: "${JIRA_PROJECT_KEY}"],
            //         customfield_10036: [value: 'FAILURE'],
            //         issuetype: [id: "${JIRA_ISSUE_TYPE_BUILD}"]
            //     ]
            // ]

            emailext body: """
            <p>Build URL: ${env.BUILD_URL}</p>

            <p>Status: FAILURE</p>

            Please find attached the Log and Test Reports for this build.

            """, mimeType: 'text/html', subject: "[Jenkins][${env.JOB_NAME}] Build #${env.BUILD_NUMBER}", to: "hunglk1@fsoft.com.vn,dunghv2@fsoft.com.vn", attachLog: true, attachmentsPattern: "reports/*"
        }
    }
}
