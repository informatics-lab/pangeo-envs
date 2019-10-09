#!/usr/bin/env bash
set -ex

ENV_DIR="/envs/auto-build-envs"
WORK_DIR="/envs/work"
mkdir -p $WORK_DIR
mkdir -p $ENV_DIR
TMP_ID=$(LC_ALL=C tr -dc 'A-Za-z0-9' </dev/urandom | head -c 9 ; echo)
UID_DIR="${WORK_DIR}/${TMP_ID}"
DEST_DIR="${ENV_DIR}/${ENV_NAME}"

# create env in unique location 
echo "*** Create env in unique location: $UID_DIR"
conda env create -f env.yaml -p $UID_DIR

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


echo "** Done: ${ENV_NAME} at ${DEST_DIR}"