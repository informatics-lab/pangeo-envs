#!/usr/bin/env bash

set -ex 

echo "<< Let's go >>"


# ENV_NAME="export"

## set init conda

# conda init bash
# source ~/.bashrc
# This above doesn't work because .bashrc exits early if not in interactive setting.
eval "$(conda shell.bash hook)"
conda config --set allow_softlinks False

## create the env on shared storage
if [ -z "$ENV_BUILD_VERSION" ]
then
      echo "\$ENV_BUILD_VERSION is empty"
      exit 1
fi
TMP_DEST="/home/jovyan/tmp-env"
ENV_DEST="/envs/$ENV_BUILD_VERSION"



conda env create -p "$TMP_DEST"  -f env.yml

ls -l /home/jovyan/tmp-env

rm -rf $ENV_DEST

cp -r $TMP_DEST $ENV_DEST

# ## export it
# EXPORT_TAR=/home/jovyan/"$ENV_NAME".tar.gz
# conda install -c conda-forge conda-pack -y
# conda pack -n "$ENV_NAME" -o $EXPORT_TAR

# ## extract to shared storage

# rm -rf /envs/$ENV_BUILD_VERSION
# mkdir -p $ENV_DEST
# tar -xzf $EXPORT_TAR -C $ENV_DEST
