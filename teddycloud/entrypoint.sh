#!/usr/bin/env bash
set -o errexit
set -o pipefail
set -o nounset

# config
SHARE_DIR=/config

# ha config dirs
echo "creating config dirs"
mkdir -p "$SHARE_DIR/certs"
mkdir -p "$SHARE_DIR/config"
mkdir -p "$SHARE_DIR/data"
mkdir -p "$SHARE_DIR/data/content"
mkdir -p "$SHARE_DIR/data/library"
mkdir -p "$SHARE_DIR/data/firmware"

# ha config symlinks
echo "creating /teddycloud symlinks"

#ln -sF /teddycloud/config /config/config
rm -rf /teddycloud/certs/
ln -sF "$SHARE_DIR/certs" /teddycloud/certs

rm -rf /teddycloud/config/
ln -sF "$SHARE_DIR/config" /teddycloud/config

rm -rf /teddycloud/data
ln -sF "$SHARE_DIR/data" /teddycloud/data

# run default entrypoint
/docker-entrypoint.sh