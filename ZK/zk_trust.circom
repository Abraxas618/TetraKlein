// ZK/zk_trust.circom  – fixed version
pragma circom 2.0.0;

include "poseidon.circom";

template Main() {
    signal input  user_entropy;   // 256‑bit user‑supplied entropy
    signal input  time_salt;      // 64‑bit (or 256‑bit) timestamp salt
    signal output hash;           // Poseidon hash result

    component hasher = Poseidon(2);
    hasher.inputs[0] <== user_entropy;
    hasher.inputs[1] <== time_salt;

    hash <== hasher.out;
}

component main = Main();
