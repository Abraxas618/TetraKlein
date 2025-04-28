"""
TetraKlein Genesis Node Launcher
Assembles Sovereign Hyperdimensional Genesis Cycle
"""

from Core.tke import TetrahedralKeyExchange
from Core.rth import RecursiveTesseractHasher
from Core.qidl_encrypt import QuantumLatticeEncryptor
from Core.hbb_blockchain import HypercubeBlockchain
from Core.ledger import Ledger
import time

def main():
    print("\n🚀 Launching TetraKlein Genesis Sovereign Pipeline...\n")
    
    # === Step 1: Sovereign Key Generation (TKE) ===
    tke = TetrahedralKeyExchange(seed=42)
    public_key = tke.generate_public_key()
    print(f"[+] TKE Public Key Generated: {public_key}\n")

    # === Step 2: Sovereign Entropy Folding (RTH) ===
    rth = RecursiveTesseractHasher()
    entropy = rth.recursive_tesseract_hash(public_key.tobytes())
    print(f"[+] Recursive Tesseract Hash (Entropy Digest): {entropy.hex()[:64]}...\n")

    # === Step 3: Sovereign Encryption (QIDL) ===
    qidl = QuantumLatticeEncryptor()
    encrypted_data, salt = qidl.encrypt("Welcome to TetraKlein Genesis!")
    print(f"[+] QIDL Encryption Output (First 2 Points): {encrypted_data[:2]}\n")

    # === Step 4: Sovereign Ledger Initialization ===
    ledger = Ledger(epoch_size=1000)
    genesis_time = time.time()

    ledger.add_block(
        node_id="TetraGenesis-Node01",
        state_hash=entropy,
        timestamp=genesis_time
    )
    print(f"[+] Sovereign Genesis Ledger Block Created at {genesis_time}\n")

    # === Step 5: Sovereign Blockchain Initialization (HBB 2.0) ===
    hbb = HypercubeBlockchain()
    genesis_block = hbb.add_block(
        data=f"TetraKlein Genesis Event | Entropy Digest: {entropy.hex()[:64]}"
    )
    print(f"[+] Hypercube Blockchain Genesis Block Hash: {genesis_block.hash}\n")

    # === Step 6: Integrity Verification ===
    if ledger.verify_chain() and hbb.is_valid():
        print("\n✅ Sovereign Genesis Chain Integrity Verified.\n")
    else:
        print("\n❌ Sovereign Genesis Chain Integrity Failed.\n")

    print("🛰️ TetraKlein Genesis Node Cycle Completed.\n")

if __name__ == "__main__":
    main()
