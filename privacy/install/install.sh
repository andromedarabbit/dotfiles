#!/usr/bin/env bash
THIS_DIR=$(cd "$(dirname "$0")"; pwd)

[[ "${DOT_DEBUG}" == true ]] && set -x

[[ "${DOT_UPGRADE_ALL}" == true ]] \
  && brew bundle --file="${THIS_DIR}/Brewfile" \
  || brew bundle --no-upgrade --file="${THIS_DIR}/Brewfile"

# See https://www.maketecheasier.com/change-dns-servers-terminal-mac/
# networksetup -setdnsservers "Thunderbolt Ethernet" 208.67.222.222 208.67.220.220
networksetup -setdnsservers "Wi-Fi" 8.8.8.8 8.8.4.4 2001:4860:4860::8888 2001:4860:4860::8844

which keybase && keybase pgp pull
