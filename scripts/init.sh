#!/bin/bash
alias kubectl='kubectl --kubeconfig ~/.kube/kubeconfig'
for i in {0..2} ; do 
    number=$i envsubst < k8s-manifests/minikube-pv.yaml| kubectl apply -f -
 done
kubectl apply -f setup.yaml
kubectl apply -f k8s-manifests/elastic.secret.password.yaml

kubectl port-forward -n monitoring svc/elasticsearch-logging --address 0.0.0.0 9200:9200