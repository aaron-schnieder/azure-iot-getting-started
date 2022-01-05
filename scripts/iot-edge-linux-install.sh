## -------
# Ubuntu Server 18.04
# Bash script to setup Azure IoT Edge Runtime

#! /bin/bash

set -e # stop script execution on failure
set -x

# Write stdout and stderr to a log.txt file with this script name
SCRIPT_LOG_FILE="${0##*/}.log.txt"
exec > >(tee $SCRIPT_LOG_FILE)
exec 2>&1

## -------
# IoT Edge download and install

# Download Azure Ubuntu package list
curl https://packages.microsoft.com/config/ubuntu/18.04/multiarch/prod.list > ./microsoft-prod.list

# Copy the package list to the sources.list.d directory.
sudo cp ./microsoft-prod.list /etc/apt/sources.list.d/

# Install the Microsoft GPG public key
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo cp ./microsoft.gpg /etc/apt/trusted.gpg.d/

# Update package lists on the device
sudo apt-get update

# Install the Moby engine
sudo apt-get install moby-engine

# Update package lists on the device
sudo apt-get update

# Install IoT Edge
sudo apt-get install iotedge

##
# Setup device with Azure IoT Edge identity and authentication

echo "Follow device provisioning instructions at https://docs.microsoft.com/en-us/azure/iot-edge/how-to-provision-single-device-linux-symmetric?view=iotedge-2018-06&tabs=azure-cli#provision-the-device-with-its-cloud-identity"
