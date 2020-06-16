#!/bin/sh
tmux new-session -d

tmux split-window -v
tmux split-window -h
tmux resize-pane -D 10
tmux resize-pane -R 12
tmux select-pane -U
tmux split-window -h

tmux -2 attach-session -d
