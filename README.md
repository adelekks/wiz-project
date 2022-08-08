## WIZ Project Requirements 

What you need to start Homework
1.	Very good Laptop
2.	Window or Mac => Preferable Mac Laptop

## Tools:
```
For Windows
visual studio code
https://code.visualstudio.com/download
Atom
https://blog.atom.io/2014/12/10/a-windows-installer-and-updater.html

Git Bash
https://git-scm.com/download/win

For Mac
Homebrew
https://brew.sh/
Terraform
brew install terraform  
AWS cli
brew update                  # Fetch latest version of homebrew and formula.
brew search awscli           # Searches all known formula for a partial or exact match.
brew info awscli             # Displays information about the given formula.
brew install awscli          # Install the given formulae.
brew cleanup                 # Remove any older versions from the cellar.

Kubectl cli
brew install kubectl 
 or
brew install kubernetes-cli

Helm
brew install helm
visual studio code
brew update                           # Fetch latest version of homebrew and formula.
brew tap caskroom/cask                # Tap the Caskroom/Cask repository from Github using HTTPS.
brew search visual-studio-code        # Searches all known Casks for a partial or exact match.
brew cask info visual-studio-code     # Displays information about the given Cask
brew cask install visual-studio-code  # Install the given cask.
brew cleanup                          # For all installed or specific formulae, 
```
## create a SSH key pair
```
ssh-keygen -t rsa -f ~/.ssh/id_rsa -q -P ""
``` 
### AWS Infrastructure setup in aws via terraform
Terraform will create all below
### Network Setup
```
VPC 
Three private subnets
Three public subnets
Three AZ  
Net gateway
security group
```
### Deploy EC2 instance
```
MongoDB EC2 instance
Create a mongodb instance with an attache profile that give it access to s3 bucket 
Backup mongodb to s3 with public read
```
### Deploy EKS on AWS

## Run custom bash script to Setup 
```
Update kubeconfig 
Create service account
Deploy Jenkins POD
Label Jenkins POD
Create load balancer
Apply the permissive access This gives all SA admin privis
```
```
terraform init 
terraform plan
terraform apply
##sh scripts/setup.sh
```
## Update Kubeconfig
```
aws eks --region us-west-2 update-kubeconfig --name ${clustername}
```
## Create service account
```
kubectl create -f helm/serviceaccount.yaml
```
## Add helm repo
```
helm repo add jenkinsci https://charts.jenkins.io
helm repo update
```
## Container Jenkins Application deployment
## Deploy Jenkins app  via Helm 
```
helm install jenkins jenkinsci/jenkins
```
## Add label tp POD
```
kubectl label pods jenkins-0 app=jenkins
```
## Craete loadbalancer
```
kubectl create -f helm/loadbalancer.yaml
```
## Add container as Admin
```
RBAC permissions will not be suitable for production deployemnts because it allows ALL service accounts to act as cluster administrators. Any application running in a container receives service account credentials automatically, and could perform any action against the API, including viewing secrets and modifying permissions. This is not a recommended policy.

kubectl create clusterrolebinding permissive-binding --clusterrole=cluster-admin --user=admin --user=kubelet --group=system:serviceaccounts
```
## Get container LB for Jenkins
```
kubectl get svc
```
Test Jenkins POD
```
URL $LB:$PORT
```
## To Delete run
```
aws s3 rm s3://wiz-kenny-mongodb-backups/*.tar
aws elb delete-load-balancer --load-balancer-name my-load-balancer
terraform destroy
```
