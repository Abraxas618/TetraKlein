#!/bin/bash
set -e

# 🧠 Step 1: Sovereign zkProof Setup
bash run_zk_trust_proof.sh

# 🛰️ Step 2: Sovereign Mesh Bootstrap
echo "🛰️ Bootstrapping Sovereign Yggdrasil Mesh..."
yggdrasil -useconffile /etc/yggdrasil/yggdrasil.conf &
sleep 5

# 🚀 Step 3: Sovereign Genesis Node Launch
echo "🚀 Launching TetraKlein Genesis Sovereign Pipeline..."
python3 -m Core.main
