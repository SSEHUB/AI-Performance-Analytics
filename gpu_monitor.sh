#!/bin/bash

# Output file
TIMESTAMP=$(date -d "today" +"%Y%m%d%H%M")
OUTPUT_FILE="$TIMESTAMP-GPU.csv"
QUERY="timestamp,index,clocks.sm,clocks.mem,temperature.gpu,pstate,fan.speed,power.draw.instant,power.draw.average"

# Header for the log file
GPU_INFO=$(nvidia-smi --query-gpu=$QUERY --format=csv,nounits | awk -F',' '{cmd="date -d \"" $1 "\" +\"%Y-%m-%d %H:%M:%S\""; cmd | getline new_time; close(cmd); $1=new_time; print $0}' OFS=",")
echo "sep=," > "$OUTPUT_FILE"
echo "$GPU_INFO" >> "$OUTPUT_FILE"

ODD=true

# Continuous loop
while true; do
    # Get GPU information
    GPU_INFO=$(nvidia-smi --query-gpu=$QUERY --format=csv,noheader,nounits | awk -F',' '{cmd="date -d \"" $1 "\" +\"%Y-%m-%d %H:%M:%S\""; cmd | getline new_time; close(cmd); $1=new_time; print $0}' OFS=",")

    # Print to terminal
    if [ "$ODD" = true ]; then
        echo  -e "\e[1A\e[K\033[31;43mLogging GPU Data\033[0m"
        ODD=false
    else
        echo  -e "\e[1A\e[K\033[33;41mLogging GPU Data\033[0m"
        ODD=true
    fi

    # Append to file
    echo "$GPU_INFO" >> "$OUTPUT_FILE"

    # Wait 1 second before next update
    sleep 1
done
