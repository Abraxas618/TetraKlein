"""
TetraKlein Mesh Sync Engine
Secure Inter-Node Ledger Broadcasting & Sovereign zkBeacon Handshakes
"""

import json
import socket
import threading
import os
import time
import base64
import nacl.signing
import nacl.encoding
from Core.ledger import Ledger

PORT = 8080
BUFFER_SIZE = 4096
PEERS_FILE = "peers.txt"
LEDGER_FILE = "ledger_chain.json"
PRIVKEY_FILE = "node_private.key"
PUBKEY_FILE = "node_public.key"

class MeshNode:
    def __init__(self, node_id: str, host: str = '::', port: int = PORT):
        self.node_id = node_id
        self.host = host
        self.port = port
        self.ledger = Ledger(epoch_size=1000)
        self.peers = self.load_peers()
        self.signing_key, self.verify_key = self.load_or_generate_keys()

    def load_or_generate_keys(self):
        """
        Loads or generates Ed25519 keypair for secure broadcast identity.
        """
        if os.path.exists(PRIVKEY_FILE):
            with open(PRIVKEY_FILE, 'rb') as f:
                signing_key = nacl.signing.SigningKey(f.read())
        else:
            signing_key = nacl.signing.SigningKey.generate()
            with open(PRIVKEY_FILE, 'wb') as f:
                f.write(signing_key.encode())
            with open(PUBKEY_FILE, 'wb') as f:
                f.write(signing_key.verify_key.encode())
        return signing_key, signing_key.verify_key

    def load_peers(self):
        """
        Load peers from file, one per line.
        """
        if not os.path.exists(PEERS_FILE):
            return set()
        with open(PEERS_FILE, 'r') as f:
            return set(line.strip() for line in f if line.strip())

    def start_listener(self):
        def handle_client(conn, addr):
            try:
                payload = conn.recv(BUFFER_SIZE).decode()
                packet = json.loads(payload)
                sender_key = base64.b64decode(packet['pubkey'])
                message = base64.b64decode(packet['message'])
                signature = base64.b64decode(packet['signature'])

                verify_key = nacl.signing.VerifyKey(sender_key)
                verify_key.verify(message, signature)

                remote_chain = json.loads(message.decode())
                accepted = self.ledger.import_chain(remote_chain)
                print(f"[🔐] Sync from {addr[0]} (verified) → accepted: {accepted}")
            except Exception as e:
                print(f"[❌] Sync rejected from {addr[0]}: {e}")
            conn.close()

        def listener_thread():
            with socket.socket(socket.AF_INET6, socket.SOCK_STREAM) as s:
                s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
                s.bind((self.host, self.port))
                s.listen()
                print(f"[🛰️] Mesh listener active on [{self.host}]:{self.port}")
                while True:
                    conn, addr = s.accept()
                    threading.Thread(target=handle_client, args=(conn, addr)).start()

        threading.Thread(target=listener_thread, daemon=True).start()

    def broadcast_ledger(self, peer_ip: str, peer_port: int = PORT):
        """
        Sends the current signed ledger chain to a specific peer.
        """
        try:
            chain_data = json.dumps(self.ledger.export_chain()).encode()
            signature = self.signing_key.sign(chain_data).signature

            packet = {
                'pubkey': base64.b64encode(self.verify_key.encode()).decode(),
                'message': base64.b64encode(chain_data).decode(),
                'signature': base64.b64encode(signature).decode()
            }

            with socket.socket(socket.AF_INET6, socket.SOCK_STREAM) as s:
                s.connect((peer_ip, peer_port))
                s.sendall(json.dumps(packet).encode())
            print(f"[📡] Broadcast to {peer_ip}:{peer_port} succeeded.")
        except Exception as e:
            print(f"[⚠️] Broadcast failed to {peer_ip}:{peer_port} → {e}")

    def sync_all_peers(self, delay: int = 30):
        """
        Periodically broadcast to all known peers.
        """
        def sync_thread():
            while True:
                for peer in self.peers:
                    self.broadcast_ledger(peer)
                time.sleep(delay)

        threading.Thread(target=sync_thread, daemon=True).start()
