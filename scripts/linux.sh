#!/bin/sh

check_linux_distro() {

    # ubuntu or fedora
    local LINUX_DISTRO=$(awk -F= '$1=="ID" { print $2 ;}' /etc/os-release)

    if [ "$LINUX_DISTRO" == "ubuntu" ]; then
        echo "apt"
    elif [ "$LINUX_DISTRO" == "fedora" ]; then
        echo "dnf"
    fi

    echo ""
}

LINUX_PACKAGE_RUNTIME=$(check_linux_distro)

git --version 2>&1 >/dev/null
IS_GIT_AVAILABLE=$?

if [ "$IS_GIT_AVAILABLE" -eq 0 ]; then
    sudo "$LINUX_PACKAGE_RUNTIME" install -y git   
fi

# Install oh-my-zsh
chsh -s /bin/zsh
sudo "$LINUX_PACKAGE_RUNTIME" install -y zsh 
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install Neovim
sudo "$LINUX_PACKAGE_RUNTIME" install -y neovim python3-neovim

# Install Plug for Neovim package management
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install Tmux
sudo "$LINUX_PACKAGE_RUNTIME" install -y tmux
# Install Tmux Plugin Manager (TPM)
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

