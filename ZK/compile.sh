#!/bin/bash
set -e

# Navigate to script directory
cd "$(dirname "$0")"

CIRCUIT=zk_trust
PTAU=powersOfTau28_hez_final_12.ptau

# 🔧 Step 1: Compile circuit
echo "🔧 Compiling circuit..."
circom $CIRCUIT.circom --r1cs --wasm --sym -l ./circomlib/circuits

# 🔐 Step 2: Trusted setup
if [ ! -f "$PTAU" ]; then
  echo "⚠️ Missing $PTAU file. Please provide a valid ptau file."
  exit 1
fi

echo "🔐 Running trusted setup..."
snarkjs groth16 setup $CIRCUIT.r1cs $PTAU $CIRCUIT.zkey

# 🔑 Step 3: Export verification key
echo "🔑 Exporting verification key..."
snarkjs zkey export verificationkey $CIRCUIT.zkey verification_key.json

# 📥 Step 4: Ensure input.json exists
if [ ! -f "input.json" ]; then
  echo "⚠️ input.json not found. Creating default test input..."
  echo '{ "user_entropy": 123456789, "time_salt": 987654321 }' > input.json
fi

# 🧠 Step 5: Generate witness
echo "🧠 Generating witness..."
node ${CIRCUIT}_js/generate_witness.js ${CIRCUIT}_js/${CIRCUIT}.wasm input.json witness.wtns

# 📜 Step 6: Generate proof
echo "📜 Creating proof..."
snarkjs groth16 prove $CIRCUIT.zkey witness.wtns proof.json public.json

# ✅ Step 7: Verify proof
echo "✅ Verifying proof..."
snarkjs groth16 verify verification_key.json public.json proof.json

echo "🚀 TetraCodex pipeline complete."
