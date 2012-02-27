# users generic .zshrc file for zsh(1)

## Environment variable configuration
#
# LANG
#
export LANG=ja_JP.UTF-8

export PATH=/opt/local/bin:/opt/local/sbin:/Library/Android/android-sdk-mac_86/tools:/Library/ec2-tools/bin:$PATH
export MANPATH=/opt/local/man:$MANPATH

## Default shell configuration
#
# set prompt
#
autoload colors
colors
# auto change directory
#
setopt auto_cd

# auto directory pushd that you can get dirs list by cd -[tab]
#
setopt auto_pushd

# command correct edition before each completion attempt
#
setopt correct

# compacked complete list display
#
setopt list_packed

# no remove postfix slash of command line
#
setopt noautoremoveslash

# no beep sound when complete list displayed
#
setopt nolistbeep

## Keybind configuration
#
# emacs like keybind (e.x. Ctrl-a goes to head of a line and Ctrl-e goes
# to end of it)
#
bindkey -e

# historical backward/forward search with linehead string binded to ^P/^N
#
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end
bindkey "\\ep" history-beginning-search-backward-end
bindkey "\\en" history-beginning-search-forward-end

## Command history configuration
#
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt hist_ignore_dups # ignore duplication command history list
setopt share_history # share command history data

## Completion configuration
#
autoload -U compinit
compinit

## Alias configuration
#
# expand aliases before completing
#
setopt complete_aliases # aliased ls needs if file/dir completions work

alias where="command -v"
alias j="jobs -l"

case "${OSTYPE}" in
freebsd*|darwin*)
  alias ls="ls -G -w"
  ;;
linux*)
  alias ls="ls --color"
  ;;
esac

alias la="ls -a"
alias lf="ls -F"
alias ll="ls -l"

alias du="du -h"
alias df="df -h"

alias su="su -l"
alias vi="vim"

## terminal configuration
#
unset LSCOLORS
case "${TERM}" in
xterm)
  export TERM=xterm-color
  ;;
kterm)
  export TERM=kterm-color
  # set BackSpace control character
  stty erase
  ;;
cons25)
  unset LANG
  export LSCOLORS=ExFxCxdxBxegedabagacad
  export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
  zstyle ':completion:*' list-colors \
    'di=;34;1' 'ln=;35;1' 'so=;32;1' 'ex=31;1' 'bd=46;34' 'cd=43;34'
  ;;
esac

# set terminal title including current directory
#
case "${TERM}" in
kterm*|xterm*)
  precmd() {
    echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007"
  }
  export LSCOLORS=exfxcxdxbxegedabagacad
  export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
  zstyle ':completion:*' list-colors \
    'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'
  ;;
esac

## load user .zshrc configuration file
#
[ -f ~/.zshrc.mine ] && source ~/.zshrc.mine

setopt COMPLETE_IN_WORD


local GREEN=$'%{\e[1;32m%}'
local YELLOW=$'%{\e[1;33m%}'
local BLUE=$'%{\e[1;34m%}'
local DEFAULT=$'%{\e[1;m%}'

#PROMPT='[%n@%m]'$BLUE'%~'$reset_color'%# '    # default prompt
#PROMPT='[%n@%m]%~%# '    # default prompt
PROMPT='[%n@%m]%~ %1(v|%F{green}%1v%f|) # '
RPROMPT=""
zstyle ':completion:*:default' menu select=1

# ---- edit by my self
# about rvm
[[ -s "/Users/becyn/.rvm/scripts/rvm" ]] && source "/Users/becyn/.rvm/scripts/rvm"

export PATH=/usr/local/bin:$PATH
source $HOME/.zsh/cdd
alias c="clear"

autoload -Uz vcs_info
zstyle ':vcs_info:*' formats '[%b]'
zstyle ':vcs_info:*' actionformats '[%b|%a]'
precmd () {
    psvar=()
    LANG=en_US.UTF-8 vcs_info
    [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}


#### from asonas's bashrc
## if [ -f /usr/local/etc/bash_completion.d/git-completion.bash ]; then
##     . /usr/local/etc/bash_completion.d/git-completion.bash
## fi
## 
## __git_reminder() {
##   [ -d "$PWD/.git" ] || return
##   M=
##   git status | grep -q '^nothing to commit' 2>/dev/null || M=$M'*'
##   [ ! -z "$(git log --pretty=oneline  origin/master..HEAD 2>/dev/null)" ] && M=$M'^'
##   echo -n "$M"
## }
## 
## #__git_branch() {
## #    __git_ps1 '%s'
## #}
## 
## #__git_reminder() {
## #  [ -d "$PWD/.git" ] || return
## #  M=
## #  git status | grep -q '^nothing to commit' 2>/dev/null || M=$M'*'
## #  [ ! -z "$(git log --pretty=oneline  origin..HEAD 2>/dev/null)" ] && M=$M'^'
## #  echo -n "$M"
## #}
## 
## #_colesc="\[\e["
## #_cse="\]"
## #_colreset="${_colesc}0m${_cse}"
## 
## #export PS1="[\u@\h \w]\$(__git_branch)${_colesc};1m${_cse}${_colesc}31;1m${_cse}\$(__git_reminder)${_colreset}$ "
## export PS1="\u@\h \w[\$(__git_ps1 \"${_colesc}${_cse}%s${_colesc}${_cse}\$(__git_reminder)${_colreset}\")]\\$ "