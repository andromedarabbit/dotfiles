#!/usr/bin/env bash
THIS_DIR=$(cd "$(dirname "$0")"; pwd)

brew bundle --file="$THIS_DIR/Brewfile"

mkdir -p "${HOME}/bin"

# Update TLDR database
which tldr && tldr --update

# Z
# . /usr/local/etc/profile.d/z.sh

# ansi
TMP_DIR=$(mktemp -d)
curl --silent -L git.io/ansi -o "${TMP_DIR}/ansi"
chmod +x "${TMP_DIR}/ansi"
sudo mv "${TMP_DIR}/ansi" /usr/local/bin/