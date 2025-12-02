#!/bin/bash
set -e

# Always operate from script directory
cd "$(dirname "$0")"

CIRCUIT="zk_trust"
PTAU="powersOfTau28_hez_final_12.ptau"
CIRCUIT_PATH="./${CIRCUIT}.circom"
CIRCUIT_DIR="./${CIRCUIT}_js"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🛰️ TetraKlein zkSNARK Pipeline — Start"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"


# 1️⃣  Compile circuit
echo "🔧 [1/7] Compiling circuit..."
if [ ! -f "$CIRCUIT_PATH" ]; then
    echo "❌ Missing circuit file: $CIRCUIT_PATH"
    exit 1
fi

circom "$CIRCUIT_PATH" \
    --r1cs \
    --wasm \
    --sym \
    -l ./circomlib/circuits

echo "✅ Circuit compiled."


# 2️⃣  Verify PTAU file
echo "🔐 [2/7] Checking PTAU file..."
if [ ! -f "$PTAU" ]; then
    echo "❌ Missing $PTAU."
    echo "Please download it using:"
    echo "wget https://hermez.s3-eu-west-1.amazonaws.com/${PTAU}"
    exit 1
fi

echo "✅ PTAU available."


# 3️⃣  Trusted Setup (Groth16)
echo "🔐 [3/7] Running trusted setup..."
snarkjs groth16 setup "${CIRCUIT}.r1cs" "$PTAU" "${CIRCUIT}.zkey"

echo "✅ Trusted setup complete."


# 4️⃣  Export Verification Key
echo "🔑 [4/7] Exporting verification key..."
snarkjs zkey export verificationkey \
    "${CIRCUIT}.zkey" \
    verification_key.json

echo "✅ Verification key saved."


# 5️⃣  Ensure input.json exists
if [ ! -f "input.json" ]; then
    echo "⚠️ input.json missing — creating default test vector..."
    echo '{"user_entropy": 123456789, "time_salt": 987654321}' > input.json
fi

echo "📥 Input ready."


# 6️⃣  Generate witness
echo "🧠 [5/7] Generating witness..."
if [ ! -d "$CIRCUIT_DIR" ]; then
    echo "❌ Missing circuit wasm directory: $CIRCUIT_DIR"
    exit 1
fi

node "${CIRCUIT_DIR}/generate_witness.js" \
     "${CIRCUIT_DIR}/${CIRCUIT}.wasm" \
     input.json \
     witness.wtns

echo "✅ Witness generated."


# 7️⃣  Generate zkSNARK proof
echo "📜 [6/7] Creating proof..."
snarkjs groth16 prove \
    "${CIRCUIT}.zkey" \
    witness.wtns \
    proof.json \
    public.json

echo "✅ Proof created."


# 8️⃣  Verify zkSNARK proof
echo "🛰️ [7/7] Verifying proof..."
snarkjs groth16 verify \
    verification_key.json \
    public.json \
    proof.json

echo "🎉 zkSNARK verification SUCCESSFUL!"
echo "🚀 TetraCodex pipeline complete."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
