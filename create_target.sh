#!/bin/bash

# Variables (Replace these with actual values)
USERNAME="your_username"
PASSWORD="your_password"
SOCKET="/run/gvmd/gvmd.sock"
TARGET_NAME="Target_Name"
TARGET_HOST="192.168.1.1"  # Replace with your target IP

echo "Creating a new target..."

# Create the target using the GVM API
TARGET_ID=$(sudo -u _gvm gvm-cli --gmp-username "$USERNAME" --gmp-password "$PASSWORD" socket --socketpath "$SOCKET" --xml "<create_target><name>${TARGET_NAME}</name><hosts>${TARGET_HOST}</hosts><port_list id='33d0cd82-57c6-11e1-8ed1-406186ea4fc5'></port_list></create_target>" | grep -oP '(?<=id=")[^"]+')

if [ -z "$TARGET_ID" ]; then
    echo "Failed to create target."
    exit 1
else
    echo "Target created successfully with ID: $TARGET_ID"
    echo $TARGET_ID > target_id.txt
fi
