#!/bin/bash

echo -e "\033[31mUsed Memory Slots\033[0m"

# Locate a line that has a value if a Memory is placed and print the lines before containing the used Slot
sudo dmidecode -t memory | grep -B 2 "Type: DDR" | grep "Locator"
