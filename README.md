# DEPLOYING ELK STACK WITH FILEBEATS USING JENKINS AND K8S

This demo is intended to demonstrate the deployment of ELK stack with Filebeats to Kubernetes cluster using jenkins pipeline.
The architecture diagram is as shown below 
![devops diagaram](devops-diagram.jpg)

Here the [github repo](https://github.com/pravi1991/ci-cd.git)

### Steps
I am using Jenkins Declrative Pipeli syntax. 
My jenkins setup has a master and a worker node setup in Google Cloud Platform using terraform ([resource template](infra/gcp.tf))