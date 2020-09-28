pipeline {
    agent any
    options {
        preserveStashes()
        timestamps()
        ansiColor('xterm')
    }
    stages {
        stage('CHECKOUT') {
            steps {
                checkout scm
                git credentialsId: 'GIT_CREDS', url: 'https://github.com/pravi1991/ci-cd.git'            
                stash 'elk'
            }
        }
        stage('STATIC CODE ANALYSIS') {
            agent {
                docker {
                    image 'kennethreitz/pipenv:latest'
                    args '-u root --privileged -v /var/run/docker.sock:/var/run/docker.sock'
                    label 'slave'
                }
            }
            steps {
                unstash 'elk'
                script {
                    sh "pipenv install"
                    sh "pipenv run pip install checkov"
                    sh "pipenv run checkov --framework kubernetes -d k8s-manifests -o junitxml -c `cat tests/terratest/check_list.txt` > result.xml || true"
                }
            }
        }
    
        stage('Infrastructure testing') {    
            steps {
                unstash 'elk'
                sh 'scripts/init.sh'
                withKubeConfig(credentialsId: 'mykube') {
                    script {
                        sh "pipenv install"
                        sh "pipenv run pip install kubetest"
                        sh "pytest -s  -o junit_logging=all --junit-xml infrareport.xml || true"
                        junit 'infrareport.xml'
                    }
                }
            }
        stage('Perfomance Testing') {
            agent {
                label 'slave'
            }
            steps {
                unstash 'elk'
                bzt 'tests/perfomance-test/bzt-elastic.yaml -o modules.jmeter.properites.eshostname=34.105.25.200 -o modules.jmeter.properites.esport=9200 -report' 
            }
        }
    
        }
        stage('Deployments') {
            steps {
                withKubeConfig(credentialsId: 'mykube') {
                    unstash 'elk'
                    sh 'scripts/check_and_update.sh'
                }
            }
        }
    }
    post {
        always {
            sh 'scripts/cleanup.sh'
        }
    }
}
