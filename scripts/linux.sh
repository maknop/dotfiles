#!/bin/sh

check_linux_distro() {

    # ubuntu or fedora
    linux_distro=$(awk -F= '$1=="ID" { print $2 ;}' /etc/os-release)

    if [ linux_distro == "ubuntu" ]; then
        return "apt"
    elif [ linux_distro == "fedora" ]; then
        return "dnf"
    fi

    return ""
}

linux_package_runtime=$(check_linux_distro)

git --version 2>&1 >/dev/null
IS_GIT_AVAILABLE=$?

if [ $IS_GIT_AVAILABLE -eq 0 ]; then
    $linux_package_runtime install -y git   
fi

# Install oh-my-zsh
chsh -s /bin/zsh
sudo $linux_package_runtime install -y zsh 
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install Neovim
sudo $linux_package_runtime install -y neovim python3-neovim

# Install Plug for Neovim package management
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install Tmux
sudo $linux_package_runtime install -y tmux

# Install Tmux Plugin Manager (TPM)
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

