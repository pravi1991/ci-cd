pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                    git credentialsId: 'GITHUB_CREDS', url: 'https://github.com/pravi1991/ci-cd.git'            
                }
            }
        stage('Minikube Kubernetes Deploy') {
            steps {
                kubernetesDeploy configs: 'test.deploy.yaml', kubeconfigId: 'KUBECONFIG', enableConfigSubstitution: true
                }
            }
        }
    }
