# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Link: https://github.com/dikiaap/dotfiles/blob/master/.oh-my-zsh/themes/oxide.zsh-theme
ZSH_THEME="oxide"

# Plugins loaded
plugins=(
    git
    docker
    pip
    python
    npm
    
)

alias tmux="TERM=screen-256color-bce tmux"

# Source other configuration files
tmux source-file ~/.tmux.conf
source $ZSH/oh-my-zsh.sh
source ~/.zsh_aliases
source ~/functions

