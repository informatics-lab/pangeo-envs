#!/usr/bin/env bash
set -ex

az container create \
    --name appcontainer \
    --resource-group $RESOURCE_GROUP \
    --image mcr.microsoft.com/azuredocs/aci-helloworld \
    --vnet $V_NET \
    --subnet $SUB_NET \
    --gitrepo-url $GIT_REPO \
    --gitrepo-mount-path "/repo"