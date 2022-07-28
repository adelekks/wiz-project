## WIZ Project Requirements 

What you need to start Homework
1.	Very good Laptop
2.	Window or Mac => Preferable Mac Laptop

## Tools:
For Windows
visual studio code
https://code.visualstudio.com/download
Atom
https://blog.atom.io/2014/12/10/a-windows-installer-and-updater.html

Git Bash
https://git-scm.com/download/win
Winscp
https://winscp.net/eng/index.php


For Mac
Homebrew
https://brew.sh/
Terraform
brew install terraform  
AWS cli
brew update                  # Fetch latest version of homebrew and formula.
brew search awscli       # Searches all known formula for a partial or exact match.
brew info awscli           # Displays information about the given formula.
brew install awscli        # Install the given formulae.
brew cleanup                # Remove any older versions from the cellar.

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

## Create AWS access file in your home dir for Monogodb to backup to  s3
```
vi ~/.ssh/aws-access-key
export AWS_ACCESS_KEY_ID=xxxx-xxxxx-xxxx
export AWS_SECRET_ACCESS_KEY=xxxx-xxxxx-xxxx
```
Save it
## create a SSH key pair
```
ssh-keygen -t rsa -f ~/.ssh/id_rsa -q -P ""
``` 
### AWS Infrastructure setup in aws via terraform
Terraform will create all below
### Network Setup
VPC 
Three private subnets
Three public subnets
Three AZ  
Net gateway
security group

### Deploy EC2 instance
MongoDB EC2 instance
Create a mongodb instance with an attache profile that give it access to all ec2 role 
Backup mongodb to s3

### Deploy EKS on AWS

## Run custom bash script to Setup 
Update kubeconfig 
Create service account
Deploy Jenkins POD
Label Jenkins POD
Create load balancer
Apply the permissive access This gives all SA admin privis

```
sh scripts/setup.sh
```
Test Jenkins POD
```
URL $LB:$PORT
```
