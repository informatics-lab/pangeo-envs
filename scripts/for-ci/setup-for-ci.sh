#!/bin/bash
set -ex

# Vars
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPO_DIR=$SCRIPT_DIR/..

# Install tools
echo "*** Install Azure CLI ***"
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash 


# log in to azure
az login --service-principal --username ${SP_APP_ID} --password ${SP_PASSWORD} --tenant ${SP_TENANT_ID}


