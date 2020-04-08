#!/usr/bin/env bash
set -ex

ENV_DIR="/envs/infrastructure"
WORK_DIR="/envs/work"
mkdir -p $WORK_DIR
mkdir -p $ENV_DIR
TMP_ID=$(LC_ALL=C tr -dc 'A-Za-z0-9' </dev/urandom | head -c 9 ; echo)
UID_DIR="${WORK_DIR}/${TMP_ID}"
DEST_DIR="${ENV_DIR}/${ENV_NAME}"

# create env in unique location.
echo "*** Create env in unique location: $UID_DIR"
conda env create -f env.yaml -p $UID_DIR

# Add packages pertinent to an R environment.
ORIG_CONDA_ENV=$CONDA_DEFAULT_ENV
conda activate $UID_DIR
conda install -c conda-forge \
    r \
    r-tidyverse \
    r-irkernel
conda activate $ORIG_CONDA_ENV

# if there is post_conda.sh script run it under the newly created env.
if [ -f post_conda.sh ]; then
    eval "$('conda' 'shell.bash' 'hook' 2> /dev/null)"
    conda activate $UID_DIR
    ./post_conda.sh
    conda activate $ORIG_CONDA_ENV
fi

# Register the R kernel globally.
conda activate $UID_DIR
export RVERSION=$(R --version | grep -o "[0-9]\.[0-9]\.[0-9]")
export $ENV_NAME
Rscript -e 'IRkernel::installspec(name = Sys.getenv("ENV_NAME"), displayname = sprintf("R %s", Sys.getenv("RVERSION")), user = FALSE)'
conda activate $ORIG_CONDA_ENV

# Move the built kernel to a persistent location.
mkdir -p /envs/pre-built-envs/kernels/
mv /usr/local/share/jupyter/kernels/${ENV_NAME} /envs/pre-built-envs/kernels/

# Clear existing version if needed
if [[ -d "$DEST_DIR" ]]; then
    echo "*** $DEST_DIR exists. Remove link"
    OLD_TARGET=$(readlink $DEST_DIR) 
    rm $DEST_DIR
    echo "*** $DEST_DIR link removed. Target was $OLD_TARGET"
fi

# link unique name to env name
echo "*** Link env from temp location to dest location"
ln -s $UID_DIR $DEST_DIR

# delete old env if exists
if [ -n "$OLD_TARGET" ]; then
    echo "*** remove old version of $ENV_NAME at $OLD_TARGET"
    if rm -rf $OLD_TARGET ; then
        echo "*** $OLD_TARGET deleted"
    else
        # Sometimes the delete fails. I think this is just the NFS disk not being able to 'keep up'
        # let's give it 3s and try again, but not worry about success or failure.
        echo "*** ERROR deleting $OLD_TARGET. Try again after 3s"
        sleep 3
        rm -rf $OLD_TARGET || : 
    fi
    
fi


echo "*** Done: ${ENV_NAME} at ${DEST_DIR}"