#!/bin/bash
set -e

echo "🛰️ Bootstrapping Sovereign Yggdrasil Mesh..."
yggdrasil -useconffile /opt/app/Mesh/yggdrasil.conf &

sleep 5

echo "🛰️ Sovereign Mesh Online. Launching zkSNARK Proof Node..."
bash run_zk_trust_proof.sh
