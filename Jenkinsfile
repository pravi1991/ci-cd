pipeline {
    agent any
    stages {
        stage('CHECKOUT') {
            steps {
                    checkout scm
                    git credentialsId: 'GIT_CREDS', url: 'https://github.com/pravi1991/ci-cd.git'            
                    stash 'elk'
                }
            }
        stage('BUILD') {
            stage {
                step {
                    echo 'BUILD STAGE'
                }
            }
        }
        stage('TESTS'){
            parallel {
                stage('Static code analysis'){
                    agent { 
                        docker { 
                            image 'zegl/kube-score'
                        }
                    }
                    steps {
                        unstash 'elk'
                        sh 'kube-score score manifests/elasticsearch.yaml --output-format ci'
                        //sh 'ls manifest'    
                    }
                    post {
                        failure {
                            
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
                withKubeConfig(credentialsId: 'mykube') {
                        unstash 'elk'
                        echo env.WORKSPACE
                        sh 'ls -la'
                    }
                }
            }
        }
    }
