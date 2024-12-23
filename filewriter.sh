#!/bin/bash

raid_device="/dev/md127"

while true; do
    # Generate a random file name should be unique to avoid overwriting
    FILENAME="file_$(date +%s%N).txt"
    # Create a file with a size of 100KB
    dd if=/dev/urandom of="/media/raid/$FILENAME" bs=1024 count=100

    # Check if the user wants to stop the script
    read -t 1 -n 1 key
    if [[ $key = q ]]; then
        echo "Script stopped by user."
        break
    fi
done