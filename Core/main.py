"""
TetraKlein Genesis Node Launcher
Assembles Sovereign Hyperdimensional Genesis Cycle
"""

import time
import os
import socket
from Core.tke import TetrahedralKeyExchange
from Core.rth import RecursiveTesseractHasher
from Core.qidl_encrypt import QuantumLatticeEncryptor
from Core.hbb_blockchain import HypercubeBlockchain
from Core.ledger import Ledger
from Core.mesh_sync import MeshNode
from Core.zk_beacon import zkBeaconNode
from Core.consensus_pbft import PBFTNode


def get_yggdrasil_ipv6():
    """
    Returns the first non-loopback IPv6 address associated with Yggdrasil interface.
    """
    try:
        ipv6_addrs = socket.getaddrinfo(socket.gethostname(), None, socket.AF_INET6)
        for addr in ipv6_addrs:
            ip = addr[4][0]
            if not ip.startswith("::1") and not ip.startswith("fe80"):
                return ip
    except Exception as e:
        print(f"[⚠️] IPv6 autodetection failed: {e}")
    return "::1"  # fallback


def main():
    print("\n🚀 Launching TetraKlein Genesis Sovereign Pipeline...\n")

    # === Config ===
    node_id = os.getenv("NODE_ID", "TetraGenesis-Node01")

    # === Step 1: Sovereign Key Generation (TKE) ===
    tke = TetrahedralKeyExchange()
    A = tke.generate_public_matrix()
    sk = tke.generate_private_key()
    public_key = tke.generate_public_key(A, sk)
    print(f"[🔐] TKE Public Key (12D vector):\n{public_key}\n")

    # === Step 2: Sovereign Entropy Folding (RTH) ===
    rth = RecursiveTesseractHasher()
    entropy = rth.recursive_tesseract_hash(public_key.tobytes())
    entropy_hex = entropy.hex()
    print(f"[🌐] Recursive Tesseract Entropy Digest (SHAKE256): {entropy_hex[:64]}...\n")

    # === Step 3: Sovereign Quantum Encryption (QIDL) ===
    qidl = QuantumLatticeEncryptor()
    encrypted_data, salt = qidl.encrypt("Welcome to TetraKlein Genesis!")
    print(f"[🧬] QIDL Encrypted Lattice (preview): {encrypted_data[:2]}\n")

    # === Step 4: Sovereign Ledger Initialization ===
    ledger = Ledger(chain_file="data/ledger_chain.json", node_id=node_id)
    genesis_time = int(time.time())
    ledger.add_block(
        state_hash=entropy_hex,
        zk_origin=True,
        timestamp=genesis_time
    )
    print(f"[📜] Sovereign Ledger Genesis Block at UNIX time: {genesis_time}\n")
    ledger.save_chain()

    # === Step 5: Sovereign Hypercube Blockchain (HBB 2.0) ===
    hbb = HypercubeBlockchain()
    genesis_block = hbb.add_block(
        data=f"TetraKlein Genesis Event | Entropy Digest: {entropy_hex[:64]}"
    )
    print(f"[🔗] HBB Genesis Block Hash: {genesis_block.hash}\n")

    # === Step 6: Integrity Verification ===
    if ledger.verify_chain() and hbb.is_valid():
        print("\n✅ Sovereign Genesis Chain Integrity Verified.\n")
    else:
        print("\n❌ Chain Verification Failed — Check Ledger/Blockchain Logs.\n")

    # === Step 7: Start Sovereign Mesh Sync Listener ===
    mesh = MeshNode(node_id)
    mesh.start_listener()

    # === Step 8: Start zkBeacon Proof Receiver ===
    zk_node = zkBeaconNode(node_id)
    zk_node.start_listener()

    # === Step 9: Start PBFT Consensus Node ===
    pbft_node = PBFTNode(node_id=node_id, peers=[])
    pbft_node.start_listener()

    # === Step 10: Dynamic IPv6 Broadcast ===
    detected_ipv6 = get_yggdrasil_ipv6()
    print(f"[🌐] Detected local Yggdrasil IPv6: {detected_ipv6}\n")

    peer_env = os.getenv("PEERS", "")
    peers = [ip.strip() for ip in peer_env.split(",") if ip.strip()]

    if not peers:
        print("[ℹ️] No mesh peers defined via $PEERS — operating as isolated node.\n")

    for peer in peers:
        mesh.broadcast_ledger(peer)
        zk_node.broadcast_proof(peer)
        pbft_node.peers.append(peer)

    # === Step 11: Optional Self-Proposal into Consensus (only for zk-Proven entropy) ===
    pbft_node.propose_block(
        state_hash=entropy_hex,
        proof_path="proof.json",
        public_path="public.json"
    )

    print("🛰️ TetraKlein Genesis Node Initialization Complete.\n")


if __name__ == "__main__":
    main()
