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
                            image 'zegl/kube-score'
                        }
                    }
                    steps {
                        unstash 'elk'
                        //sh 'kube-score score manifests/elasticsearch.yaml --output-format ci'
                        script {
                        def status = sh 'uname -a', returnStatus:true
                        if (rc != 0) 
                        { 
                            sh "echo 'exit code is NOT zero'"
                        } 
                        else 
                        {
                            sh "echo 'exit code is zero'"
                        }}
                    }
                }
            }
        }
        