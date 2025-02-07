#!/bin/bash
TITLE="\033[31m"
NORMAL="\033[0m"
BASE_URL="https://raw.githubusercontent.com/SSEHUB/AI-Performance-Analytics/refs/heads/main/"

echo -e "${TITLE}Installing Required Packages${NORMAL}"
sudo apt -y install s-tui btop dmidecode lm-sensors tmux
# sudo sensors-detect --auto

echo -e "${TITLE}Downloading Scripts${NORMAL}"
curl -fsSL "${BASE_URL}/cpu_monitor.sh"

