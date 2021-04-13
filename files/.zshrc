# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Link: https://github.com/dikiaap/dotfiles/blob/master/.oh-my-zsh/themes/oxide.zsh-theme
ZSH_THEME="amuse"

# Plugins loaded
plugins=(
    git
    docker
    pip
    python
    npm
    postgres
)

alias tmux="TERM=screen-256color-bce tmux"

# Set global .gitignore file.
git config --global core.excludesfile ~/.gitignore

# Source other configuration files
tmux source-file ~/.tmux.conf
source $ZSH/oh-my-zsh.sh
source ~/.zsh_aliases
source ~/functions

