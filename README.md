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
Next stage is to do the static analysis of the code. For this I am using a tool called [`checkov`](). It can be installed uisng pip
```python
pip3 install checkov
```groovy
stage('STATIC CODE ANALYSIS') {
            agent {
                docker {
                    image 'kennethreitz/pipenv:latest'
                    args '-u root --privileged -v /var/run/docker.sock:/var/run/docker.sock'
                    label 'slave'
                }
            }
            steps {
                unstash 'elk'
                script {
                    sh "pipenv install" 
                    sh "pipenv run pip install checkov"
                    sh "pipenv run checkov --framework kubernetes -d k8s-manifests -o junitxml -c `cat tests/staticAnalysis/check_list.txt` > result.xml || true"
                }
            }
        }
```
In here I am making use of a worker node labeled as `slave` and I am running a docker container here to run a clean test. So once the test is complete then there won't be any leftovers. The results of the stage is captured in `junit xml` format.

In the next stage `Infrastructure Testing` stage where I have again used [kubetest]() tool. This is a python based tool with which we can spinup the manifest to the given kubernetes cluster and then perform the tests written in python file. The directory [infraTesting](tests/infraTesting) contains the file to test the