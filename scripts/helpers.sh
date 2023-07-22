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
#     sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# }

# function install_tmux() {

# }

# function install_neovim() {

# }
