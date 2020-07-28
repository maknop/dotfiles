# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Theme for oh-my-zsh
# Link: https://github.com/dikiaap/dotfiles/blob/master/.oh-my-zsh/themes/oxide.zsh-theme
ZSH_THEME="oxide"

# Plugins loaded
plugins=(git)

# oh-my-zsh
source $ZSH/oh-my-zsh.sh
source ~/.zsh_aliases
tmux source ~/.tmux.conf
source ~/functions
source /usr/local/opt/powerlevel10k/powerlevel10k.zsh-theme

