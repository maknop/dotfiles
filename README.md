# Dotfiles

My dotfiles work specifically with a MacOS  development environment
(Still working out issues downloading on Linux).

- [Installation](https://github.com/maknop/dotfiles#installation)
- [Vim Commands](https://github.com/maknop/dotfiles#vim-commands)
- [Tmux Commands](https://github.com/maknop/dotfiles#tmux-commands)
- [Acknowledgements](https://github.com/maknop/dotfiles#acknowledgements)

## Installation
Navigate to your root directory and copy/paste the following  
into your favorite terminal.
```
curl https://raw.githubusercontent.com/maknop/dotfiles/main/update.sh | sh
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

## Vim Commands
```
i                 insert mode
jk                Exit insert mode
h, j, k, l        Left, down, up, right
e                 Move forward by a word
w                 Move back by a word
yy                Copies line to buffer
dd                Deletes line, stores line in buffer
p                 Pastes contents stored in the buffer
shift + v         Visual mode, highlights entire line
v                 Visual mode, highlights single character
```

## Tmux Commands
```
ts <name>         Create a tmux session
ta <name>         Reattaches to a previous tmux session
tk <name>         Kills tmux session
tl                Lists all current tmux sessions
```

## Acknowledgements
Thank you [gizmo385](https://github.com/gizmo385/dotfiles) for the help 😁 
