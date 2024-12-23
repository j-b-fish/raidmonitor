#!/bin/bash

# Check if the log directory exists, if not create it
if [ ! -d "./log" ]; then
    mkdir ./log
fi

# Check if the raid_status.log file exists, if not create it
if [ ! -f "./log/raid_status.log" ]; then
    touch ./log/raid_status.log
fi

# Check RAID status
mdadm --detail --scan > ./log/raid_status.log