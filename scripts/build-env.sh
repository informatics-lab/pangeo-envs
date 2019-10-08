#!/usr/bin/env bash
set -ex

BASE_DIR="/envs/auto-build-envs"
TMP_ID=$(LC_ALL=C tr -dc 'A-Za-z0-9' </dev/urandom | head -c 9 ; echo)
TMP_DIR="${BASE_DIR}/${TMP_ID}"
DEST_DIR="${BASE_DIR}/${ENV_NAME}"
PRE_DELETE_DIR="${DEST_DIR}.tmp"

echo "*** Create env in tmp location: $TMP_DIR"
conda env create -f env.yaml -p $TMP_DIR

echo "*** Move existing env if exists: $DEST_DIR"
mv $DEST_DIR ${PRE_DELETE_DIR} || echo "$DEST_DIR doesn't exist"

echo "*** Rename env from temp location to dest location"
mv $TMP_DIR $DEST_DIR

echo "*** Remove old tmp env if exist"
rm -rf $PRE_DELETE_DIR || echo " $PRE_DELETE_DIR doesn't exist"

echo "** Done: ${ENV_NAME} at ${DEST_DIR}"