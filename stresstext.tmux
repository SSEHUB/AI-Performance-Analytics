#!/bin/bash

# Session Name
SESSION="Benchmark"
SESSIONEXISTS=$(tmux list-sessions | grep $SESSION)

# Start the tmux server if not running
if ! pgrep -x "tmux" > /dev/null; then
    tmux start-server
fi

if ! tmux has-session -t $SESSION 2>/dev/null; then
    # Create a new session
    tmux new-session -d -s $SESSION

    tmux split-window -h -t $SESSION

    tmux send-keys -t $SESSION:0.1 "nvtop" C-m

    tmux send-keys -t $SESSION:0.0 "cd modded-nanogpt" C-m
    tmux send-keys -t $SESSION:0.0 "source venv/bin/activate" C-m
    tmux send-keys -t $SESSION:0.0 "./run.sh 2 32" C-m

    # Set key bindings
    tmux bind-key -n F10 detach-client
    tmux bind-key -n F12 kill-session
    tmux bind-key -n C-Right select-pane -R  # Move right
    tmux bind-key -n C-Left select-pane -L   # Move left
    tmux bind-key -n C-Up select-pane -U     # Move up
    tmux bind-key -n C-Down select-pane -D   # Move down
else
    tmux a -t $SESSION
fi

# Attach to the session
tmux attach -t $SESSION
