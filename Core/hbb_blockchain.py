"""
Futureproof Sovereign Hypercube-Based Blockchain (HBB 2.1)
SHAKE256 Hyperdimensional Gravity-Linked Blockchain with ZK Anchoring
"""

import hashlib
import time
import json
import os
from typing import Optional

class HyperBlock:
    def __init__(self, index, timestamp, data, previous_hash, tesseract_hash, entropy, zk_origin=False):
        self.index = index
        self.timestamp = timestamp
        self.data = data
        self.previous_hash = previous_hash
        self.tesseract_hash = tesseract_hash
        self.entropy = entropy  # Sovereign entropy field
        self.zk_origin = zk_origin  # ZK-anchored flag
        self.hash = self.compute_hash()

    def compute_hash(self):
        block_string = json.dumps({
            "index": self.index,
            "timestamp": self.timestamp,
            "data": self.data,
            "previous_hash": self.previous_hash,
            "tesseract_hash": self.tesseract_hash,
            "entropy": self.entropy.hex(),
            "zk_origin": self.zk_origin
        }, sort_keys=True).encode()
        return hashlib.shake_256(block_string).hexdigest(64)

class HypercubeBlockchain:
    def __init__(self, sovereign_seeds=None):
        self.chains = []
        self.sovereign_seeds = sovereign_seeds if sovereign_seeds else [os.urandom(32).hex()]
        self.create_genesis_blocks()

    def create_genesis_blocks(self):
        for seed in self.sovereign_seeds:
            entropy = os.urandom(16)
            root_block = HyperBlock(0, time.time(), f"Sovereign Genesis Seed {seed}", "0", "0", entropy)
            self.chains.append([root_block])

    def _select_active_chain(self):
        return max(self.chains, key=lambda c: len(c))  # Longest chain

    def add_block(self, data: str, zk_origin: bool = False):
        chain = self._select_active_chain()
        prev_block = chain[-1]
        drift_entropy = os.urandom(16)
        combined_tesseract = hashlib.shake_256((prev_block.tesseract_hash + drift_entropy.hex()).encode()).hexdigest(64)
        new_block = HyperBlock(
            index=len(chain),
            timestamp=time.time(),
            data=data,
            previous_hash=prev_block.hash,
            tesseract_hash=combined_tesseract,
            entropy=drift_entropy,
            zk_origin=zk_origin
        )
        chain.append(new_block)
        return new_block

    def is_valid(self):
        """
        Validate all sovereign chains
        """
        for chain in self.chains:
            for i in range(1, len(chain)):
                curr = chain[i]
                prev = chain[i - 1]
                if curr.hash != curr.compute_hash() or curr.previous_hash != prev.hash:
                    print(f"[❌ Chain Break in chain {self.chains.index(chain)} at Block {i}]")
                    return False
        print("[✅ All Sovereign Chains Verified]")
        return True

    def save_to_file(self, path: str):
        export = []
        for chain in self.chains:
            export.append([{
                "index": b.index,
                "timestamp": b.timestamp,
                "data": b.data,
                "previous_hash": b.previous_hash,
                "tesseract_hash": b.tesseract_hash,
                "entropy": b.entropy.hex(),
                "zk_origin": b.zk_origin,
                "hash": b.hash
            } for b in chain])
        with open(path, "w") as f:
            json.dump(export, f, indent=2)

    def load_from_file(self, path: str):
        with open(path, "r") as f:
            imported = json.load(f)
        self.chains = []
        for chain_data in imported:
            chain = []
            for b in chain_data:
                block = HyperBlock(
                    index=b["index"],
                    timestamp=b["timestamp"],
                    data=b["data"],
                    previous_hash=b["previous_hash"],
                    tesseract_hash=b["tesseract_hash"],
                    entropy=bytes.fromhex(b["entropy"]),
                    zk_origin=b.get("zk_origin", False)
                )
                chain.append(block)
            self.chains.append(chain)
