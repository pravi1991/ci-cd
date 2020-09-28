# DEPLOYING ELK STACK WITH FILEBEATS USING JENKINS AND K8S

This demo is intended to demonstrate the deployment of ELK stack with Filebeats to Kubernetes cluster using jenkins pipeline.
The architecture diagram is as shown below 
![devops diagaram](devops-diagram.jpg)

Here the [github repo](https://github.com/pravi1991/ci-cd.git)

### Steps
I am using Jenkins Declrative Pipeli syntax. 
My jenkins setup has a master and a worker node setup in Google Cloud Platform using terraform ([resource template](infra/gcp.tf))

Here in first stage whenever there is a code commit to the given repo, then a git webhook is triggered to the jenkins server. 
This triggers the Jenkins pipeline from the [Jenkinsfile](Jenkinsfile) and first it pulls the repo using the git credentials provided inside jenkins environment. 
```groovy
        stage('CHECKOUT') {
            steps {
                checkout scm
                git credentialsId: 'GIT_CREDS', url: 'https://github.com/pravi1991/ci-cd.git'            
                stash 'elk'
            }
        }
```