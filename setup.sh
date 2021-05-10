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

# Installing programs based on detected OS.
if [[ `uname` == "Darwin" ]]; then
    echo 'Installing Oh-My-Zsh as alternative to Bash'
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    if [[ ! -d /Applications/iTerm.app ]]; then
        echo 'Installing iterm2 with Brew'
        brew install iterm2
    else
        echo Iterm2 is already installed...\n
    fi

    #if [ type tmux >/dev/null 2>/dev/null ]; then
        echo Installing tmux with Brew\n
        brew install tmux
        brew upgrade tmux
    #else
        echo Tmux is already installed...\n
    #fi

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
cd $HOME/.dotfiles && git pull --ff-only
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

if [ ! -d "$HOME/.vim/bundle/Vundle.vim" ]; then
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    echo Setup Vundle for VIM package management...\n
else
    echo Vundle is already installed\n
fi

if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    echo tpm installed\n
else
    echo tpm is already installed\n
fi

echo Installing Vim packages with Vundle...
vim -c 'PluginInstall' -c 'qa!'

echo Finished installing dotfiles. Please source the relevant files for your shell.
