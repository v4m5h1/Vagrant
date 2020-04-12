#!/bin/bash
# Purpose: To split into panes using tmux.
# Execution: "./tmux_local.sh"

sessionname="ansible-session"

cd="cd ~/workbench/Vagrant/ansible-servers"

defaultCommand="$cd;"

tmux kill-session -t $sessionname

tmux set-option remain-on-exit on

# Pane 1 settings
tmux new-session -d -s $sessionname 
tmux send-keys "$defaultCommand vagrant ssh ansible_control" C-m

# Pane 2 settings
tmux split-window -p 20 -v
tmux send-keys "$defaultCommand vagrant ssh ansible_node1" C-m

# Pane 3 settings
tmux split-window -p 50 -h
tmux send-keys "$defaultCommand vagrant ssh ansible_node2" C-m

tmux -2 attach-session -d -t $sessionname 
