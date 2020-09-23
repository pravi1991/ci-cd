pipeline {
    agent any
    stages {
        stage('build') {
            steps {

                    git credentialsId: 'GIT_CREDS', url: 'https://github.com/pravi1991/ci-cd.git'            
                    stash 'elk'
                }
            }
        stage('test'){
            parallel {
                stage('static code analysis'){
                    steps {
                        echo 'STATIC CODE ANALYSIS'
                        withKubeConfig(credentialsId: 'mykube') {
                            sh 'kubectl apply -f manifests/ --validate=true --dry-run=server'
                        }
                    }
                }
            }
        }
        stage('Minikube Kubernetes Deploy') {
            agent { 
                docker {
                    image 'ubuntu'
                    }
                }
            steps {
                sh 'apt update && apt-get install -y git'
                withKubeConfig(credentialsId: 'mykube') {
                        sh 'docker images'
                        unstash 'elk'
                        sh 'git log'
                    }
                }
            }
        }
    }
