# Azure IoT Infrastructure and Edge Device Setup

This repo provides step by step guidance and scripts to setup new Azure infrastructure for Azure IoT and provision a Linux VM Azure IoT Edge device.

## Azure IoT Fundamentals

![IoT Edge Fundamentals](https://docs.microsoft.com/en-us/azure/iot-edge/media/quickstart/install-edge-full.png?view=iotedge-2018-06)

### Azure IoT Edge Runtime
Edge Security Daemon
- Provides and maintains security standards on IoT Edge Device

IoT Edge Agent
- Instantiates and maintains modules
- Updates modules
- Ensures modules are always running
- Reports module health status to IoT Hub

IoT Edge Hub
- Local proxy for IoT Hub
- Enables edge module communication
- Enables Azure IoT Hub communication

### Pre-requisites
You will need the following applications, packages and resources.

1. [Git](https://git-scm.com/downloads)
2. [vscode](https://code.visualstudio.com/download)
3. [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
4. Azure IoT extension
After installing Azure CLI, open a Bash terminal and run the following command.
```
az extension add --name azure-iot
```
5. [Azure Subscription](https://azure.microsoft.com/en-us/free/)

## Azure Infrastructure Setup
The [Microsoft Azure Quickstart Guide](https://docs.microsoft.com/en-us/azure/iot-edge/quickstart?view=iotedge-2018-06) is a great step by step guide to get started. This repo contains scripts that will setup all of the Azure infrastructure necessary and execute all of the commands found in the Microsoft Azure Quickstart Guide. 

After cloning this repo locally, grant execute access to the scripts directory.
```
chmod +x ./scripts/*
```

### 1. Azure IoT Hub
Run scripts/infra-setup.sh tp create the Azure infrastructure necessary for Azure IoT.
```
./scripts/infra-setup.sh
```

### 2. Azure IoT Virtual Device
Create an Azure Linux VM (Ubuntu Server 18.04 LTS) to use as a virtual Azure IoT Edge device. We will deploy our Azure IoT Edge modules to this device.

Log into Azure Portal and create an Ubuntu 18.04 LTS Server VM
- D2s V3 SKU
- Enable SSH port
- Set Administrator account authentication to SSH Public Key
- [Step by step guide](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/quick-create-portal)

## Azure IoT Edge Device Setup
After the Azure IoT infrastructure is created and configured in your Azure subscription and you have created an Azure Ubuntu Server 18.04 LTS Linux VM, you will need to configure the Azure IoT Edge runtime on the Linux VM to use it as your simulated virtual edge device.

### 1. SSH into the Azure Ubuntu VM 
- Download the iot-edge-linux-install.sh onto your Ubuntu VM
```
curl https://raw.githubusercontent.com/aaron-schnieder/azure-iot-infra-edge-setup/main/scripts/infra-setup.sh > ./iot-edge-linux-install.sh
sudo chmod +x iot-edge-linux-install.sh
```
- Run iot-edge-linux-install.sh
```
sudo ./iot-edge-linux-install.sh
```

## 2. Configure Azure IoT Edge Runtime Settings
Follow the device provisioning instructions [from this guide](https://docs.microsoft.com/en-us/azure/iot-edge/how-to-provision-single-device-linux-symmetric?view=iotedge-2018-06&tabs=azure-cli#provision-the-device-with-its-cloud-identity)

(Summary of the steps to complete from the guide above)
- Populate the device connection string in config.yaml
- Restart the iotedge service
- Check the status of the iotedge service to ensure the connection is successful

## Helpful Bash Azure IoT Edge Runtime Commands

```
# Start the IoT Edge Runtime (Ubuntu Server)
sudo systemctl start iotedge

# Start the IoT Edge Runtime (Windows WSL)
sudo service iotedge start

# Restart the IoT Edge Runtime (Ubuntu Server)
sudo systemctl restart iotedge

# (Windows WSL)
sudo /etc/init.d/iotedge restart

# View all running services
service --status-all

# Verify iotedge service is running (Ubuntu Server)
sudo systemctl status iotedge

# Verify iotedge service is running (Windows WSL)
sudo service iotedge status

# Verify the configuration and connection status of the IoT Edge Runtime device
sudo iotedge check

# View service logs for troubleshooting
journalctl -u iotedge

# View all modules running on IoT Edge device
sudo iotedge list
```
