#!/usr/bin/env bash
#
# ref: [Upgrade to bash 4 in Mac OS X](http://clubmate.fi/upgrade-to-bash-4-in-mac-os-x/)

THIS_DIR=$(cd "$(dirname "$0")"; pwd)

THIS_SHELL='bash'
THIS_SHELL_PATH="/usr/local/bin/$THIS_SHELL"

if test ! -f "$THIS_SHELL_PATH"
then
  # Install Bash 5.
  brew bundle --file="$THIS_DIR/Brewfile"

  # Add the new shell to the list of allowed shells
  sudo bash -c "echo $THIS_SHELL_PATH >> /etc/shells"

  # Set this new shell as the default shell
  chsh -s /usr/local/bin/bash
fi

# Change to the new shell
if [ "$LOGIN_SHELL" == "$THIS_SHELL" ] && [ "$THIS_SHELL_PATH" != "`finger -l $USER | awk '/Shell/' | awk '{ print $4 }'`" ]
then
  chsh -s "$THIS_SHELL_PATH"
fi
