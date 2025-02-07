#!/bin/bash

header() {
    local second=$(date +%S)  # Get the current second
    local color

    if (( second % 2 == 0 )); then
        color="\e[1A\e[K\033[31;43m"  # Red for even seconds
    else
        color="\e[1A\e[K\033[33;41m"  # Yellow for odd seconds
    fi

    echo -e "${color}Monitoring MHz per CPU Core\n\033[0m"
}

monitor() {
cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_cur_freq | awk '
    BEGIN {
        green = "\033[32m";
        yellow = "\033[33m";
        purple = "\033[35m";
        red = "\033[31m";
        reset = "\033[0m";
    }
    {
        if ($1 < 2000000)
            printf "%s%s%s\n", green, $1, reset;  # Green
        else if ($1 >= 2000000 && $1 < 3000000)
            printf "%s%s%s\n", yellow, $1, reset; # Yellow
        else if ($1 >= 3000000 && $1 < 3500000)
            printf "%s%s%s\n", purple, $1, reset; # Purplee
        else
            printf "%s%s%s\n", red, $1, reset;    # Red
    }'
}

header
monitor

