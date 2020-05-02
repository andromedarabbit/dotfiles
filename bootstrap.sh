#!/usr/bin/env bash -x
#
# Ask for the administrator password upfront.
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 2400; kill -0 "$$" || exit; done 2>/dev/null &

# Load the configurations
THIS_DIR=$(cd "$(dirname "$0")"; pwd)

source "${THIS_DIR}/.config"

# Homebrew
#
# This installs some of the common dependencies needed (or at least desired)
# using Homebrew.

# Check for Homebrew
## Ref: https://github.com/holman/dotfiles/blob/master/homebrew/install.sh
if test ! $(which brew)
then
  echo "  Installing Homebrew for you."

  # Install the correct homebrew for each OS type
  if test "$(uname)" = "Darwin"
  then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  elif test "$(expr substr $(uname -s) 1 5)" = "Linux"
  then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/linuxbrew/go/install)"
  fi

fi

# Upgrade all the existing packages
brew update && brew upgrade

# Install the packages described in `Brewfile`
export PATH="/usr/local/bin:/usr/local/sbin:~/bin:$PATH"

brew tap Homebrew/bundle

brew bundle

# Find the installers and run them iteratively
## Ref: https://github.com/holman/dotfiles/blob/master/script/install
find . -path '**/install/install.sh' -mindepth 3 -maxdepth 3 | while read installer ; do
  DIRNAME=$(dirname "${installer}")
  if [[ -f "${DIRNAME}/../.disabled" ]]; then
    continue
  fi
  sh -c "chmod +x ${installer} && ${installer}"
done


# Remove outdated versions from the cellar.
brew cleanup

# Run GNU Stow
# Treat the personal configurations first
if [ -f "${THIS_DIR}/not-shared" ]; then
  stow --restow --target="$HOME" --ignore="install*" --ignore ".DS_Store" "not-shared"
fi

dirlist=$(find . -mindepth 1 -maxdepth 1 -type d -not  \( -path "./.*" \) | awk -F/ '{print $NF}')

for dir in $dirlist
do
  if [[ -f "${dir}/.disabled" ]]; then
    continue
  fi

  #if [[ -e "${HOME}/${dir}" ]] && [[ ! -L "${HOME}/${dir}" ]]; then
  #    /bin/rm -rf "${HOME}/${dir}"
  #fi
  stow --restow --target="${HOME}" --ignore="install*" --ignore='\.DS_Store' "${dir}"
done
unset dirlist;
unset dir;
