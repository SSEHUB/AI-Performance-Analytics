#!/bin/bash
TITLE="\033[31m"
NORMAL="\033[0m"
BASE_URL="https://raw.githubusercontent.com/SSEHUB/AI-Performance-Analytics/refs/heads/main/"

downoadScript() {
    curl -fsSL "${BASE_URL}/$1" -o $1
    sudo chmod +x $1
}


echo "${TITLE}Installing Required Packages${NORMAL}"
sudo apt -y install s-tui btop dmidecode lm-sensors tmux
# sudo sensors-detect --auto

echo "${TITLE}Downloading Scripts${NORMAL}"
downloadScript cpu_monitor.sh

curl -fsSL "${BASE_URL}/gpu_monitor.sh" -o gpu_monitor.sh
sudo chmod +x gpu_monitor.sh

curl -fsSL "${BASE_URL}/ram_monitor.sh" -o ram_monitor.sh
sudo chmod +x ram_monitor.sh

curl -fsSL "${BASE_URL}/computeAvg.sh" -o computeAvg.sh
sudo chmod +x computeAvg.sh

curl -fsSL "${BASE_URL}/ram_monitor.sh" -o ram_monitor.sh
sudo chmod +x ram_monitor.sh

