#!/bin/bash
alias kubectl='kubectl --kubeconfig ~/.kube/kubeconfig'
for i in {0..2} ; do 
    number=$i envsubst < minikube-pv.yaml| kubectl apply -f -
 done
kubectl apply -f setup.yaml
kubectl apply -f k8s-manifests/elastic.secret.password.yaml
# kubectl apply -f
# kubectl apply -f
# kubectl apply -f
# kubectl apply -f
# kubectl apply -f
# kubectl apply -f
# kubectl apply -f
