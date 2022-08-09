#!/bin/bash 
terraform init
terraform plan
terraform apply -auto-approve
echo "==========================
Please provide EKS cluster Name
=========================="
read clustername
echo "waiting for 5 minutes for eks cluster to fully start up"
sleep 300
aws eks --region us-west-2 update-kubeconfig --name ${clustername}
kubectl create -f helm/serviceaccount.yaml
sleep 10
helm repo add jenkinsci https://charts.jenkins.io
helm repo update
sleep 30
helm install jenkins jenkinsci/jenkins
#kubectl label pods `kubectl get pod | awk '{if (NR!=1) {print $1}}'` app=jenkins
kubectl label pods jenkins-0 app=jenkins
kubectl create -f helm/loadbalancer.yaml
kubectl create clusterrolebinding permissive-binding --clusterrole=cluster-admin --user=admin --user=kubelet --group=system:serviceaccounts
echo "waiting for 5 minutes for LB to fully start up"
sleep 300
kubectl get svc
