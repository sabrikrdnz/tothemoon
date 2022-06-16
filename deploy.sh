#!bin/bash

# Checking Helm is installed or not
echo "---- HELM CHECK ----"
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    HELM_CHECK="helm"
    PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $HELM_CHECK|grep "install ok installed")
    echo Checking for $TF_CHECK: $PKG_OK
    if [ "" = "$PKG_OK" ]; then
    
    echo "No $TF_CHECK. Setting up $HELM_CHECK."
    echo "//////////"

    curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
    sudo apt-get install apt-transport-https --yes
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
    sudo apt-get update
    sudo apt-get install helm
    fi

# Deploying MYSQL
cd /home/bastion/tothemoon/app/helm/mysql/
helm upgrade --debug --install --namespace dev mysql -f /home/bastion/tothemoon/app/helm/mysql/dev/values.yaml . --kubeconfig ~/.kube/config

# Deploying ApolloV01
cd /home/bastion/tothemoon/app/helm/apollov01/
helm upgrade --debug --install --namespace dev apollov01 -f /home/bastion/tothemoon/app/helm/apollov01/dev/values.yaml . --kubeconfig ~/.kube/config