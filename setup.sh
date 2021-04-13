#!/bin/bash

# Set the location of the repository on github
repository_location="maknop/dotfiles"
repository_branch="main"

# In the repository, this is the folder that contains the dotfiles to copy
dotfiles_folder="files"

# Check that git is installed
echo Verifying that Git is installed...
command -v git > /dev/null 2>&1
if (( $? != 0 )) ; then
    echo Git is required to update dotfiles 1>&2
    exit 1
fi

# Installs oh-my-zsh as alternative to bash
echo Installing Oh-My-Zsh as shell alternative to Bash
if [[ `uname` == "Darwin" ]]; then
    echo 'Installing Oh-My-Zsh as alternative to Bash'
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/main/tools/install.sh)"

    echo 'Installing iterm2 with Brew'
    brew install iterm2

    echo 'Installing tmux with Brew'
    brew install tmux
    brew upgrade tmux

elif [[ `uname` == "Linux" ]]; then
    echo 'Installing Oh-My-Zsh as alternative to Bash'
    sudo apt-get install zsh

    echo 'Installing Yakuake'
    sudo apt-get install yakuake

    echo 'Installing tmux'
    sudo apt install tmux

else
    echo 'Unknown OS!'
fi

# Clone dotfiles if they aren't present
if [ ! -d "$HOME/.dotfiles" ]; then
    # Clone the dotfiles
    echo Cloning remote dotfiles...
    git clone --recursive https://github.com/${repository_location} -b ${repository_branch} $HOME/.dotfiles
    git_exit_status=$?
fi

# Pull the most updated copy
echo Pulling most updated copy of dotfiles...
cd $HOME/.dotfiles && git pull
git_exit_status=$?

# If the clone/pull operation failed, exit with the exit status provided by git
if (( $git_exit_status != 0 )); then
    echo There was an error while attempting to clone/pull dotfiles! 1>&2
    exit $git_exit_status
elif (( $git_exit_status == 0 )); then
    echo Successfully clone/pulled dotfiles!
fi

if [ -f ~/.functions ]; then
    . ~/.functions
fi

# Symlink all the files
echo Symlinking dotfiles into ${HOME}
ln -sf $HOME/.dotfiles/files/.[!.]* $HOME

echo Creating a vim directory.
if [ ! -d "$HOME/.vim" ]; then 
    echo Creating a vim folder...
    mkdir .vim
    mkdir .vim/bundle
fi

echo Setup Vundle for VIM package management...
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

#echo Run :PluginInstall when starting vim if plugins are not installed. 

echo Runs PluginInstall for Vundle packages to install from the terminal
vim -c 'PluginInstall' -c 'qa!'

echo Finished installing dotfiles. Please source the relevant files for your shell.
