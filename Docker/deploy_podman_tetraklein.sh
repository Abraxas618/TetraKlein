#!/bin/bash
set -e

# Configuration
CONTAINER_NAME="tetraklein_node"
IMAGE_NAME="tetraklein-genesis"
VOLUME_NAME="tetraklein_data"

echo "🛰️ [1/7] Checking Podman installation..."
if ! command -v podman &> /dev/null
then
    echo "Podman could not be found. Install Podman first!"
    exit 1
fi

echo "🛰️ [2/7] Creating Sovereign Volume for Ledger Persistence..."
podman volume create ${VOLUME_NAME}

echo "🛰️ [3/7] Building Sovereign Node Image..."
podman build -t ${IMAGE_NAME} .

echo "🛰️ [4/7] Cleaning Up Old Containers (if exist)..."
podman rm -f ${CONTAINER_NAME} || true

echo "🛰️ [5/7] Launching Sovereign Node Container..."
podman run -d \
  --name ${CONTAINER_NAME} \
  --volume ${VOLUME_NAME}:/opt/ledger \
  --network bridge \
  --restart always \
  -p 127.0.0.1:8080:8080 \
  ${IMAGE_NAME}

echo "🛰️ [6/7] Confirming Node Startup..."
podman ps | grep ${CONTAINER_NAME}

echo "✅ [7/7] Sovereign Node Deployment Complete!"
echo "Access container logs with: podman logs ${CONTAINER_NAME}"
