pipeline {
    agent any
    stages {
        stage('build') {
            steps {
                    git credentialsId: 'GIT_CREDS', url: 'https://github.com/pravi1991/ci-cd.git'            
                }
            }
        stage('test: static code analysis'){
            //agent { docker 'ubuntu' }
            steps {
                echo 'STATIC CODE ANALYSIS'
                withKubeConfig(credentialsId: 'mykube') {
                    sh 'kubectl apply -f manifests/ --validate=true --dry-run=server'
                }
            }
        }
        stage('Minikube Kubernetes Deploy') {
            steps {
                withKubeConfig(credentialsId: 'mykube') {
                        sh 'docker images'
                    }
                }
            }
        }
    }
