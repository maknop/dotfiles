#!/bin/bash

# Set the location of the repository on github
repository_location="maknop/dotfiles"
repository_branch="main"

# In the repository, this is the folder that contains the dotfiles to copy
dotfiles_folder="files"

# Terminal Font Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
LIGHTBLUE='\033[1;34m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
WHITE='\033[1;37m'

# Check that git is installed
echo "${GREEN}Verifying that Git is installed...${WHITE}\n"
command -v git > /dev/null 2>&1
if (( $? != 0 )) ; then
    echo "${RED}Git is required to update dotfiles 1>&2${WHITE}\n"
    exit 1
fi
echo "${GREEN}Git is installed on this device!\n"

# Installing programs based on detected OS.
if [[ `uname` == "Darwin" ]]; then
    if [ ! -d "${HOME}/.oh-my-zsh" ]; then
        echo "${GREEN}Installing Oh-My-Zsh as alternative to Bash${WHITE}"
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    else
        echo "${LIGHTBLUE}Oh-My-Zsh is already installed...${WHITE}"
    fi

    if [[ ! -d "/Applications/iTerm.app" ]]; then
        echo "${GREEN}Installing iterm2 with Brew${WHITE}"
        brew install iterm2
    else
        echo "${LIGHTBLUE}Iterm2 is already installed...${WHITE}"
    fi

    if [ type tmux >/dev/null 2>/dev/null ]; then
        echo "${GREEN}Installing tmux with Brew${WHITE}"
        brew install tmux && brew upgrade tmux
    else
        echo "${LIGHTBLUE}Tmux is already installed...${WHITE}"
    fi

elif [[ `uname` == "Linux" ]]; then
    echo "${GREEN}Installing Oh-My-Zsh as alternative to Bash${WHITE}"
    sudo apt-get install zsh

    echo "${GREEN}Installing Yakuake${WHITE}"
    sudo apt-get install yakuake

    echo "${GREEN}Installing tmux${WHITE}"
    sudo apt install tmux

else
    echo "${RED}Unknown OS!"
fi

# Clone dotfiles if they aren't present
if [ ! -d "$HOME/.dotfiles" ]; then
    # Clone the dotfiles
    echo "${GREEN}Cloning remote dotfiles...${WHITE}"
    git clone --recursive https://github.com/${repository_location} -b ${repository_branch} $HOME/.dotfiles
    git_exit_status=$?
fi

# Pull the most updated copy
echo "${GREEN}Pulling most updated copy of dotfiles...${WHITE}"
cd $HOME/.dotfiles && git pull --ff-only
git_exit_status=$?

# If the clone/pull operation failed, exit with the exit status provided by git
if (( $git_exit_status != 0 )); then
    echo "${RED}There was an error while attempting to clone/pull dotfiles! 1>&2${WHITE}"
    exit $git_exit_status
elif (( $git_exit_status == 0 )); then
    echo "${GREEN}Successfully clone/pulled dotfiles!${WHITE}" 
fi

if [ -f ~/.functions ]; then
    . ~/.functions
fi

# Symlink all the files
echo "${GREEN}Symlinking dotfiles into ${HOME}${WHITE}"
ln -sf $HOME/.dotfiles/files/.[!.]* $HOME

echo "${GREEN}Creating a vim directory.${WHITE}"
if [ ! -d "$HOME/.vim" ]; then 
    echo "${GREEN}Creating a vim folder...${WHITE}"
    mkdir .vim
    mkdir .vim/bundle
fi

if [ ! -d "$HOME/.vim/bundle/Vundle.vim" ]; then
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    echo "${GREEN}Setup Vundle for VIM package management${WHITE}"
else
    echo "${LIGHTBLUE}Vundle is already installed...${WHITE}"
fi

if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    echo "${GREEN}tpm installed...${WHITE}"
else
    echo "${LIGHTBLUE}tpm is already installed${WHITE}"
fi

echo "${GREEN}Installing Vim packages with Vundle...${WHITE}"
script -c 'vim' -c 'PluginInstall' -c 'qa!'

echo "${PURPLE}Finished installing dotfiles. Happy coding!${WHITE}"
