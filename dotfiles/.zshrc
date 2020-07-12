# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Theme for oh-my-zsh
# Link: https://github.com/dikiaap/dotfiles/blob/master/.oh-my-zsh/themes/oxide.zsh-theme
ZSH_THEME="oxide"

# Plugins loaded
plugins=(git)

# fzf settings
export FXF_DEFAULT_OPTS='--height 40% --reverse'
fe() {
    local files
    IFS=$'\n' files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))
    [[ -n "$files"]] && ${EDITOR:-vim} "${files[@]}"
}

# oh-my-zsh
source $ZSH/oh-my-zsh.sh
source ~/.zsh_aliases
source ~/powerlevel10k/powerlevel10k.zsh-theme
tmux source ~/.tmux.conf
source ~/functions

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

