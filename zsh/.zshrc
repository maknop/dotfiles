source $ZSH/oh-my-zsh.sh

export TERM="xterm-256color"

# Ignore insecure completion-dependent directory warning
ZSH_DISABLE_COMPFIX=true

ZSH_THEME="geoffgarside"

# Plugins loaded
plugins=(
    git
    docker
    pip
    python
    golang
    npm
    postgres
)

alias tmux="TERM=screen-256color-bce tmux"

# Set global .gitignore file.
git config --global core.excludesfile ~/.global_gitignore

# Golang
export PATH=$PATH:$GOROOT/bin

# Source tmux file
tmux source-file ~/.tmux.conf

if [ -f ~/.zsh_profile ]; then
    source ~/.zsh_profile
fi

if [ -f ~/.zsh_aliases ]; then
    source ~/.zsh_aliases
fi

# Source custom functions
source ~/functions