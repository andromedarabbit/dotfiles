#!/usr/bin/env bash
THIS_DIR=$(cd "$(dirname "$0")"; pwd)

brew bundle --file="$THIS_DIR/Brewfile"

# See https://www.maketecheasier.com/change-dns-servers-terminal-mac/
# networksetup -setdnsservers "Wi-Fi" 208.67.222.222 208.67.220.220
# networksetup -setdnsservers "Thunderbolt Ethernet" 208.67.222.222 208.67.220.220

# networksetup -setdnsservers "Wi-Fi" 8.8.8.8 8.8.4.4 2001:4860:4860::8888 2001:4860:4860::8844

# DNS Crypt
cp -f "${THIS_DIR}/dnscrypt-proxy.toml" "/usr/local/etc/dnscrypt-proxy.toml"
sudo brew services restart dnscrypt-proxy && networksetup -setdnsservers "Wi-Fi" 127.0.0.1

which keybase && keybase pgp pull
