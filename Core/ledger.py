import json
import os
import time
import hashlib
from typing import List, Optional

class LedgerBlock:
    def __init__(self, node_id: str, state_hash: str, prev_hash: Optional[str], entropy: bytes, zk_origin: bool = False, timestamp: Optional[int] = None):
        self.node_id = node_id
        self.timestamp = timestamp if timestamp else int(time.time())
        self.state_hash = state_hash
        self.prev_hash = prev_hash or "0" * 64
        self.entropy = entropy.hex()
        self.zk_origin = zk_origin
        self.hash = self.compute_hash()

    def compute_hash(self) -> str:
        shake = hashlib.shake_256()
        data = f"{self.node_id}|{self.timestamp}|{self.state_hash}|{self.prev_hash}|{self.entropy}|{self.zk_origin}"
        shake.update(data.encode('utf-8'))
        return shake.hexdigest(64)

    def to_dict(self) -> dict:
        return {
            "node_id": self.node_id,
            "timestamp": self.timestamp,
            "state_hash": self.state_hash,
            "prev_hash": self.prev_hash,
            "entropy": self.entropy,
            "zk_origin": self.zk_origin,
            "hash": self.hash
        }

class Ledger:
    def __init__(self, chain_file: str = "ledger_chain.json", node_id: str = "Node0", epoch_size: int = 1000):
        self.chain_file = chain_file
        self.node_id = node_id
        self.epoch_size = epoch_size
        self.chain: List[LedgerBlock] = self.load_chain()

    def load_chain(self) -> List[LedgerBlock]:
        if os.path.exists(self.chain_file):
            with open(self.chain_file, "r") as f:
                data = json.load(f)
                return [LedgerBlock(
                    node_id=blk["node_id"],
                    state_hash=blk["state_hash"],
                    prev_hash=blk["prev_hash"],
                    entropy=bytes.fromhex(blk["entropy"]),
                    zk_origin=blk.get("zk_origin", False),
                    timestamp=blk.get("timestamp")
                ) for blk in data]
        return []

    def get_last_hash(self) -> Optional[str]:
        if self.chain:
            return self.chain[-1].hash
        return None

    def add_block(self, state_hash: str, zk_origin: bool = False, timestamp: Optional[int] = None):
        entropy = os.urandom(16)
        block = LedgerBlock(
            node_id=self.node_id,
            state_hash=state_hash,
            prev_hash=self.get_last_hash(),
            entropy=entropy,
            zk_origin=zk_origin,
            timestamp=timestamp
        )
        self.chain.append(block)

    def save_chain(self, path: Optional[str] = None):
        path = path or self.chain_file
        with open(path, "w") as f:
            json.dump([b.to_dict() for b in self.chain], f, indent=2)

    def verify_chain(self) -> bool:
        for i in range(1, len(self.chain)):
            if self.chain[i].prev_hash != self.chain[i - 1].hash:
                return False
        return True

    def print_summary(self):
        print(f"Ledger Summary: {len(self.chain)} blocks")
        for i, block in enumerate(self.chain):
            print(f"Block {i}: ZK={block.zk_origin}, Hash={block.hash[:12]}..., State={block.state_hash[:12]}...")

    def export_chain(self):
        return [b.to_dict() for b in self.chain]

    def import_chain(self, incoming_chain):
        try:
            if len(incoming_chain) > len(self.chain):
                self.chain = [LedgerBlock(
                    node_id=blk["node_id"],
                    state_hash=blk["state_hash"],
                    prev_hash=blk["prev_hash"],
                    entropy=bytes.fromhex(blk["entropy"]),
                    zk_origin=blk.get("zk_origin", False),
                    timestamp=blk.get("timestamp")
                ) for blk in incoming_chain]
                return True
        except Exception as e:
            print(f"[❌] Chain import failed: {e}")
        return False
