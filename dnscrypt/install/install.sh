#!/usr/bin/env bash

THIS_DIR=$(cd "$(dirname "$0")"; pwd)

[[ "${DOT_DEBUG}" == true ]] && set -x

# Stop dnscrypt-proxy before installing or updating it
sudo brew services stop dnscrypt-proxy || \
  echo "Failed but this is expected. No worries."

if [[ -f "${HOME}/Library/LaunchAgents/dnscrypt-proxy.plist" ]]; then
  launchctl unload -w "${HOME}/Library/LaunchAgents/dnscrypt-proxy.plist" || \
    echo "Failed but this is expected. No worries."
fi

[[ "${DOT_UPGRADE_ALL}" == true ]] \
  && brew bundle --file="${THIS_DIR}/Brewfile" \
  || brew bundle --no-upgrade --file="${THIS_DIR}/Brewfile"

# See https://www.maketecheasier.com/change-dns-servers-terminal-mac/
# See also recommended/privacy/install/install.sh
cat "${THIS_DIR}/dnscrypt-proxy.plist" | sed "s|VAR_HOME|${HOME}|g" > "${HOME}/Library/LaunchAgents/dnscrypt-proxy.plist"
cp -f "${THIS_DIR}/dnscrypt-proxy.toml" "/usr/local/etc/"
chmod 750 "${THIS_DIR}/use-dnscrypt-proxy.sh" && \
  sudo cp -f "${THIS_DIR}/use-dnscrypt-proxy.sh" "/usr/local/opt/dnscrypt-proxy/sbin/"

sudo brew services start dnscrypt-proxy

launchctl load -w "${HOME}/Library/LaunchAgents/dnscrypt-proxy.plist"
