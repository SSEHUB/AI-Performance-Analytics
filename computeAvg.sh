#!/bin/bash

# Ensure a log file is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <logfile>"
    exit 1
fi

LOGFILE="$1"

# Extract step_avg values, ignoring 'nanms', and compute the average
AVG=$(grep -oE 'step_avg:[0-9]+\.?[0-9]*ms' "$LOGFILE" |
      grep -oE '[0-9]+\.?[0-9]*' |
      awk '{sum += $1; count++} END {if (count > 0) print sum / count; else print "No valid values"}')

echo "Average step_avg: $AVG ms"
