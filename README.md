# Container Bastion and Usage

A container-based bastion for working with resources in a protected VNET in Azure.

NOTE: This project highly leverages work done by my teammate Chris Romp in [this repo](https://github.com/ChrisRomp/vscodetunnel).

## Test Locally

```bash

docker run --name mytunnel \
  -e VSCODE_TUNNEL_AUTH=microsoft \
  -e VSCODE_TUNNEL_NAME=local-test-tunnel \
  -e VSCODE_EXTENSIONS=humao.rest-client,GitHub.copilot-chat \
  cwiederspan/my-container-bastion:latest

```

## Azure Usage

Use the Azure CLI to run the bation in an Azure Container Instance (ACI) within a designated existing VNET.

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
VSCODE_TUNNEL_NAME=$CONTAINER_NAME # reuse container name or change
VSCODE_TUNNEL_AUTH=microsoft
VSCODE_EXTENSIONS=humao.rest-client,GitHub.copilot-chat
GIT_REPO_URL=https://github.com/cwiederspan/cdw-speechtesting-20240403.git
GIT_REPO_MOUNT_PATH=/workspaces

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
    VSCODE_TUNNEL_NAME=$VSCODE_TUNNEL_NAME \
    VSCODE_TUNNEL_AUTH=$VSCODE_TUNNEL_AUTH \
    VSCODE_EXTENSIONS=$VSCODE_EXTENSIONS

# Get logs to see login code and/or URL
az container logs -g $RG --name $CONTAINER_NAME --follow

# Cleanup - delete the container instance
az container delete -g $RG --name $CONTAINER_NAME --yes

```