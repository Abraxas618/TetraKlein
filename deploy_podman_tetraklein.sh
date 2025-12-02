#!/bin/bash
set -e

CONTAINER_NAME="tetraklein_node"
IMAGE_NAME="tetraklein-genesis"
VOLUME_NAME="tetraklein_data"

echo "🛰️ Checking Podman binary..."
if ! command -v podman >/dev/null 2>&1; then
    echo "❌ Podman not installed. Exiting."
    exit 1
fi

echo "🛰️ Ensuring sovereign data volume exists..."
podman volume exists ${VOLUME_NAME} || podman volume create ${VOLUME_NAME}

echo "🛰️ Removing old container (if exists)..."
if podman ps -a --format "{{.Names}}" | grep -q "^${CONTAINER_NAME}$"; then
    podman stop ${CONTAINER_NAME} || true
    podman rm ${CONTAINER_NAME} || true
fi

echo "🛰️ Building sovereign TetraKlein image..."
podman build -t ${IMAGE_NAME} .

echo "🛰️ Launching Sovereign TetraKlein Node..."
# Attempt TUN-enabled launch, fall back silently if unsupported
if [ -c /dev/net/tun ]; then
    echo "🛰️ TUN device detected — enabling full mesh mode."
    podman run -d \
        --name ${CONTAINER_NAME} \
        --volume ${VOLUME_NAME}:/data \
        --device /dev/net/tun \
        --cap-add NET_ADMIN \
        --network bridge \
        --restart always \
        ${IMAGE_NAME}
else
    echo "⚠️ TUN device missing — launching in simulation mode (mesh disabled)."
    podman run -d \
        --name ${CONTAINER_NAME} \
        --volume ${VOLUME_NAME}:/data \
        --network bridge \
        --restart always \
        ${IMAGE_NAME}
fi

echo "✅ Deployment Complete — TetraKlein Genesis Node is Online."
echo "📁 Ledger stored in Podman volume: ${VOLUME_NAME}"
