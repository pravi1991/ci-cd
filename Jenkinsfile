pipeline {
    agent any
    stages 
    {
        stage('CHECKOUT') 
        {
            steps 
            {
                checkout scm
                git credentialsId: 'GIT_CREDS', url: 'https://github.com/pravi1991/ci-cd.git'            
                stash 'elk'
            }
        }
        stage('Pre TESTS')
        {
            parallel 
            {
                stage('Static code analysis') 
                {
                    agent 
                    {
                        docker 
                        {
                            image 'kennethreitz/pipenv:latest'
                            args '-u root --privileged -v /var/run/docker.sock:/var/run/docker.sock'
                            label 'slave'
                        }
                    }
                    steps 
                    {
                        git credentialsId: 'GIT_CREDS', url: 'https://github.com/pravi1991/ci-cd.git'            
                        script 
                        {
                            sh "pipenv install"
                            sh "pipenv run pip install checkov"
                            sh "pipenv run checkov --framework kubernetes -d k8s-manifests -o junitxml -c `cat tests/terratest/check_list.txt` > result.xml || true"
                        }
                    }
                }
                stage('Infrastructure testing')
                {

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
        stage('Post Tests') 
        {
            stage('Perfomance Testing') 
            {
                    agent 
                    {
                        label 'slave'
                    }
                    steps 
                    {
                        unstash 'elk'
                        bzt 'tests/perfomance-test/bzt-elastic.yaml -o modules.jmeter.properites.eshostname=34.105.25.200 -o modules.jmeter.properites.esport=30001 -report' 
                    }
            }
        }
    }
}