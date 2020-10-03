# Dotfiles

My dotfiles work specifically with a MacOS  development environment
(Still working out issues downloading on Linux).

### Installation
Navigate to your root directory and copy/paste the following  
into your favorite terminal.
```
curl https://github.com/maknop/dotfiles/blob/main/update.sh | sh
```

You will want to then source the zshrc file.
```
source ~/.zshrc
```

My vimrc utilizes Vundle for package management so you'll
want to run this command when .vimrc file is opened to 
install all packages:
```
:PluginInstall
```

### Acknowledgements
Thank you [gizmo385](https://github.com/gizmo385/dotfiles) for the help 😁 
