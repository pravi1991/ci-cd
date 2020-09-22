pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                    git credentialsId: 'GIT_CREDS', url: 'https://github.com/pravi1991/ci-cd.git'            
                }
            }
        stage('static code analysis'){
            agent { docker 'ubuntu' }
            steps {
                echo 'unit testing'
                sh 'kubectl get nodes'
            }
        }
        stage('Minikube Kubernetes Deploy') {
            steps {
                withKubeConfig(caCertificate: '', clusterName: '', contextName: '', credentialsId: 'mykube', namespace: '', serverUrl: '') {
                        sh 'kubectl get nodes'
                    }
                }
            }
        }
    }
