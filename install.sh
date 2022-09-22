#!/bin/bash

printf '\n#######################################################\n'
printf   '##                                                   ##\n'
printf   '##           Installing Dev Environment              ##\n'
printf   '##                                                   ##\n'
printf   '#######################################################\n'

if [ ! -f ~/.zshrc ]; then
    printf '\nInstalling ZSH'
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    printf '\nSetting default shell as ZSH'
    chsh -s $(which zsh)
else
    printf '\nZSH is already installed'
fi

if [ ! -d ~/.tmux ]; then
    git clone https://github.com/tmux/tmux.git
    cd tmux
    sh autogen.sh
    ./configure
    make && sudo make install
else
    printf '\nTmux is already installed'
fi

#cp -rsf "$dotfiles_home"/. ~
ln -sf git/* $HOME/
ln -sf tmux/* $HOME/
ln -sf vim/* $HOME/
ln -sf zsh/* $HOME/