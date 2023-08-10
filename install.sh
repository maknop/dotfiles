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

source ./scripts/helpers.sh

set_linux_package_installer

echo "Linux command is: ${LINUX_PACKAGE_INSTALL_COMMAND}"

echo "Installing OS specific programs"
if [ OS_NAME == "Linux" ]; then
    echo "OS identified as Linux"
    ./scripts/linux_install.sh

else if [ OS_NAME == "Darwin" ]; then
    echo "OS identified as MacOS"
    ./scripts/macos_install.sh

else
    echo "Cannot identify OS of this system"
    exit 0
fi

# # Symlink dotfiles
# ln -sf {dotfiles_dir}/.[!.]* $HOME

echo "Dotfiles successfully installed for ${OS_NAME}. Happy Hacking :D"
