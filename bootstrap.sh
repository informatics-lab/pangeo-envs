#!/usr/bin/env bash

set -ex 

echo "<< Let's go >>"


# ENV_NAME="export"

## set init conda

# conda init bash
# source ~/.bashrc
# This above doesn't work because .bashrc exits early if not in interactive setting.
# eval "$(conda shell.bash hook)"

## create the env on shared storage
if [ -z "$ENV_BUILD_VERSION" ]
then
      echo "\$ENV_BUILD_VERSION is empty"
      exit 1
fi
ENV_DEST="/envs/$ENV_BUILD_VERSION"
rm -rf $ENV_DEST
conda env create -p "$ENV_DEST"  -f env.yml

# ## export it
# EXPORT_TAR=/home/jovyan/"$ENV_NAME".tar.gz
# conda install -c conda-forge conda-pack -y
# conda pack -n "$ENV_NAME" -o $EXPORT_TAR

# ## extract to shared storage

# rm -rf /envs/$ENV_BUILD_VERSION
# mkdir -p $ENV_DEST
# tar -xzf $EXPORT_TAR -C $ENV_DEST
