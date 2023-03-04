#!/bin/bash

echo '
#######################################################
##                                                   ##
##           Installing Dev Environment              ##
##                                                   ##
#######################################################'

NIX_DIR_PATH=$HOME/
ZSHRC_FILE_PATH=$HOME/.zshrc
TMUX_DIR_PATH=$HOME/.tmux

echo '
#######################################################
##                Installing Nix                     ##
#######################################################'

if [[ ! -d $HOME/.nix-profile ]]; then
    sudo curl -L https://nixos.org/nix/install | sh -s --
else
    echo '\nNix is already installed for this user'
fi

echo '
#######################################################
##             Installing oh-my-zsh                  ##
#######################################################'

if [[ ! -f ZSH_FILE ]]; then
    echo 'Installing ZSH'
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

if [[ ! $(echo $SHELL) == '/bin/zsh' ]]; then
    echo 'Setting default shell as ZSH'
    chsh -s $(which zsh)
else
    echo 'zsh is already the default shell'
fi
