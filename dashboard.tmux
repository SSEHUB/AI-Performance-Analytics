#!/bin/bash

# Session Name
SESSION="Dashboard"
SESSIONEXISTS=$(tmux list-sessions | grep $SESSION)

# Start the tmux server if not running
if ! pgrep -x "tmux" > /dev/null; then
    tmux start-server
fi

if ! tmux has-session -t $SESSION 2>/dev/null; then
    # Create a new session
    tmux new-session -d -s $SESSION

    # Split the first pane into 20% width (left) and 80% width (right)
    tmux split-window -h -l 180 -t $SESSION

    # Split the left pane (pane 0) into 20% height (top) and 80% height (bottom)
    tmux split-window -v -l 15% -b -t $SESSION:0.0
    tmux split-window -v -l 80% -b -t $SESSION:0.0

    # Run nvidia-smi in the top-left pane (pane 0.0)
    tmux send-keys -t $SESSION:0.0 "watch -n 1 nvidia-smi --query-gpu=index,clocks.sm,clocks.mem,temperature.gpu,pstate,fan.speed,power.draw.instant --format=csv,noheader" C-m

    tmux send-keys -t $SESSION:0.1 './gpu_monitor.sh' C-m

    # Run sensors in the bottom-left pane (pane 0.1)
    tmux send-keys -t $SESSION:0.2 "watch -n 1 sensors" C-m

    tmux split-window -h -l 10 -b -t $SESSION:0.3
    tmux split-window -v -l 30 -b -t $SESSION:0.4

    tmux send-keys -t $SESSION:0.3 'watch -n 1 ./cpu_monitor.sh' C-m
    tmux send-keys -t $SESSION:0.4 's-tui' C-m
    tmux send-keys -t $SESSION:0.5 'btop' C-m


    # Select the right pane (pane 1) by default
    tmux select-pane -t $SESSION:0.4

    # Set key bindings
    tmux bind-key -n F2 switch-client -t Benchmark
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
