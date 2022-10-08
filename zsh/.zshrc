if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH=$HOME/.oh-my-zsh
source $ZSH/oh-my-zsh.sh

source /opt/homebrew/opt/powerlevel10k/powerlevel10k.zsh-theme

export TERM="xterm-256color"

# Ignore insecure completion-dependent directory warning
ZSH_DISABLE_COMPFIX=true

ZSH_THEME="powerlevel10k/powerlevel10k"

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
source /opt/homebrew/opt/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
