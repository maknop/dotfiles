#!/bin/bash

echo '''
#######################################################
##                                                   ##
##           Installing Dev Environment              ##
##                                                   ##
#######################################################
'''

dotfiles_dir=$(pwd)
OS_NAME=$(uname)

if [ OS_NAME == "Linux" ]; then
    echo "OS identified as Linux"
    ./scripts/linux_install.sh

else if [ OS_NAME == "Darwin" ]; then
    echo OS identified as MacOS
    ./scripts/macos_install.sh

fi

# Symlink dotfiles
ln -sf {dotfiles_dir}/.[!.]* $HOME

echo "Dotfiles successfully installed for ${OS_NAME}"
