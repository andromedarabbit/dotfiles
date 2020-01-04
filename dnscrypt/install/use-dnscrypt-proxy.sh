#!/bin/bash

set -x

function shutdown()
{
  echo `date` " " `whoami` " Received a signal to shutdown"

  # INSERT HERE THE COMMAND YOU WANT EXECUTE AT SHUTDOWN
  networksetup -setdnsservers "Wi-Fi" empty

  exit 0
}

function startup()
{
  echo `date` " " `whoami` " Starting..."

  # INSERT HERE THE COMMAND YOU WANT EXECUTE AT STARTUP
  networksetup -setdnsservers "Wi-Fi" empty

  while true; do
    sleep 20;

    [[ $(curl --silent https://api.ipify.org) ]] || continue

    GOOGLE="$(dig +short +time=1 +tries=1 @127.0.0.1 google.com)"
    [[ "${GOOGLE}" == "" ]] && continue
    [[ "${GOOGLE}" =~ ^\;\;.* ]] && continue

    break
  done;

  networksetup -setdnsservers "Wi-Fi" 127.0.0.1

  tail -f /dev/null &
  wait $!

  networksetup -setdnsservers "Wi-Fi" empty
}

# FIXME SIGTERM 은 실행이 보장되지 않는 듯
trap shutdown SIGTERM
trap shutdown SIGKILL

startup;
