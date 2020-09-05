#!/bin/sh

# Set the location of the repository on github
repository_location="maknop/dotfiles"
repository_branch="master"

# In the repository, this is the folder that contains the dotfiles to copy
dotfiles_folder="dotfiles"

# Check that git is installed
command -v git > /dev/null 2>&1
if (( $? != 0 )) ; then
    echo Git is required to update dotfiles 1>&2
    exit 1
fi

# Installs oh-my-zsh as alternative to bash
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Clone dotfiles if they aren't present
if [ ! -d "$HOME/.dotfiles" ]; then
    # Clone the dotfiles
    echo Cloning remote dotfiles...
    git clone --recursive https://github.com/${repository_location} -b ${repository_branch} ${HOME}/.dotfiles
    git_exit_status=$?
fi

# Pull the most updated copy
cd $HOME/.dotfiles && git pull
git_exit_status=$?

# If the clone/pull operation failed, exit with the exit status provided by git
if (( $git_exit_status != 0 )) ; then
    echo There was an error while attempting to clone/pull dotfiles! 1>&2
    exit $git_exit_status
fi

# Symlink all the files
echo Symlinking dotfiles into ${HOME}
ln -sf $HOME/.dotfiles/dotfiles/.[!.]* $HOME

# Checks if OS is Unix or MacOS
echo Making zsh the default shell...
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    sudo chsh -s /bin/zsh 
elif [[ "$OSTYPE" == "darwin"* ]]; then        
    chsh -s /bin/zsh 
fi

echo Copying oxide theme into themes folder in oh-my-zsh directory...
cp $HOME/.dotfiles/dotfiles/oxide.zsh-theme ../.oh-my-zsh/themes

echo Sourcing zshrc file...
./.zshrc
