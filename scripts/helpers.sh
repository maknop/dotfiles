#!/bin/bash

function set_linux_package_installer() {
    if [ "cat /etc/*-release | grep fedora" == "" ]; then
        echo "Setting 'dnf' as linux package manager"
        LINUX_PACKAGE_MANAGER_COMMAND="dnf"

    else
        echo "Setting 'apt' as linux package manager"
        LINUX_PACKAGE_MANAGER_COMMAND="apt"

    fi
}

# function install_zsh() {
#    LINUX_PACKAGE_MANAGER_COMMAND install zsh
#     sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

#    chsh -s $(which zsh)
# }

# function install_neovim() {

# }

# function install_tmux() {

# }
