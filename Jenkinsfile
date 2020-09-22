pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                    git credentialsId: 'GIT_CREDS', url: 'https://github.com/pravi1991/ci-cd.git'            
                }
            }
        stage('static code analysis'){
            //agent { docker 'ubuntu' }
            steps {
                echo 'unit testing'
                sh 'kubectl apply -f test.deploy.yaml --dry-run --validate=True'
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
