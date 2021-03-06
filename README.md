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
curl https://raw.githubusercontent.com/maknop/dotfiles/main/setup.sh | sh
```

You will want to then source the zshrc file.
```
source ~/.zshrc
```

## Vundle for Vim Plugins
My vimrc utilizes Vundle for package management. the `setup.sh` script  
will install them towards the end of its execution.


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
