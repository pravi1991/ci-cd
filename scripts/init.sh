#!/bin/bash
echo "CREATING PERSISTENT VOLUMES"
kubectl apply -f k8s-manifests/minikube-pv.yaml
echo "APPLYING setup.yaml"
kubectl apply -f setup.yaml
kubectl apply -f k8s-manifests/elastic.secret.password.yaml
echo "PORT FORWARDING"
kubectl port-forward -n monitoring svc/elasticsearch-logging --address 0.0.0.0 9200:9200
kubectl port-forward -n monitoring svc/kibana --address 0.0.0.0 5601:80