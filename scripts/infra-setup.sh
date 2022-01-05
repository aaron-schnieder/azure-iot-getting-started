## -------
# Bash script to setup getting started Azure IoT infrastructure

#! /bin/bash

set -e # stop script execution on failure
set -x

# Write stdout and stderr to a log.txt file with this script name
SCRIPT_LOG_FILE="${0##*/}.log.txt"
exec > >(tee $SCRIPT_LOG_FILE)
exec 2>&1

## -------
# Shell script variables
AZURE_SUBSCRIPTION_ID=''  # DO NOT COMMIT VALUE!!!!
AZURE_REGION='westus2'
AZURE_RESOURCE_GROUP='aaros-iot-getting-started'
AZURE_CONTAINER_REGISTRY='aarosIoTGettingStartedACR'
AZURE_IOT_HUB='aarosIoTHubGettingStarted'
VIRTUAL_EDGE_DEVICE='aarosVirtualEdgeDevice'

## -------
# Login to Azure if needed and set the Azure subscription for this script to use
AZ_LOGGED_IN=$(az account list --query '[0].name' -o tsv)
echo "$AZ_LOGGED_IN"
if [ -z $AZ_LOGGED_IN ]; then
    az login
fi
az account set \
    --subscription $AZURE_SUBSCRIPTION_ID

## -------
# Check if the specified resource group already exists
RG_EXISTS=$(az group list --query "[?contains(name, '$AZURE_RESOURCE_GROUP')].name" -o tsv)
CREATE_RG="false"

# If the Resource Group exists, prompt whether or not to delete it before creating new infrastructure
if [ ! -z $RG_EXISTS ]
then
    echo $'\n'
    read -p "Do you want to remove the Azure Resource Group and all resources (if it exists) before creating new infrastructure?" -n 1 -r

    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        echo "\nDeleting Azure Resource Group..... Please wait...."
        az group delete \
            --name $AZURE_RESOURCE_GROUP --yes
        CREATE_RG="true"
    fi
else
    CREATE_RG="true"
fi

if [ $CREATE_RG == "true" ]
then
    echo "Creating Azure Resource Group"
    az group create \
        --name $AZURE_RESOURCE_GROUP \
        --location $AZURE_REGION
fi

## -------
# Create Azure Container Registry to use for module images
az acr create \
    --resource-group $AZURE_RESOURCE_GROUP \
    --name $AZURE_CONTAINER_REGISTRY \
    --sku Basic

## -------
# Create the Azure IoT Hub
az iot hub create \
    --resource-group $AZURE_RESOURCE_GROUP \
    --name $AZURE_IOT_HUB \
    --sku S1 \
    --partition-count 2

# Wait for 20 seconds to allow the hub to instantiate before adding the device
sleep 20

## -------
# Create a device identity for the getting started virtual machine device
az iot hub device-identity create \
    --device-id $VIRTUAL_EDGE_DEVICE \
    --hub-name $AZURE_IOT_HUB --edge-enabled

# Get the device connection string
VIRTUAL_EDGE_DEVICE_CONNECTION_STRING=$(az iot hub device-identity connection-string show --device-id $VIRTUAL_EDGE_DEVICE --hub-name $AZURE_IOT_HUB)

echo "Save the virtual device connection string to use in the IoT Edge runtime setup..."
echo $VIRTUAL_EDGE_DEVICE_CONNECTION_STRING
