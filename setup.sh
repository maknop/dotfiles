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
printf "${GREEN}Verifying that Git is installed...${WHITE}\n"
command -v git > /dev/null 2>&1
if (( $? != 0 )) ; then
    printf "${RED}Git is required to update dotfiles 1>&2${WHITE}\n"
    exit 1
fi
printf "${GREEN}Git is installed on this device!\n"

# Installing programs based on detected OS.
if [[ `uname` == "Darwin" ]]; then
    if [ ! -d "${HOME}/.oh-my-zsh" ]; then
        printf "${GREEN}Installing Oh-My-Zsh as alternative to Bash${WHITE}"
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    else
        printf "${LIGHTBLUE}Oh-My-Zsh is already installed...${WHITE}"
    fi

    if [[ ! -d "/Applications/iTerm.app" ]]; then
        printf "${GREEN}Installing iterm2 with Brew${WHITE}"
        brew install iterm2
    else
        printf "${LIGHTBLUE}Iterm2 is already installed...${WHITE}"
    fi

    if [ type tmux >/dev/null 2>/dev/null ]; then
        printf "${GREEN}Installing tmux with Brew${WHITE}"
        brew install tmux && brew upgrade tmux
    else
        printf "${LIGHTBLUE}Tmux is already installed...${WHITE}"
    fi

elif [[ `uname` == "Linux" ]]; then
    printf "${GREEN}Installing Oh-My-Zsh as alternative to Bash${WHITE}"
    sudo apt-get install zsh

    printf "${GREEN}Installing Yakuake${WHITE}"
    sudo apt-get install yakuake

    printf "${GREEN}Installing tmux${WHITE}"
    sudo apt install tmux

else
    printf "${RED}Unknown OS!"
fi

# Clone dotfiles if they aren't present
if [ ! -d "$HOME/.dotfiles" ]; then
    # Clone the dotfiles
    printf "${GREEN}Cloning remote dotfiles...${WHITE}"
    git clone --recursive https://github.com/${repository_location} -b ${repository_branch} $HOME/.dotfiles
    git_exit_status=$?
fi

# Pull the most updated copy
printf "${GREEN}Pulling most updated copy of dotfiles...${WHITE}"
cd $HOME/.dotfiles && git pull --ff-only
git_exit_status=$?

# If the clone/pull operation failed, exit with the exit status provided by git
if (( $git_exit_status != 0 )); then
    printf "${RED}There was an error while attempting to clone/pull dotfiles! 1>&2${WHITE}"
    exit $git_exit_status
elif (( $git_exit_status == 0 )); then
    printf "${GREEN}Successfully clone/pulled dotfiles!${WHITE}" 
fi

if [ -f ~/.functions ]; then
    . ~/.functions
fi

# Symlink all the files
printf "${GREEN}Symlinking dotfiles into ${HOME}${WHITE}"
ln -sf $HOME/.dotfiles/files/.[!.]* $HOME

printf "${GREEN}Creating a vim directory.${WHITE}"
if [ ! -d "$HOME/.vim" ]; then 
    printf "${GREEN}Creating a vim folder...${WHITE}"
    mkdir .vim
    mkdir .vim/bundle
fi

if [ ! -d "$HOME/.vim/bundle/Vundle.vim" ]; then
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    printf "${GREEN}Setup Vundle for VIM package management${WHITE}"
else
    printf "${LIGHTBLUE}Vundle is already installed...${WHITE}"
fi

if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    printf "${GREEN}tpm installed...${WHITE}"
else
    printf "${LIGHTBLUE}tpm is already installed${WHITE}"
fi

printf "${GREEN}Installing Vim packages with Vundle...${WHITE}"
script -c 'vim' -c 'PluginInstall' -c 'qa!'

printf "${PURPLE}Finished installing dotfiles. Happy coding!${WHITE}"
