#!/bin/bash

echo "Reading file cleanly..."

# Read file line-by-line natively without external utilities
while read -r col1 col2 col3 || [ -n "$col1" ]; do
    if [ "$col1" = ".food_ptr" ]; then
        echo "Found label: $col1 $col2 $col3"
        
        # Strip leading '0' and trailing 'H' using pure string manipulation
        hex=${col3#0}
        hex=${hex%H}
        
        # Convert hex to decimal (16# tells Bash it is Base-16)
        dec_val=$((16#$hex))
        storage=$((dec_val - 2))
        free=$((24576 - storage))
        
        echo "Remaining bytes before &6000: $free"
        exit 0
    fi
done < "-s"

echo "[ERROR] Finished reading, but '.food_ptr' wasn't matched."