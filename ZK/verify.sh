#!/usr/bin/env bash
set -e

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🛰️ TetraKlein zkSNARK Verification Pipeline"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Always run from script directory
cd "$(dirname "$0")"

CIRCUIT="zk_trust"
CIRCUIT_WASM="./${CIRCUIT}_js/${CIRCUIT}.wasm"
WITNESS="./witness.wtns"
INPUT="./input.json"
ZKEY="./${CIRCUIT}.zkey"
VK="./verification_key.json"
PROOF="./proof.json"
PUBLIC="./public.json"

# 1️⃣ Verify file existence
echo "🔍 Checking required files..."

missing=()

[[ -f "$CIRCUIT_WASM" ]] || missing+=("$CIRCUIT_WASM")
[[ -f "$INPUT" ]]         || missing+=("$INPUT")
[[ -f "$ZKEY" ]]          || missing+=("$ZKEY")
[[ -f "$VK" ]]            || missing+=("$VK")

if [[ ${#missing[@]} -gt 0 ]]; then
    echo "❌ Missing required files:"
    for f in "${missing[@]}"; do echo "   • $f"; done
    exit 1
fi

echo "✅ All required files found."


# 2️⃣ Generate witness
echo "🧠 [1/3] Generating witness..."
node "${CIRCUIT}_js/generate_witness.js" \
     "$CIRCUIT_WASM" \
     "$INPUT" \
     "$WITNESS"

echo "✅ Witness generated: $WITNESS"


# 3️⃣ Generate zkSNARK proof
echo "📜 [2/3] Generating zkSNARK proof..."
snarkjs groth16 prove \
    "$ZKEY" \
    "$WITNESS" \
    "$PROOF" \
    "$PUBLIC"

echo "✅ Proof created: $PROOF"


# 4️⃣ Verify zkSNARK proof
echo "🔐 [3/3] Verifying proof integrity..."
snarkjs groth16 verify \
    "$VK" \
    "$PUBLIC" \
    "$PROOF"

echo "🎉 [✔ VERIFIED] zkSNARK proof successfully validated!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
