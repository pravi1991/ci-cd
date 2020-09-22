pipeline {
    agent any
    stages {
        stage('Commit') {
            steps {
                    git credentialsId: 'GIT_CREDS', url: 'https://github.com/pravi1991/ci-cd.git'            
                }
            }
        stage('Minikube Kubernetes Deploy') {
            steps {
                kubernetesDeploy configs: 'test.deploy.yaml', kubeconfigId: 'KUBECONFIG', enableConfigSubstitution: true
                }
            }
        }
    }
