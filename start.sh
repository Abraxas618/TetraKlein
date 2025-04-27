#!/bin/bash
set -e

# 🧠 Step 1: Run Sovereign zkProof Cycle
bash run_zk_trust_proof.sh

# 🛰️ Step 2: After successful proof, bring up Sovereign Mesh
echo "🛰️ Bootstrapping Sovereign Yggdrasil Mesh..."
yggdrasil -useconffile /etc/yggdrasil/yggdrasil.conf &
sleep 5

# (Optional: Add mesh diagnostics later here if needed)
