#!/bin/sh
tmux new-session -d

tmux split-window -v
tmux select-pane -U
tmux split-window -h

tmux resize-pane -D 12
tmux -2 attach-session -d
