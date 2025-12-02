TetraKlein Genesis v1.4 — Experimental Proof-of-Concept Pipeline

Baramay Station Research Inc. — Advanced Systems Directorate (ASD)
Principal Investigator: Michael Tass MacDonald
Date: April 28, 2025

1. Overview

TetraKlein Genesis v1.4 is an experimental research prototype designed to evaluate whether a complete cryptographic workflow can run end-to-end inside a reproducible container environment. The workflow includes:

Zero-knowledge circuit compilation

Groth16 trusted setup

Witness generation

zk-SNARK proof creation and verification

Experimental recursive hashing

Ledger genesis block creation

Hypercube ledger digest generation

Mesh identity initialization (simulated)

This repository contains non-production, prototype-grade code intended strictly for applied cryptography and systems research.

2. Objectives

The v1.4 experimental pipeline performs:

Circom circuit compilation

Groth16 Powers-of-Tau Phase 1

Powers-of-Tau Phase 2

zKey finalization

Verification key export

Witness generation

zk-SNARK proof creation

zk-SNARK proof verification

Recursive hashing (prototype RTH)

Ledger genesis block generation

Hypercube ledger digest creation

Yggdrasil mesh identity initialization (simulation mode when TUN unavailable)

3. Repository Structure
/circuits/       CIRCOM circuits (prototype)
/ledger/         Experimental ledger and hashing components
/rth/            Recursive hashing prototype
/mesh/           Mesh identity generation (Yggdrasil)
/docker/         Container environment and build files
/docs/           Additional technical notes
/logs/           Execution logs for reproducibility

4. Running the Proof-of-Concept
Build the container
git clone https://github.com/Abraxas618/TetraKlein.git
cd TetraKlein
podman build --no-cache -t tetraklein-genesis .

Run the experimental pipeline
podman run -it tetraklein-genesis

Optional mesh initialization (requires /dev/net/tun)
podman run --device /dev/net/tun --cap-add NET_ADMIN -it tetraklein-genesis


If /dev/net/tun is not available, the mesh subsystem automatically falls back to simulation mode.

5. Experimental Outputs

The pipeline produces:

zk_trust.r1cs, zk_trust.wasm, and zk_trust.sym

Powers-of-Tau files from Phase 1 and Phase 2

Finalized zkey

Verification key (vkey.json)

Witness file (witness.wtns)

zk-SNARK proof (proof.json)

Recursive Tesseract Hash output (rth_output.bin)

Experimental ledger genesis block

Hypercube ledger root digest

Yggdrasil mesh identity (simulated or real)

A complete log is available in:

/logs/genesis_run_full.txt

6. Representative Results
zk-SNARK Verification
[INFO] snarkJS: OK!

Recursive Hash Digest (truncated)
6de882c13b06d1b6cacb0566334f28c0ed1de2c9286e2c06fc4fa0d650263d5f

Ledger Root Digest
3d90c84acdda6c28d41e4d3ccc1f552197c928614e213e2e8d6eeeede369c6b2...

Mesh Identity (simulated)
Public Key: f07540f8a63527...
IPv6 Address: 200:1f15:7e0e:b395:b16d:fb97:3801:d5b8

7. Limitations

The prototype:

Has no formal cryptographic proof

Has not been reviewed externally

Is not quantum-secure

Is not designed for production

Contains conceptual models (RTH, TKE, QIDL) under evaluation

Provides no confidentiality or integrity guarantees

Executes mesh identity initialization in simulated mode unless properly configured

All results are exploratory and must not be used in security-critical environments.

8. Future Work

Planned next steps include:

Formalizing mathematical definitions

Modularizing pipeline components

Benchmarking performance characteristics

Evaluating error propagation

Enabling full mesh support inside containers

Extending circuit definitions

Preparing academic-grade documentation

9. Artifact Access

IPFS Genesis Archive:
https://ipfs.io/ipfs/bafybeic2vtp7kfttu5xi3l4jckhbdnusndxaiiputha5lyawfxlgvqihdi

OpenTimestamp Proof:
https://ipfs.io/ipfs/bafkreihoqlvubx7o7itjl25esl4pbwwnpbsm3kj2srgn3462a3tbavmhxi

10. License

This project is distributed under the Apache License 2.0.
Some components may also be available under MIT.
Refer to the included LICENSE file for details.

11. Contact

Baramay Station Research Inc.
Principal Investigator: Michael Tass MacDonald
ORCID: https://orcid.org/0009-0005-6468-7651
