#!/usr/bin/env bash
set -ex

BASE_DIR="/envs/auto-build-envs"
TMP_ID=$(LC_ALL=C tr -dc 'A-Za-z0-9' </dev/urandom | head -c 9 ; echo)
UID_DIR="${BASE_DIR}/${TMP_ID}"
DEST_DIR="${BASE_DIR}/${ENV_NAME}"
PRE_DELETE_DIR="${DEST_DIR}.tmp"

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
    rm -r $OLD_TARGET
    echo "*** $OLD_TARGET deleted"
fi


echo "** Done: ${ENV_NAME} at ${DEST_DIR}"