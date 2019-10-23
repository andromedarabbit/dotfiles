#!/usr/bin/env bash

# Add `~/bin` to the `$PATH`
export PATH="$HOME/bin:/usr/local/sbin:/usr/local/bin:$HOME/.gem/ruby/2.3.0/bin:$PATH"

for file in $HOME/bin/*; do
	[ -r "$file" ] && [ -d "$file" ] && export PATH="$file:$PATH";
done;
unset file;

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
for file in ~/.{path,bash_prompt,exports,aliases,functions}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Every ~/.extra* files are being sourced.
for extra in $(find $HOME -mindepth 1 -maxdepth 1 \( -type f -o -type l \) -name ".extra*"); do
	source "$extra";
done;
unset extra;

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# Append to the Bash history file, rather than overwriting it
shopt -s histappend;

# Autocorrect typos in path names when using `cd`
shopt -s cdspell;

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
    shopt -s "$option" 2> /dev/null;
done;

# Add tab completion for many Bash commands
which brew > /dev/null && [[ -r "$(brew --prefix)/etc/profile.d/bash_completion.sh" ]] && . "$(brew --prefix)/etc/profile.d/bash_completion.sh"

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
complete -W "NSGlobalDomain" defaults;

# Add `killall` tab completion for common apps
complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter" killall;

# See https://hashnode.com/post/what-are-your-top-cli-tools-hacks-for-productivity-cinov8y4w00njxh53j2w9wfy4
if which brew > /dev/null && [ -f "$(brew --prefix)/etc/profile.d/z.sh" ]; then
  source "$(brew --prefix)/etc/profile.d/z.sh"
fi;

[[ -s $(brew --prefix)/etc/profile.d/autojump.sh ]] && . "$(brew --prefix)/etc/profile.d/autojump.sh"

# Just for fun
# http://haruair.com/blog/3521
# if [ -e $(which fortune) ] && [ -e $(which cowsay) ]; then
#    fortune | cowsay
# fi

# https://direnv.net/
type -P direnv > /dev/null && eval "$(direnv hook bash)"

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

[ -f "${HOME}/.bashrc" ] && source "${HOME}/.bashrc"
