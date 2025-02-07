#!/bin/bash
TITLE="\033[31m"
NORMAL="\033[0m"

echo -e "${TITLE}Installing Required Packages${NORMAL}"
sudo apt -y install s-tui btop dmidecode lm-sensors tmux
# sudo sensors-detect --auto
