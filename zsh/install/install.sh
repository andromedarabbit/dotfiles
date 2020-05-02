#!/usr/bin/env bash

THIS_DIR=$(cd "$(dirname "$0")"; pwd)

THIS_SHELL='zsh'
THIS_SHELL_PATH="/usr/local/bin/$THIS_SHELL"

if test ! -f "$THIS_SHELL_PATH"
then
  # Install Zsh shell.
  brew bundle --file="$THIS_DIR/Brewfile"

  # Add the new shell to the list of allowed shells
  sudo bash -c "echo $THIS_SHELL_PATH >> /etc/shells"
fi

# Change to the new shell
if [ "$LOGIN_SHELL" == "$THIS_SHELL" ] && [ "$THIS_SHELL_PATH" != "`finger -l $USER | awk '/Shell/' | awk '{ print $4 }'`" ]
then
  chsh -s "$THIS_SHELL_PATH"
fi

# See https://github.com/ohmyzsh/ohmyzsh
if [[ ! -d "${HOME}/.oh-my-zsh" ]]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

compaudit | xargs chmod g-w,o-w
