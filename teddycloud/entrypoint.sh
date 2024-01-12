#!/usr/bin/env bash
set -o errexit
set -o pipefail
set -o nounset

# config
SHARE_DIR=/config
declare -a DIRS=(certs config data/content data/library data/firmware)

# ha config dirs
echo "creating config dirs"
for dir in "${DIRS[@]}"; do
    mkdir --parents --verbose "$$SHARE_DIR/$dir"
done

# ha config symlinks
echo "creating /teddycloud symlinks"

for dir in "${DIRS[@]}"; do
    rm --recursive --force --verbose "/teddycloud/$dir/"
    ln --symbolic --directory --verbose "$SHARE_DIR/$dir" "/teddycloud/$dir"
done

# run default entrypoint
/docker-entrypoint.sh
