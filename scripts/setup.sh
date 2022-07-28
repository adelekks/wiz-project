#!/bin/bash 
echo "==========================
Please provide EKS cluster Name
=========================="
read clustername
aws eks --region us-west-2 update-kubeconfig --name ${clustername}
kubectl create -f helm/serviceaccount.yaml
helm repo add jenkinsci https://charts.jenkins.io
helm repo update
helm install jenkins jenkinsci/jenkins
#kubectl label pods `kubectl get pod | awk '{if (NR!=1) {print $1}}'` app=jenkins
kubectl label pods jenkins-0 app=jenkins
kubectl create -f helm/loadbalancer.yaml
kubectl create clusterrolebinding permissive-binding --clusterrole=cluster-admin --user=admin --user=kubelet --group=system:serviceaccounts
sleep 3m
kubectl get svc
