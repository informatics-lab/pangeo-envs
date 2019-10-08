#!/usr/bin/env bash
set -ex

# Pre req: In gui create a sub net for the containers if not already there.



RESOURCE_GROUP="panzure-dev"
REPO="https://github.com/informatics-lab/pangeo-envs.git"
V_NET="panzure-dev"
SUB_NET="container_instances"
SP_NAME="panzure-dev-env-builder"
RG_ID=$(az group show --name $RESOURCE_GROUP --query id --output tsv)
ENV="panzure-dev"


SP_PASSWORD=$(az ad sp create-for-rbac -n "http://${SP_NAME}" --query "password" -o tsv)
az role assignment create --role "Azure Kubernetes Service Cluster Admin Role" --assignee "http://${SP_NAME}"

SP_APP_ID=$(az ad sp show --id "http://${SP_NAME}" --query "appId"  -o tsv)
SP_TENANT_ID=$(az ad sp show --id "http://${SP_NAME}" --query "appOwnerTenantId"  -o tsv)



# RAW_REPO_URL="https://raw.githubusercontent.com/informatics-lab/pangeo-envs"


# az role assignment create --role "Azure Kubernetes Service Cluster Admin Role" --assignee http://pangeo-travis-deploy
echo "
export SP_PASSWORD=\"$SP_PASSWORD\"
export SP_APP_ID=\"$SP_APP_ID\"
export SP_TENANT_ID=\"$SP_TENANT_ID\"
export RESOURCE_GROUP=\"$RESOURCE_GROUP\"
export ENV=\"$ENV\"


"