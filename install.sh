#!/bin/bash
TITLE="\033[31m"
NORMAL="\033[0m"
BASE_URL="https://raw.githubusercontent.com/SSEHUB/AI-Performance-Analytics/refs/heads/main/"

echo -e "${TITLE}Installing Required Packages${NORMAL}"
sudo apt -y install s-tui btop dmidecode lm-sensors tmux
# sudo sensors-detect --auto

echo -e "${TITLE}Downloading Scripts${NORMAL}"
curl -fsSL "${BASE_URL}/cpu_monitor.sh" -o cpu_monitor.sh
sudo chmod +x cpu_monitor.sh

curl -fsSL "${BASE_URL}/gpu_monitor.sh" -o gpu_monitor.sh
sudo chmod +x gpu_monitor.sh

curl -fsSL "${BASE_URL}/ram_monitor.sh" -o ram_monitor.sh
sudo chmod +x ram_monitor.sh

