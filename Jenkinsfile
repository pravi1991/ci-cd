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
        // stage('STATIC CODE ANALYSIS') {
        //     agent {
        //         docker {
        //             image 'kennethreitz/pipenv:latest'
        //             args '-u root --privileged -v /var/run/docker.sock:/var/run/docker.sock'
        //             label 'slave'
        //         }
        //     }
        //     steps {
        //         unstash 'elk'
        //         script {
        //             sh "pipenv install"
        //             sh "pipenv run pip install checkov"
        //             sh "pipenv run checkov --framework kubernetes -d k8s-manifests -o junitxml -c `cat tests/staticAnalysis/check_list.txt` > result.xml || true"
        //         }
        //     }
        // }
    
        stage('Infrastructure testing') {    
            steps {
                unstash 'elk'
                withCredentials([kubeconfigFile(credentialsId: 'KUBECONFIG', variable: 'KUBECONFIG')]) {
                    sh 'scripts/init.sh'
                   
               }
                script {
                    try {
                        sh "pipenv install"
                        sh "pipenv run pip install kubetest"
                        sh "pytest -s -o junit_logging=all --junit-xml infrareport-elastic.xml  tests/infraTesting/ || true"
                        junit 'infrareport*.xml'
                    }
                    catch (exc) {
                        echo $currentBuild.result
                    }
                }
            }
        }    
        stage('Perfomance Testing') {
            agent {
                label 'slave'
            }
            steps { 
                withCredentials([kubeconfigFile(credentialsId: 'KUBECONFIG', variable: 'KUBECONFIG')]) {
                    sh 'kubectl port-forward -n monitoring svc/elasticsearch-logging --address 0.0.0.0 9200:9200'
                    sh 'kubectl port-forward -n monitoring svc/kibana --address 0.0.0.0 5601:80'
                }
                catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
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
            sh 'ls'
        }
    }
}
