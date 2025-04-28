#!/bin/bash
set -e

# Configuration
CIRCUIT_NAME="zk_trust"
INPUT_JSON="input.json"
RTH_OUTPUT="rth_output.bin"
WITNESS_WTN="witness.wtns"
POT_0000="pot12_0000.ptau"
POT_FINAL="pot12_final.ptau"
ZKEY_INITIAL="${CIRCUIT_NAME}_0000.zkey"
ZKEY_FINAL="${CIRCUIT_NAME}_final.zkey"
PROOF_JSON="proof.json"
PUBLIC_JSON="public.json"
VERIFICATION_KEY_JSON="verification_key.json"

echo "🛰️ [0/9] Preprocessing entropy with Recursive Tesseract Hashing (RTH)..."

python3 -c "
import sys
sys.path.append('/opt/app')
from Core.rth import RecursiveTesseractHasher

rth = RecursiveTesseractHasher()
with open('${INPUT_JSON}', 'rb') as f:
    seed = f.read()
hashed = rth.recursive_tesseract_hash(seed)
with open('${RTH_OUTPUT}', 'wb') as out:
    out.write(hashed)
"

echo "✅ RTH Digest created: ${RTH_OUTPUT}"

echo "🛰️ [1/9] Compile circuit"
circom ZK/zk_trust.circom --r1cs --wasm --sym -l ZK/circomlib/circuits


echo "🛰️ [2/9] Initialize Powers of Tau ceremony"
snarkjs powersoftau new bn128 12 ${POT_0000} -v

echo "🛰️ [3/9] Contribute to Powers of Tau (Trusted Setup)"
snarkjs powersoftau contribute ${POT_0000} ${POT_FINAL}

echo "🛰️ [NEW] Prepare Powers of Tau for Phase 2 (required for Groth16)"
snarkjs powersoftau prepare phase2 ${POT_FINAL} pot12_final_prepared.ptau

echo "🛰️ [4/9] Generate zKey for the circuit"
snarkjs groth16 setup ${CIRCUIT_NAME}.r1cs pot12_final_prepared.ptau ${ZKEY_INITIAL}


echo "🛰️ [5/9] Finalize zKey"
snarkjs zkey contribute ${ZKEY_INITIAL} ${ZKEY_FINAL}


echo "🛰️ [6/9] Export verification key"
snarkjs zkey export verificationkey ${ZKEY_FINAL} ${VERIFICATION_KEY_JSON}

echo "🛰️ [7/9] Generate witness with RTH compressed entropy"
node ${CIRCUIT_NAME}_js/generate_witness.js ${CIRCUIT_NAME}_js/${CIRCUIT_NAME}.wasm ${INPUT_JSON} ${WITNESS_WTN}


echo "🛰️ [8/9] Generate proof"
snarkjs groth16 prove ${ZKEY_FINAL} ${WITNESS_WTN} ${PROOF_JSON} ${PUBLIC_JSON}

echo "🛰️ [9/9] Verify proof"
snarkjs groth16 verify ${VERIFICATION_KEY_JSON} ${PUBLIC_JSON} ${PROOF_JSON}

echo "✅ Sovereign ZK-Proof Cycle Complete — Hyperdimensional Genesis Confirmed!"
