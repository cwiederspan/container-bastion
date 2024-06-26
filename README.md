# Container Bastion and Usage

A container-based bastion for working with resources in a protected VNET in Azure.

> NOTE: This project highly leverages work done by my teammate Chris Romp in [this repo](https://github.com/ChrisRomp/vscodetunnel).

## Test Locally

```bash

docker build -t cwiederspan/my-container-bastion:latest .

docker run --detach \
    --volume .:/workspace \
    --workdir /workspace \
    --name mytunnel \
    -e TUNNEL_NAME=cdwtesting20240510 \
    cwiederspan/my-container-bastion:latest

docker logs -n 50 mytunnel

```

## Azure Usage

Use the Azure CLI to run the bastion in an Azure Container Instance (ACI) within a designated existing VNET.

```bash

# Ensure you are logged in with:
# az login

# Setup some environment variables
RG=my-resource-group # Existing resource group
LOCATION=westus3
IMAGE=cwiederspan/my-container-bastion:latest
CONTAINER_NAME=acr-tunnel1
VNET=vnet-name # optional - for VNet integration
SUBNET=subnet-name # optional/required with VNet - will be delegated to ACI
TUNNEL_NAME=$CONTAINER_NAME # reuse container name or change
GIT_REPO_URL=https://github.com/cwiederspan/cdw-speechtesting-20240403.git
GIT_REPO_MOUNT_PATH=/workspace

# Create the container instance
az container create \
  -g $RG \
  -l $LOCATION \
  --name $CONTAINER_NAME \
  --image $IMAGE \
  --vnet $VNET \
  --subnet $SUBNET \
  --gitrepo-url $GIT_REPO_URL \
  --gitrepo-mount-path $GIT_REPO_MOUNT_PATH \
  --environment-variables \
    TUNNEL_NAME=$TUNNEL_NAME

# Get logs to see login code and/or URL
az container logs -g $RG --name $CONTAINER_NAME --follow

# Cleanup - delete the container instance
az container delete -g $RG --name $CONTAINER_NAME --yes

```
