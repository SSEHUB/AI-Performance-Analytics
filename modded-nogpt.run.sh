#!/bin/bash
# 1st argument = number of GPUS
# 2nd argument = batch length (default 64) - reduce if out of GPU memory

# Check if the first argument is provided
if [ -z "$1" ]; then
    echo "Error: The first argument is required."
    exit 1
fi

# Set a default value for the second argument if not provided
BATCH_SIZE=${2:-64}

echo "torchrun --standalone --nproc_per_node=$1 train_gpt.py $1 $BATCH_SIZE"
torchrun --standalone --nproc_per_node=$1 train_gpt.py $1 $BATCH_SIZE
# torchrun --standalone --nproc_per_node=$ train_gpt.py

