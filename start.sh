#!/bin/bash
set -e

echo "[0/4] Initializing TetraKlein Research Node..."

CHAIN_FILE="/data/ledger_chain.json"
APP_DIR="/opt/app"

# Ensure data directory exists
mkdir -p /data

# ------------------------------------------------------------
# [1/4] Hypercube Ledger Bootstrap
# ------------------------------------------------------------
echo "[1/4] Loading Hypercube Ledger..."
python3 - <<EOF
import os
from Core.hbb_blockchain import HypercubeBlockchain

chain_path = "${CHAIN_FILE}"
blockchain = HypercubeBlockchain(seeds=["TETRA-GENESIS-001"])

if os.path.exists(chain_path):
    print("Existing chain detected. Loading...")
    blockchain.load_from_file(chain_path)
else:
    print("No existing chain found. Creating genesis blocks...")
    blockchain.create_genesis_blocks()
    blockchain.save_to_file(chain_path)

if blockchain.is_valid():
    print("Ledger integrity verified.")
else:
    print("Ledger validation failed.")
EOF

# ------------------------------------------------------------
# [2/4] Zero-Knowledge Proof Pipeline
# ------------------------------------------------------------
echo "[2/4] Executing zkSNARK trust pipeline..."
bash run_zk_trust_proof.sh

# ------------------------------------------------------------
# [3/4] Mesh Identity Bootstrap
# ------------------------------------------------------------
echo "[3/4] Initializing Mesh Identity Layer..."
if [ -c /dev/net/tun ]; then
    yggdrasil -useconffile /etc/yggdrasil/yggdrasil.conf &
    sleep 5
    echo "Mesh networking active (TUN interface detected)."
else
    echo "TUN device not available. Mesh networking will run in simulation mode."
    echo "Simulated Mesh Address: 200:1f15:7e0e:b395:b16d:fb97:3801:d5b8"
fi

# ------------------------------------------------------------
# [4/4] Launch Core Application
# ------------------------------------------------------------
NODE_ID=${NODE_ID:-TetraGenesis-Node01}
echo "[4/4] Launching TetraKlein Node as ${NODE_ID}..."
python3 -m Core.main
