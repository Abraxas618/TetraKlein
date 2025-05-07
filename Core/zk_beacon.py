"""
TetraKlein zkBeacon Node Trust Broadcaster
Broadcasts zkSNARK proof to neighboring sovereign mesh nodes
"""

import json
import socket
import threading
import subprocess
from Core.ledger import Ledger

PORT = 9090
BUFFER_SIZE = 8192

class zkBeaconNode:
    def __init__(self, node_id: str, host: str = '::', port: int = PORT):
        self.node_id = node_id
        self.host = host
        self.port = port
        self.ledger = Ledger(epoch_size=1000)
        self.peers = set()

    def start_listener(self):
        def handle_beacon(conn, addr):
            data = conn.recv(BUFFER_SIZE).decode()
            try:
                beacon = json.loads(data)
                with open("proof.json", "w") as pf, open("public.json", "w") as pubf:
                    json.dump(beacon["proof"], pf)
                    json.dump(beacon["public"], pubf)
                verified = subprocess.run([
                    "snarkjs", "groth16", "verify",
                    "verification_key.json", "public.json", "proof.json"
                ], capture_output=True, text=True)

                if "OK" in verified.stdout:
                    print(f"[✅] Verified beacon from {beacon['node_id']}")
                    self.ledger.add_block(
                        node_id=beacon["node_id"],
                        state_hash=beacon["public"][0]
                    )
                else:
                    print(f"[❌] Invalid proof from {beacon['node_id']}")
            except Exception as e:
                print(f"[⚠️] zkBeacon error: {e}")
            conn.close()

        def listener_thread():
            with socket.socket(socket.AF_INET6, socket.SOCK_STREAM) as s:
                s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
                s.bind((self.host, self.port))
                s.listen()
                print(f"[🛰️] zkBeacon listening on [{self.host}]:{self.port}")
                while True:
                    conn, addr = s.accept()
                    threading.Thread(target=handle_beacon, args=(conn, addr)).start()

        threading.Thread(target=listener_thread, daemon=True).start()

    def broadcast_proof(self, peer_ip: str):
        try:
            with open("proof.json", "r") as pf, open("public.json", "r") as pubf:
                proof = json.load(pf)
                public = json.load(pubf)
            payload = {
                "node_id": self.node_id,
                "proof": proof,
                "public": public
            }
            with socket.socket(socket.AF_INET6, socket.SOCK_STREAM) as s:
                s.connect((peer_ip, self.port))
                s.sendall(json.dumps(payload).encode())
            print(f"[📡] Beacon sent to {peer_ip}")
        except Exception as e:
            print(f"[⚠️] Failed to send beacon: {e}")
