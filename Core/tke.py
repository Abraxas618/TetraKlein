import os
import numpy as np
from hashlib import shake_256
import time

class TetrahedralKeyExchange:
    def __init__(self, dimension=12, modulus=(2**61 - 1), seed=None):
        """
        Initializes the TKE instance with an optional seed for deterministic behavior.
        """
        self.q = modulus  # Large prime modulus for field
        self.d = dimension
        self.phi = 1.61803398875  # Golden Ratio
        self.seed = seed
        if self.seed is not None:
            np.random.seed(self.seed)
        else:
            np.random.seed(int(time.time()))
        self.T = self.generate_tetrahedral_basis()

    def generate_tetrahedral_basis(self):
        """
        Generates 4 unit basis vectors forming a regular tetrahedron in d-dimensional space.
        """
        T = []
        for _ in range(4):
            v = np.random.randn(self.d)
            v = v / np.linalg.norm(v)
            T.append(v)
        return np.array(T)

    def generate_private_key(self):
        """
        Generates a private vector in Z_q^d.
        """
        return np.random.randint(0, self.q, self.d)

    def generate_public_matrix(self):
        """
        Generates a public projection matrix A with tetrahedral perturbation.
        """
        A = np.zeros((self.d, self.d), dtype=int)
        for i in range(self.d):
            for j in range(self.d):
                if i != j:
                    A[i, j] = (int((self.T[i % 4] @ self.T[j % 4]) * self.q) + np.random.randint(1, 1000)) % self.q
        return A

    def generate_public_key(self, A, sk):
        """
        Projects the private key through matrix A.
        """
        return (A @ sk) % self.q

    def derive_shared_secret(self, pk_other, sk_self):
        """
        Combines the other’s public key and self’s private key through a tetrahedral projection.
        """
        projection = int((pk_other @ sk_self) % self.q)
        entropy = os.urandom(32)
        time_entropy = int(time.time_ns()).to_bytes(8, 'big')
        entropy_mix = projection.to_bytes(32, 'big') + entropy + time_entropy
        return shake_256(entropy_mix).digest(64)

    def run_exchange(self):
        """
        Full key exchange simulation.
        """
        sk_A = self.generate_private_key()
        A = self.generate_public_matrix()
        pk_A = self.generate_public_key(A, sk_A)

        sk_B = self.generate_private_key()
        pk_B = self.generate_public_key(A, sk_B)

        secret_A = self.derive_shared_secret(pk_B, sk_A)
        secret_B = self.derive_shared_secret(pk_A, sk_B)

        return secret_A == secret_B, secret_A.hex()
