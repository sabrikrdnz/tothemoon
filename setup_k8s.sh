#!/bin/bash

echo "---- ANSIBLE CHECK ----"
# Checking Ansible is installed or not
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    ANS_CHECK="ansible"
    PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $ANS_CHECK|grep "install ok installed")
    echo Checking for $ANS_CHECK: $PKG_OK
    if [ "" = "$PKG_OK" ]; then
    
    echo "No $ANS_CHECK. Setting up $ANS_CHECK."
    echo "//////////"
    # installing ansible
    sudo apt install ansible
    fi
fi

echo "---- GIT CHECK ----"
# Checking git is installed or not
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    ANS_CHECK="git"
    PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $ANS_CHECK|grep "install ok installed")
    echo Checking for $ANS_CHECK: $PKG_OK
    if [ "" = "$PKG_OK" ]; then
    
    echo "No $ANS_CHECK. Setting up $ANS_CHECK."
    echo "//////////"

    # installing git
    sudo apt install git
    fi
fi

echo "---- KUBECTL CHECK ----"
# Checking kubectl is installed or not
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    ANS_CHECK="kubectl"
    PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $ANS_CHECK|grep "install ok installed")
    echo Checking for $ANS_CHECK: $PKG_OK
    if [ "" = "$PKG_OK" ]; then
    
    echo "No $ANS_CHECK. Setting up $ANS_CHECK."
    echo "//////////"

    # installing kubectl
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    #if you have root access on the target system, you can use the command which comment in below
    #sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    chmod +x kubectl
    mkdir -p ~/.local/bin
    mv ./kubectl /usr/local/bin/kubectl
    fi
fi

echo "Checking out the repository..."
git clone https://github.com/sabrikrdnz/tothemoon.git
cd tothemoon

mv ~/id_rsa ~/tothemoon/ansible/.

# Setting host key checking false
export ANSIBLE_HOST_KEY_CHECKING=False

# Creating id_rsa.pub for master&worker nodes
ssh-keygen -t rsa -N "" -f ./k8s.pub

scp -i tothemoon/ansible/id_rsa /home/bastion/.ssh/k8s.pub skyfall@10.0.1.8:/home/skyfall/.ssh/id_rsa.pub
scp -i tothemoon/ansible/id_rsa /home/bastion/.ssh/k8s.pub skyfall@10.0.1.9:/home/skyfall/.ssh/id_rsa.pub

echo "Creating users.."
ansible-playbook -i hosts users.yml

echo "Setting up K8s..."
ansible-playbook -i hosts install-k8s.yml

echo "Creating K8s Master Node.."
ansible-playbook -i hosts master.yml

kubectl get nodes

echo "Adding worker nodes to K8s cluster.."
ansible-playbook -i hosts join-workers.yml

kubectl get nodes

echo "Kubernetes cluster setup finished succesfully.."
