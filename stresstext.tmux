#!/bin/bash

# Session Name
SESSION="Benchmark"
SESSIONEXISTS=$(tmux list-sessions | grep $SESSION)

GPUS="$1"
BATCH_SIZE="$2"

# Start the tmux server if not running
if ! pgrep -x "tmux" > /dev/null; then
    tmux start-server
fi

if ! tmux has-session -t $SESSION 2>/dev/null; then
# Check if exactly two arguments are given
    if [ "$#" -ne 2 ]; then
        echo  -e "\e[31mUsage: \e[33m$0 <n GPUs> <Batch Size>\e[0m" > /dev/null
        exit 1
    fi

    # Create a new session
    tmux new-session -d -s $SESSION

    tmux split-window -h -t $SESSION
    tmux split-window -v -t $SESSION:0.1 -l 1%  # Create a 1-line height pane at the bottom

    tmux send-keys -t $SESSION:0.1 "nvtop" C-m

    tmux send-keys -t $SESSION:0.0 "cd modded-nanogpt" C-m
    tmux send-keys -t $SESSION:0.0 "source venv/bin/activate" C-m
    tmux send-keys -t $SESSION:0.0 "./run.sh $GPUS $BATCH_SIZE" C-m

    # Send keybinding info to the small pane
    tmux send-keys -t $SESSION:0.2 "clear && echo -e '\e[1A\e[K\033[33;41mTMUX Shortcuts\e[0m\nF1  \e[30m\e[46mDashboard\e[0m  |  F2  \e[30m\e[46mStresstest\e[0m  |  F10 \e[30m\e[46mDetach\e[0m  |  F12 \e[30m\e[46mExit & Close\e[0m'" C-m

    # Set key bindings
    tmux bind-key -n F1 switch-client -t Dashboard
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
