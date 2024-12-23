#!/bin/bash

# Define the service and timer file names
SERVICE_FILE="monitor.service"
TIMER_FILE="monitor.timer"

# Define the destination paths
SYSTEMD_PATH="/etc/systemd/system/"

# Copy the service and timer files to the systemd directory
sudo cp services/$SERVICE_FILE $SYSTEMD_PATH
sudo cp services/$TIMER_FILE $SYSTEMD_PATH

# Reload systemd to recognize the new service and timer
sudo systemctl daemon-reload

# Enable the service and timer
sudo systemctl enable $SERVICE_FILE
sudo systemctl enable $TIMER_FILE

# Start the service and timer
sudo systemctl start $SERVICE_FILE
sudo systemctl start $TIMER_FILE

# Start the service and timer
sudo systemctl status $SERVICE_FILE
#Schlafen für 5 Sekunden
sleep 5
sudo systemctl status $TIMER_FILE

#Check if the service and timer are running and if print a success message
if [ $? -eq 0 ]; then
    echo "Service and timer have been installed and started successfully."
else
    echo "Service and timer have not been installed and started successfully."
fi

#echo "Service and timer have been installed and started successfully."