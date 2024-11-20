#!/bin/bash

echo "Updating and upgrading Kali Linux..."
sudo apt update && sudo apt upgrade -y && sudo apt dist-upgrade -y

echo "Installing GVM..."
sudo apt install gvm -y

echo "Running GVM setup..."
sudo gvm-setup

echo "Changing GVM admin password..."
sudo -u _gvm gvmd --user=admin --new-password='your_password'

echo "Verifying GVM installation..."
sudo gvm-check-setup

echo "Starting GVM service..."
sudo gvm-start

echo "Setup complete. Check for errors with 'sudo gvm-check-setup' if login issues occur."
