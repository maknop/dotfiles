function tka --description 'Tmux kill all sessions except current'
    tmux kill-session -a $argv
end
