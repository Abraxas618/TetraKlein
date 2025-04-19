#!/bin/bash
set -e

CONTAINER_NAME="tetraklein_node"
IMAGE_NAME="tetraklein-genesis"
VOLUME_NAME="tetraklein_data"

echo "🛰️ Checking Podman..."
command -v podman >/dev/null 2>&1 || { echo >&2 "Podman not installed. Aborting."; exit 1; }

echo "🛰️ Creating Sovereign Volume..."
podman volume create ${VOLUME_NAME}

echo "🛰️ Building Sovereign Image with Integrated Mesh..."
podman build -t ${IMAGE_NAME} .

echo "🛰️ Launching Sovereign Mesh Node..."
podman run -d \
  --name ${CONTAINER_NAME} \
  --volume ${VOLUME_NAME}:/opt/ledger \
  --network bridge \
  --restart always \
  -p 127.0.0.1:8080:8080 \
  ${IMAGE_NAME}

echo "✅ Deployment Complete — Sovereign Node Online."
