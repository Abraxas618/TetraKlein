import os
import hashlib
import json
import base64
import time
from typing import Tuple
from datetime import datetime
from hashlib import shake_256


class QuantumLatticeEncryptor:
    def __init__(self, seed: bytes = None):
        if seed is None:
            self.seed = os.urandom(32)
        else:
            self.seed = seed
        self.key = self._generate_key(self.seed)

    def _generate_key(self, seed: bytes) -> bytes:
        shake = shake_256()
        shake.update(seed)
        return shake.digest(64)  # 512-bit key

    def encrypt(self, message: str) -> Tuple[str, str]:
        message_bytes = message.encode('utf-8')
        ciphertext = bytes([b ^ self.key[i % len(self.key)] for i, b in enumerate(message_bytes)])
        encoded = base64.b64encode(ciphertext).decode('utf-8')
        return encoded, base64.b64encode(self.seed).decode('utf-8')

    def decrypt(self, encoded_ciphertext: str, seed_b64: str) -> str:
        seed = base64.b64decode(seed_b64.encode('utf-8'))
        key = self._generate_key(seed)
        ciphertext = base64.b64decode(encoded_ciphertext.encode('utf-8'))
        plaintext_bytes = bytes([b ^ key[i % len(key)] for i, b in enumerate(ciphertext)])
        return plaintext_bytes.decode('utf-8')


# === Example usage and ledger input generation ===

message = "Hyperdimensional signal from node α."
encryptor = QuantumLatticeEncryptor()
ciphertext, encoded_seed = encryptor.encrypt(message)

# Safe relative paths
input_path = "input.json"
ledger_path = "zk_qidl_ledger_entry.json"

user_entropy = int.from_bytes(os.urandom(8), byteorder='big')
time_salt = int(time.time())

zk_input = {
    "user_entropy": user_entropy,
    "time_salt": time_salt
}

with open(input_path, "w") as f:
    json.dump(zk_input, f, indent=4)

ledger_entry = {
    "timestamp": datetime.utcnow().isoformat() + "Z",
    "ciphertext": ciphertext,
    "entropy_seed": encoded_seed,
    "zk_origin": True
}

with open(ledger_path, "w") as f:
    json.dump(ledger_entry, f, indent=4)

# Optional DataFrame display (comment out if not using inside notebook)
try:
    import ace_tools as tools
    tools.display_dataframe_to_user(name="ZK-QIDL Ledger Entry", dataframe=[ledger_entry])
except:
    pass  # Safe fallback for environments without ace_tools
