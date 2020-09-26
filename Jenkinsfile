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
            steps {
                echo 'BUILD STAGE'
            }
        
        }
        stage('Pre TESTS'){
            parallel {
                stage('Static code analysis'){
                    agent { 
                        docker { 
                            image 'zegl/kube-score'
                        }
                    }
                    steps {
                        unstash 'elk'
                        //sh 'kube-score score manifests/elasticsearch.yaml --output-format ci'
                        sh 'kube-score score --help'
                        //sh 'ls manifest'    
                    }
                    post {
                        success {
                            echo 'ran static code analysis successfully'
                        }
                        failure {
                            echo 'static code failed'
                        }
                    }
                }
            }
        }
        stage('Kubernetes Deployments') {
            steps {
                withKubeConfig(credentialsId: 'mykube') {
                        unstash 'elk'
                        echo env.WORKSPACE
                        sh 'ls -la'
                    }
                }
            }
        }
        stage('Post Tests') {
            stage('Perfomance Testing') {
                    agent {
                        label 'slave'
                    }
                    steps {
                        unstash 'elk'
                        bzt 'tests/perfomance-test/bzt-elastic.yaml -o modules.jmeter.properites.eshostname=34.105.25.200 -o modules.jmeter.properites.esport=30001 -report' 
                    }
                }
        }
    }
