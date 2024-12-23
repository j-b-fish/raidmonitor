#!/bin/bash

# RAID-Gerät angeben
RAID_DEVICE="/dev/md127"

JSONPATH="/var/log/raid_status.json"

# Check if the log file exists, if not create it
if [ ! -f "$JSONPATH" ]; then
    touch $JSONPATH
fi

#Check if the RAID_DEVICE exists
if [ ! -b "$RAID_DEVICE" ]; then
    echo "RAID device $RAID_DEVICE does not exist!"
    exit 1
fi

#Check if mdadm is installed
if ! command -v mdadm &> /dev/null
then
    echo "mdadm could not be found"
    exit 1
else 
    echo "mdadm is installed"
fi

# RAID-Statusinformationen extrahieren
RAID_STATUS=$(mdadm --detail $RAID_DEVICE)

# Statusinformationen anzeigen
#echo "$RAID_STATUS"

# Spezifische Statusinformationen extrahieren
STATE=$(echo "$RAID_STATUS" | grep 'State :' | awk '{print $3}')
ACTIVE_DEVICES=$(echo "$RAID_STATUS" | grep 'Active Devices :' | awk '{print $4}')
FAILED_DEVICES=$(echo "$RAID_STATUS" | grep 'Failed Devices :' | awk '{print $4}')
SPARE_DEVICES=$(echo "$RAID_STATUS" | grep 'Spare Devices :' | awk '{print $4}')

#clear

# Statusinformationen ausgeben
echo "RAID State: $STATE"
echo "Active Devices: $ACTIVE_DEVICES"
echo "Failed Devices: $FAILED_DEVICES"
echo "Spare Devices: $SPARE_DEVICES"

#Delete the old json file
#Check if the json file exists, if yes delete it
if [ -f $JSONPATH ]; then
    rm $JSONPATH
fi

#Write all the echo commands in a single json file
echo "{" > .$JSONPATH
echo "  \"RAID State\": \"$STATE\"," >> $JSONPATH
echo "  \"Active Devices\": \"$ACTIVE_DEVICES\"," >> $JSONPATH
echo "  \"Failed Devices\": \"$FAILED_DEVICES\"," >> $JSONPATH
echo "  \"Spare Devices\": \"$SPARE_DEVICES\"," >> $JSONPATH
# echo additional the current date and time
echo "  \"Date\": \"$(date)\"" >> $JSONPATH
echo "}" >> .$JSONPATH

python /home/boike/raidmonitor/python/OS-service/publish_to_rabbitmq.py

