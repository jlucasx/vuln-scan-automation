#!/bin/bash

# Variables (Replace these with actual values)
USERNAME="your_username"
PASSWORD="your_password"
SOCKET="/run/gvmd/gvmd.sock"
TASK_NAME="Task_Name"
CONFIG_ID="daba56c8-73ec-11df-a475-002264764cea"  # Full and fast scan config
SCANNER_ID="08b69003-5fc2-4037-a479-93b440211c73" # Default OpenVAS scanner

# Read the target ID from the file
if [ ! -f target_id.txt ]; then
    echo "Target ID file not found. Please run create_target.sh first."
    exit 1
fi

TARGET_ID=$(cat target_id.txt)

echo "Creating a new task..."

# Create the task using the GVM API
TASK_ID=$(sudo -u _gvm gvm-cli --gmp-username "$USERNAME" --gmp-password "$PASSWORD" socket --socketpath "$SOCKET" --xml "<create_task><name>${TASK_NAME}</name><config id='${CONFIG_ID}'/><target id='${TARGET_ID}'/><scanner id='${SCANNER_ID}'/></create_task>" | grep -oP '(?<=id=")[^"]+')

if [ -z "$TASK_ID" ]; then
    echo "Failed to create task."
    exit 1
else
    echo "Task created successfully with ID: $TASK_ID"
    echo $TASK_ID > task_id.txt
fi
