#!/bin/bash
TITLE="\033[31m"
NORMAL="\033[0m"
BASE_URL="https://raw.githubusercontent.com/SSEHUB/AI-Performance-Analytics/refs/heads/main/"

downloadScript() {
    curl -fsSL "${BASE_URL}/$1" -o $1
    sudo chmod +x $1
}

echo "${TITLE}Installing Required Packages${NORMAL}"
sudo apt -y install s-tui btop dmidecode lm-sensors tmux
# sudo sensors-detect --auto

echo "${TITLE}Downloading Scripts${NORMAL}"
downloadScript cpu_monitor.sh
downloadScript gpu_monitor.sh
downloadScript ram_monitor.sh
downloadScript computeAvg.sh
downloadScript perftest.sh
downloadScript dashboard.tmux
downloadScript stresstext.tmux
downloadScript modded-nogpt.run.sh

