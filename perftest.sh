#!/bin/bash

# Output file
OUTPUT_FILE="performance_results.txt"

# Function to log results to console and file
log() {
    echo "$1" | tee -a "$OUTPUT_FILE"
}

# Clear or create the output file
> "$OUTPUT_FILE"

log "=== Disk Performance Test ==="
# Disk write speed
disk_write_result=$(dd if=/dev/zero of=testfile bs=1M count=1024 conv=fdatasync 2>&1 | awk '/copied/ {print $(NF-1), $NF}')
log "Disk Write Speed: $disk_write_result"
# Disk read speed
disk_read_result=$(dd if=testfile of=/dev/null bs=1M 2>&1 | awk '/copied/ {print $(NF-1), $NF}')
log "Disk Read Speed: $disk_read_result"
rm -f testfile

log "=== CPU Performance Test (Single-Core) ==="
start_time=$(date +%s.%N)
for i in $(seq 1 1000); do echo "scale=10; sqrt($i)" | bc > /dev/null; done
end_time=$(date +%s.%N)
sc_result=$(echo "$end_time - $start_time" | bc)
log "Single-Core CPU Time: $sc_result seconds"

log "=== CPU Performance Test (Multi-Core) ==="
start_time=$(date +%s.%N)
cores=$(nproc)
for core in $(seq 1 $cores); do
    (
        for i in $(seq 1 1000); do
            echo "scale=10; sqrt($i)" | bc > /dev/null
        done
    ) &
done
wait  # Wait for all background tasks to finish
end_time=$(date +%s.%N)
mc_result=$(echo "$end_time - $start_time" | bc)
log "Multi-Core CPU Time: $mc_result seconds"

log "Checking for sysbench..."
if ! command -v sysbench &> /dev/null; then
    log "\nSysbench is not installed. To install, run: sudo apt install sysbench"
    log "Results saved to $OUTPUT_FILE"
    log "Extended tests could not be performed."
    exit 1
fi

log "=== Extended Sysbench Tests ==="

log "--- File I/O Test ---"
sysbench fileio --file-total-size=1G prepare
fileio_result=$(sysbench fileio --file-total-size=1G --file-test-mode=rndrw run | grep -E "reads/s|writes/s")
sysbench fileio --file-total-size=1G cleanup
log "$fileio_result"

log "--- CPU Test (Single Thread) ---"
cpu_single_result=$(sysbench cpu --threads=1 run | grep "total time:" | awk '{print $3}')
log "Single-Thread CPU Time: $cpu_single_result seconds"

log "--- CPU Test (Multi-Threaded) ---"
cpu_multi_result=$(sysbench cpu --threads=$(nproc) run | grep "total time:" | awk '{print $3}')
log "Multi-Threaded CPU Time: $cpu_multi_result seconds"

log "--- Memory Test ---"
memory_result=$(sysbench memory run | grep -E "transferred")
log "$memory_result"

log "--- Threads Test ---"
threads_result=$(sysbench threads run | grep "total time:" | awk '{print $3}')
log "Threads Test Time: $threads_result seconds"

log "--- Mutex Test ---"
mutex_result=$(sysbench mutex run | grep "total time:" | awk '{print $3}')
log "Mutex Test Time: $mutex_result seconds"

log "Performance test completed. Results saved to $OUTPUT_FILE."
