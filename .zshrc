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
ZSH_THEME="af-magic"
ZSH_DISABLE_COMPFIX=true


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

# Load Profile Settings
[[ -f ~/.zprofile ]] && source ~/.zprofile

# Load Aliases
[[ -f ~/.zsh_aliases ]] && source ~/.zsh_aliases

# Source custom functions
[[ -f ~/functions ]] && source ~/functions

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
