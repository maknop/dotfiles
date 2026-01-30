# Homebrew setup (must be first to ensure proper PATH)
# Support both Apple Silicon and Intel Macs
if [[ -f "/opt/homebrew/bin/brew" ]]; then
    # Apple Silicon
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f "/usr/local/bin/brew" ]]; then
    # Intel Mac
    eval "$(/usr/local/bin/brew shellenv)"
fi

# Oh My Zsh configuration (must be set before sourcing)
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="af-magic"
ZSH_DISABLE_COMPFIX=true

export TERM="xterm-256color"

# Source Oh My Zsh
source $ZSH/oh-my-zsh.sh

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

