#!/bin/bash

if [ ! -f ~/.zshrc ]; then
    printf '\nInstalling ZSH\n'
    sudo dnf -y install zsh
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    printf '\nSetting default shell as ZSH\n'
    chsh -s $(which zsh)
else
    printf '\nZSH is already installed\n'
fi

if [ ! -d /bin/tmux ]; then
    sudo dnf -y install tmux
else
    printf '\nTmux is already installed'
fi