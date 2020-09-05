#!/bin/bash

# Set the location of the repository on github
repository_location="maknop/dotfiles"
repository_branch="master"

# In the repository, this is the folder that contains the dotfiles to copy
dotfiles_folder="dotfiles"

# Check that git is installed
echo Verifying that Git is installed...
command -v git > /dev/null 2>&1
if (( $? != 0 )) ; then
    echo Git is required to update dotfiles 1>&2
    exit 1
fi

# Installs oh-my-zsh as alternative to bash
echo Installing Oh-My-Zsh as shell alternative to Bash
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Sets zsh as default shell, after checking OS
echo Making zsh the default shell for your terminal...
if (( "$OSTYPE" == "linux-gnu"* )); then  # Unix
    sudo chsh -s /bin/zsh 
elif (( "$OSTYPE" == "darwin"* )); then   # MacOS 
    chsh -s /bin/zsh 
fi

# Clone dotfiles if they aren't present
if [ ! -d "$HOME/.dotfiles" ]; then
    # Clone the dotfiles
    echo Cloning remote dotfiles...
    git clone --recursive https://github.com/${repository_location} -b ${repository_branch} ${HOME}/.dotfiles
    git_exit_status=$?
fi

# Pull the most updated copy
echo Pulling most updated copy of dotfiles...
cd $HOME/.dotfiles && git pull
git_exit_status=$?

# If the clone/pull operation failed, exit with the exit status provided by git
if (( $git_exit_status != 0 )) ; then
    echo There was an error while attempting to clone/pull dotfiles! 1>&2
    exit $git_exit_status
elif (($git_exit_status == 0)) ; then
    echo Successfully clone/pulled dotfiles!
fi

# Symlink all the files
echo Symlinking dotfiles into ${HOME}
ln -sf $HOME/.dotfiles/dotfiles/.[!.]* $HOME

echo Copying oxide theme into themes folder in oh-my-zsh directory...
cp $HOME/.dotfiles/dotfiles/oxide.zsh-theme ../.oh-my-zsh/themes

echo Setup Vundle for VIM package management...
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/autoload/Vundle.vim

