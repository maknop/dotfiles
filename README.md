# Install Dev Environment

My dotfiles work specifically with a MacOS  development environment
(Still working out issues downloading on Linux).

- [Vim Commands](https://github.com/maknop/ansible-dot#vim-commands)
- [Tmux Commands](https://github.com/maknop/ansible-dot#tmux-commands)

## Vim Commands
| Keyboard Command | Description                               |  
|------------------|-------------------------------------------|  
| i                | insert mode                               |  
| jk               | Exit insert mode                          |  
| h, j, k, l       | Left, down, up, right (Respectively)      |  
| e                | Move forward by a word                    |  
| w                | Move back by a word                       |  
| yy               | Copies line to buffer                     |  
| dd               | Deletes line, stores line in buffer       |  
| p                | Pastes contents stored in the buffer      |  
| shift + v        | Visual mode, highlights entire line       |
| v                | Visual mode, highlights single character  |
| :vs <filename>   | Vertical split (filename optional)        |
| :sp <filename>   | Horizontal split (filename optional)      |

## Tmux Commands
| Keyboard Command | Description                               |  
|------------------|-------------------------------------------|  
| ctrl-a           | Redefined prefix command                  |  
| ctrl-a -         | Vertical window                           |  
| ctrl-a =         | Horizontal window                         |  
| ctrl-a \[        | Enters copy mode                          |  
| ctrl-a ]         | Paste copied text                         |
| ts <name>        | Create a tmux session                     |  
| ta <name>        | Reattaches to a previous tmux session     |  
| tk <name>        | Kills tmux session                        |  
| tl               | Lists all current tmux sessions           |  
| ctrl-a i         | Install addons using TPM                  |  
| ctrl-a y         | Copy text from tmux to system clipboard   |  

