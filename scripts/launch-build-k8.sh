#!/usr/bin/env bash
set -ex
echo "Launch build job on kubernetes"

az aks get-credentials -g "$ENV" -n "$ENV" --overwrite-existing
cat env-builder-template.yaml | \
    sed -e "s/[$][{]COMMIT[}]/${TRAVIS_COMMIT}/g" | \
    sed -e "s:[$][{]REPO_SLUG[}]:${TRAVIS_REPO_SLUG}:g" | \
    sed -e "s/[$][{]ENV_NAME[}]/${TRAVIS_BRANCH}/g" > job.yaml 

kubectl delete -n $ENV -f job.yaml || echo "Nothing to delete"
kubectl apply -n $ENV -f job.yaml