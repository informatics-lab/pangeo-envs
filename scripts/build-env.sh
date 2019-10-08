#!/usr/bin/env bash
set -ex

BASE_DIR="/envs/auto-build-envs"
TMP_ID=$(LC_ALL=C tr -dc 'A-Za-z0-9' </dev/urandom | head -c 9 ; echo)
TMP_DIR="${BASE_DIR}/${TMP_ID}"
DEST_DIR="${BASE_DIR}/${ENV_NAME}"
PRE_DELETE_DIR="${DEST_DIR}.tmp"

conda env create -f env.yaml -p $TMP_DIR
mv $DEST_DIR ${PRE_DELETE_DIR} || echo "$DEST_DIR doesn't exist"
mv $TMP_DIR $DEST_DIR
rm -rf $PRE_DELETE_DIR