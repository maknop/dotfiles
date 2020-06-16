# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Command 'ls' shows all files including dotfiles
alias ls='ls -a'

# Moving a file gives an explanation
alias mv='mv -v'

# Creating a directory gives explanation
alias mkdir='mkdir -pv'

# Running python command is always version greater than 3
alias python='python3'

# Pip runs Pip3
alias pip='pip3'

# Theme for oh-my-zsh
# Link: https://github.com/dikiaap/dotfiles/blob/master/.oh-my-zsh/themes/oxide.zsh-theme
ZSH_THEME="oxide"

# Plugins loaded
plugins=(git)

# oh-my-zsh
source $ZSH/oh-my-zsh.sh
