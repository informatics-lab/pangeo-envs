#!/usr/bin/env bash
set -ex
echo "Launch build job on kubernetes"

ENV=$1
if [ "$ENV" == "panzure-dev" ]; then
    PVC_NAME="pvc-panzure-dev-homespace"
else
    PVC_NAME="pvc-nfs"
fi

if [ "$TRAVIS_TAG" == "$TRAVIS_BRANCH" ]; then
# for tag builds the conda_env_name is the part of the tage before "--"
    CONDA_ENV=$(echo $TRAVIS_TAG | awk -F "--" '{print $1}')
else
    CONDA_ENV="$TRAVIS_BRANCH"
fi


az aks get-credentials -g "$ENV" -n "$ENV" --overwrite-existing
cat env-builder-template.yaml | \
    sed -e "s/[$][{]COMMIT[}]/${TRAVIS_COMMIT}/g" | \
    sed -e "s:[$][{]REPO_SLUG[}]:${TRAVIS_REPO_SLUG}:g" | \
    sed -e "s:[$][{]PVC_NAME[}]:${PVC_NAME}:g" | \
    sed -e "s/[$][{]ENV_NAME[}]/${CONDA_ENV}/g" > job.yaml 

kubectl delete -n $ENV -f job.yaml || echo "Nothing to delete"
kubectl apply -n $ENV -f job.yaml