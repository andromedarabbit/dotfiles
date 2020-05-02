#!/usr/bin/env bash
THIS_DIR=$(cd "$(dirname "$0")"; pwd)

brew bundle --file="$THIS_DIR/Brewfile"

# Clean up
docker volume rm $(docker volume ls -qf dangling=true)

# See https://github.com/cloudnativelabs/kube-shell
# pip3 install --upgrade kube-shell