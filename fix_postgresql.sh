#!/bin/bash

echo "Listing PostgreSQL clusters..."
pg_lsclusters

echo "Stopping and removing the higher-numbered cluster..."
sudo pg_ctlcluster 17 main stop
sudo pg_dropcluster 17 main

echo "Upgrading PostgreSQL cluster..."
sudo pg_upgradecluster 16 main

echo "Deleting old cluster..."
sudo pg_dropcluster 16 main

echo "Removing old PostgreSQL packages..."
sudo apt autoremove -y

echo "Configuring new PostgreSQL cluster to use port 5432..."
sudo sed -i 's/^port = 5433/port = 5432/' /etc/postgresql/17/main/postgresql.conf

echo "Restarting PostgreSQL service..."
sudo systemctl restart postgresql

echo "Re-running GVM setup and check..."
sudo gvm-setup
sudo gvm-check-setup

echo "Stopping and starting GVM services..."
sudo gvm-stop
sudo gvm-start
