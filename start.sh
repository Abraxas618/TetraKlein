#!/bin/bash
set -e

echo "🛠️ [0/4] Initializing TetraKlein Sovereign Node Startup..."

CHAIN_FILE="/data/ledger_chain.json"
APP_DIR="/opt/app"

# Ensure data directory exists
mkdir -p /data

# [1/4] Sovereign Hyperchain Bootstrap
echo "🔗 [1/4] Loading Sovereign Hypercube Blockchain..."
python3 - <<EOF
import os
from Core.hbb_blockchain import HypercubeBlockchain

chain_path = "${CHAIN_FILE}"
blockchain = HypercubeBlockchain(sovereign_seeds=["TETRA-GENESIS-001"])

if os.path.exists(chain_path):
    print("📂 Found existing hyperchain. Loading...")
    blockchain.load_from_file(chain_path)
else:
    print("🧬 No prior chain found. Creating sovereign genesis roots...")
    blockchain.create_genesis_blocks()
    blockchain.save_to_file(chain_path)

if blockchain.is_valid():
    print("✅ Hyperchain integrity verified.")
else:
    print("❌ Hyperchain validation failed.")
EOF

# [2/4] Sovereign zkSNARK Proof Generation
echo "🧠 [2/4] Starting zkSNARK trust system..."
bash run_zk_trust_proof.sh

# [3/4] Sovereign Mesh Bootstrap
echo "🛰️ [3/4] Bootstrapping Sovereign Yggdrasil Mesh..."
if [ -c /dev/net/tun ]; then
    yggdrasil -useconffile /etc/yggdrasil/yggdrasil.conf &
    sleep 5
    echo "✅ Yggdrasil mesh running with TUN interface."
else
    echo "⚠️ TUN device not found. Mesh networking will be simulated."
    echo "Simulated Mesh Node IPv6: 200:1f15:7e0e:b395:b16d:fb97:3801:d5b8"
fi

# [4/4] Sovereign Core Genesis App
NODE_ID=${NODE_ID:-TetraGenesis-Node01}
echo "🚀 [4/4] Launching TetraKlein Sovereign Node as ${NODE_ID}..."
python3 -m Core.main
