#!/usr/bin/env bash
THIS_DIR=$(cd "$(dirname "$0")"; pwd)

brew bundle --file="$THIS_DIR/Brewfile"

# httpie
# pip install httpie-oauth --user --upgrade

brew install m-cli
RC=$?
if [[ ${RC} == 0 ]];
then
  m update install all;
fi

# See https://github.com/Orkohunter/keep
# pip install keep --user --upgrade

# (npm list -g snyk && npm update --silent -g snyk) || (npm install --silent -g snyk)

(npm list -g bash-language-server && npm update --silent -g bash-language-server) || (npm install --silent -g bash-language-server)

# gem install --user-install tmuxinator

# Google Cloud Platform
# type gcloud 2>&1 > /dev/null && gcloud components update --quiet

# AWS Cli
# complete -C '/usr/local/aws/bin/aws_completer' aws