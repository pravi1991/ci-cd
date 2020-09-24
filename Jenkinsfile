pipeline {
    agent any
    stages {
        stage('build') {
            steps {
                    checkout scm
                    git credentialsId: 'GIT_CREDS', url: 'https://github.com/pravi1991/ci-cd.git'            
                    stash 'elk'
                }
            }
        stage('test'){
            parallel {
                stage('static code analysis'){
                    agent { 
                        docker { 
                            image 'ubuntu'
                        }
                    }
                    steps {
                        unstash 'elk'
                        //sh 'kube-score score manifests/elasticsearch.yaml --output-format ci'
    
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
                withKubeConfig(credentialsId: 'mykube') {
                        unstash 'elk'
                        sh 'pwd'
                        sh 'ls -la'
                    }
                }
            }
        }
    }
