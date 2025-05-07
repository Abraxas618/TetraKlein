#!/bin/bash
set -e

# Configuration
CIRCUIT_NAME="zk_trust"
INPUT_JSON="input.json"
RTH_OUTPUT="rth_output.bin"
WITNESS_WTN="witness.wtns"
POT_0000="pot12_0000.ptau"
POT_FINAL="pot12_final.ptau"
POT_FINAL_PREP="pot12_final_prepared.ptau"
ZKEY_INITIAL="${CIRCUIT_NAME}_0000.zkey"
ZKEY_FINAL="${CIRCUIT_NAME}_final.zkey"
PROOF_JSON="proof.json"
PUBLIC_JSON="public.json"
VERIFICATION_KEY_JSON="verification_key.json"
LEDGER_CHAIN="ledger_chain.json"

echo "🛰️ [0/10] Preprocessing entropy with Recursive Tesseract Hashing (RTH)..."

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

echo "🛰️ [1/10] Compile circuit"
circom ZK/zk_trust.circom --r1cs --wasm --sym -l ZK/circomlib/circuits

echo "🛰️ [2/10] Initialize Powers of Tau ceremony"
snarkjs powersoftau new bn128 12 ${POT_0000} -v

echo "🛰️ [3/10] Contribute to Powers of Tau (Secure Entropy)"
snarkjs powersoftau contribute ${POT_0000} ${POT_FINAL} --name="RTH Genesis Contributor" --entropy="$(head -c 32 /dev/urandom | base64)"

echo "🛰️ [4/10] Prepare Powers of Tau for Phase 2 (Groth16)"
snarkjs powersoftau prepare phase2 ${POT_FINAL} ${POT_FINAL_PREP}

echo "🛰️ [5/10] Generate initial zKey"
snarkjs groth16 setup ${CIRCUIT_NAME}.r1cs ${POT_FINAL_PREP} ${ZKEY_INITIAL}

echo "🛰️ [6/10] Finalize zKey with Secure Entropy"
snarkjs zkey contribute ${ZKEY_INITIAL} ${ZKEY_FINAL} --name="TetraSwarm Node" --entropy="$(head -c 32 /dev/urandom | base64)"

echo "🛰️ [7/10] Export verification key"
snarkjs zkey export verificationkey ${ZKEY_FINAL} ${VERIFICATION_KEY_JSON}

echo "🛰️ [8/10] Generate witness with RTH-hashed entropy"
node ${CIRCUIT_NAME}_js/generate_witness.js ${CIRCUIT_NAME}_js/${CIRCUIT_NAME}.wasm ${INPUT_JSON} ${WITNESS_WTN}

echo "🛰️ [9/10] Generate zkSNARK proof"
snarkjs groth16 prove ${ZKEY_FINAL} ${WITNESS_WTN} ${PROOF_JSON} ${PUBLIC_JSON}

echo "🛰️ [10/10] Verify proof"
snarkjs groth16 verify ${VERIFICATION_KEY_JSON} ${PUBLIC_JSON} ${PROOF_JSON}

echo "📜 Embedding zkProof into sovereign ledger..."
python3 -c "
import json
from Core.ledger import Ledger
with open('${PUBLIC_JSON}', 'r') as f:
    public = json.load(f)
proof_hash = public[0]
ledger = Ledger(node_id='ZKQIDL')
ledger.add_block(state_hash=proof_hash)
ledger.save_chain('${LEDGER_CHAIN}')
"

echo "✅ ZK-Proof cycle complete — hash logged to: ${LEDGER_CHAIN}"
