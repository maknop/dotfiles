export ZSH=$HOME/.oh-my-zsh
source $ZSH/oh-my-zsh.sh

export TERM="xterm-256color"

# Ignore insecure completion-dependent directory warning
ZSH_DISABLE_COMPFIX=true

ZSH_THEME="af-magic"

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

# Adding Neovim to path
#export PATH="$PATH:/opt/nvim-linux64/bin"

# Set global .gitignore file.
git config --global core.excludesfile ~/.global_gitignore

# Golang
export PATH=$PATH:$GOROOT/bin
export PATH=$PATH:/usr/local/go/bin

if [ -f ~/.zsh_profile ]; then
    source ~/.zsh_profile
fi

if [ -f ~/.zsh_aliases ]; then
    source ~/.zsh_aliases
fi

# Source custom functions
if [ -f ~/functions ]; then
    source ~/functions
fi

if [ "$TMUX" = "" ]; then tmux; fi
tmux source-file ~/.config/tmux/tmux.conf

