# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

#if [[ 'uname' == "Darwin" ]]; then
    # Theme for oh-my-zsh
    # Link: https://github.com/dikiaap/dotfiles/blob/master/.oh-my-zsh/themes/oxide.zsh-theme
    ZSH_THEME="oxide"
#elif [['uname' == "Linux" ]]; then
#    ZSH_THEME="eastwood"

# Plugins loaded
plugins=(git)

alias tmux="TERM=screen-256color-bce tmux"

# Source other configuration files
tmux source-file ~/.tmux.conf
source $ZSH/oh-my-zsh.sh
source ~/.zsh_aliases
source ~/functions

