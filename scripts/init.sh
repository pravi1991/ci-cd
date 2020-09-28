#!/bin/bash
echo "CREATING PERSISTENT VOLUMES"
kubectl apply -f k8s-manifests/minikube-pv.yaml
echo "APPLYING setup.yaml"
kubectl apply -f k8s-manifests/setup.yaml
kubectl apply -f k8s-manifests/elastic.secret.password.yaml
