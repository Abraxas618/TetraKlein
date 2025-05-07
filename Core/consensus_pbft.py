import json
import socket
import threading
import subprocess
import time

PORT = 10010
BUFFER_SIZE = 8192

class PBFTNode:
    def __init__(self, node_id, peers, verification_key_path="verification_key.json", port=PORT):
        self.node_id = node_id
        self.peers = peers  # list of IPv6 strings
        self.state = 'idle'
        self.current_block = None
        self.votes = {}
        self.verification_key_path = verification_key_path
        self.port = port

    def verify_snark(self, proof, public):
        with open("proof.json", "w") as pf, open("public.json", "w") as pubf:
            json.dump(proof, pf)
            json.dump(public, pubf)

        result = subprocess.run(
            ["snarkjs", "groth16", "verify", self.verification_key_path, "public.json", "proof.json"],
            capture_output=True, text=True
        )
        return "OK" in result.stdout

    def propose_block(self, state_hash, proof_path, public_path):
        try:
            with open(proof_path, "r") as pf, open(public_path, "r") as pubf:
                proof = json.load(pf)
                public = json.load(pubf)

            proposal = {
                "type": "proposal",
                "node_id": self.node_id,
                "timestamp": time.time(),
                "block": {
                    "hash": state_hash,
                    "node_id": self.node_id,
                },
                "proof": proof,
                "public": public
            }

            for peer in self.peers:
                try:
                    with socket.socket(socket.AF_INET6, socket.SOCK_STREAM) as s:
                        s.connect((peer, self.port))
                        s.sendall(json.dumps(proposal).encode())
                    print(f"[📡] Proposal sent to {peer}")
                except Exception as e:
                    print(f"[⚠️] Failed to send proposal to {peer}: {e}")
        except Exception as e:
            print(f"[❌] Proposal generation failed: {e}")

    def receive_proposal(self, data):
        block = data['block']
        proof = data['proof']
        public = data['public']

        if self.verify_snark(proof, public):
            self.current_block = block
            self.state = 'prepare'
            self.broadcast_vote('prepare', block['hash'])

    def receive_vote(self, phase, block_hash):
        self.votes[block_hash] = self.votes.get(block_hash, 0) + 1
        if self.votes[block_hash] >= self.quorum():
            if phase == 'prepare':
                self.state = 'commit'
                self.broadcast_vote('commit', block_hash)
            elif phase == 'commit':
                self.commit_block(block_hash)

    def broadcast_vote(self, phase, block_hash):
        vote_msg = json.dumps({
            "node_id": self.node_id,
            "phase": phase,
            "block_hash": block_hash
        }).encode()
        for peer_ip in self.peers:
            try:
                with socket.socket(socket.AF_INET6, socket.SOCK_STREAM) as s:
                    s.connect((peer_ip, self.port))
                    s.sendall(vote_msg)
            except Exception as e:
                print(f"[⚠️] Broadcast to {peer_ip}:{self.port} failed: {e}")

    def commit_block(self, block_hash):
        print(f"[✅] Block {block_hash} committed by PBFT node {self.node_id}")

    def quorum(self):
        return (len(self.peers) * 2) // 3 + 1

    def start_listener(self):
        def handle_client(conn, addr):
            try:
                data = json.loads(conn.recv(BUFFER_SIZE).decode())
                if 'phase' in data:
                    self.receive_vote(data['phase'], data['block_hash'])
                else:
                    self.receive_proposal(data)
            except Exception as e:
                print(f"[❌] PBFT error: {e}")
            conn.close()

        def listener_thread():
            with socket.socket(socket.AF_INET6, socket.SOCK_STREAM) as s:
                s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
                s.bind(('::', self.port))
                s.listen()
                print(f"[🛰️] PBFT Node listening on port {self.port}")
                while True:
                    conn, addr = s.accept()
                    threading.Thread(target=handle_client, args=(conn, addr)).start()

        threading.Thread(target=listener_thread, daemon=True).start()
