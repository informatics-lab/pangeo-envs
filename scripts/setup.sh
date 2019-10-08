#!/bin/bash
set -ex

# Vars
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPO_DIR=$SCRIPT_DIR/..

# Install tools

echo "*** Install kubectl ***"
sudo apt-get update && sudo apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo touch /etc/apt/sources.list.d/kubernetes.list
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl


echo "*** Install Azure CLI ***"
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash 


# log in to azure
az login --service-principal --username ${SP_APP_ID} --password ${SP_PASSWORD} --tenant ${SP_TENANT_ID}