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

                      kubernetesDeploy(
                                credentialsType: 'KubeConfig',
                                kubeConfig: [path: '/var/jenkins_home/.minikube/kubeconfig'],
                                configs: 'test.deploy.yml', 
                                      )                }
            }
        }
    }
