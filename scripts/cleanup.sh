#!/bin/bash
#kubectl delete ns monitoring 
kubectl delete -f k8s-manifests
for i in {0..2} ; do number=$i envsubst < manifests/minikube-pv.yaml| kubectl delete -f -; done 