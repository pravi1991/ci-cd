pipeline {
    agent any
    stages {
        stage('checkout') {
            steps {
                    git credentialsId: 'GIT_CREDS', url: 'https://github.com/pravi1991/ci-cd.git'            
                }
            }
        stage('test: static code analysis'){
            //agent { docker 'ubuntu' }
            steps {
                echo 'STATIC CODE ANALYSIS'
                 withKubeConfig(caCertificate: '', clusterName: '', contextName: '', credentialsId: 'mykube', namespace: '', serverUrl: '') {
                        sh 'kubectl apply -f manifests/ --validate=true --dry-run=server'
                    }
            }
        }
        stage('Minikube Kubernetes Deploy') {
            steps {
                withKubeConfig(caCertificate: '', clusterName: '', contextName: '', credentialsId: 'mykube', namespace: '', serverUrl: '') {
                        sh 'kubectl apply -f manifests/'
                    }
                }
            }
        }
    }
