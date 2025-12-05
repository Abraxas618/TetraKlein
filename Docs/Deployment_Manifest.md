# 🚀 TetraKlein Genesis v1.4 —  Node Deployment Guide

---
© 2025 Michael Tass MacDonald (Abraxas618), Baramay Station Research Inc.  
Licensed under the Apache License, Version 2.0.
--
## 🌍 Overview

Welcome to the **TetraKlein Genesis v1.4** deployment guide.  
This guide shows how to **download, verify, extract, build, and launch** your ** Quantum-Resilient Node** across major platforms:

- Ubuntu Linux / Debian Linux / Kali Linux
- Windows 10/11 (with WSL)
- macOS
- Other UNIX-like systems

> **TetraKlein  Nodes** implement:  
> Recursive Tesseract Hashing (RTH), 12D Tetrahedral Key Exchange (TKE), Quantum Isoca-Dodecahedral Encryption (QIDL), zkSNARK Proof Systems, and  Hypercube Blockchain.

---

## 🌐 Downloading TetraKlein Genesis Archive

### 📅 IPFS Archive

Primary IPFS Archive:
```bash
https://ipfs.io/ipfs/bafybeic2vtp7kfttu5xi3l4jckhbdnusndxaiiputha5lyawfxlgvqihdi
```

Use **browser download** or **IPFS CLI**:
```bash
ipfs get bafybeic2vtp7kfttu5xi3l4jckhbdnusndxaiiputha5lyawfxlgvqihdi -o TetraKlein-Genesis-v1.4.tar.gz
```

---

### 📅 GitHub Clone

```bash
git clone https://github.com/Abraxas618/TetraKlein.git
cd TetraKlein
```

---

## 🔒 Verifying Archive Integrity

SHA-256 checksum (official):
```
b9dc97a6e4cbf2e02b6bb830897d1b92b8362a2ff5b38e7c9628e4970ed24511
```

#### Linux/macOS Terminal
```bash
sha256sum TetraKlein-Genesis-v1.4.tar.gz
```

#### Windows PowerShell
```powershell
Get-FileHash TetraKlein-Genesis-v1.4.tar.gz -Algorithm SHA256
```

✅ Ensure your checksum **matches** before extracting!

---

## 📉 Extracting the Archive

#### Linux/macOS Terminal
```bash
tar -xvzf TetraKlein-Genesis-v1.4.tar.gz
```

#### Windows PowerShell (with WSL or 7zip)
```powershell
7z x TetraKlein-Genesis-v1.4.tar.gz
```

Resulting Folder Structure:
```
TetraKlein/
🔹 Core/
🔹 Mesh/
🔹 ZK/
🔹 start.sh
🔹 Dockerfile
🔹 podman-compose.yml
🔹 run_zk_trust_proof.sh
```

---

## 🎓 Installing Required Software

#### Ubuntu/Debian/Kali
```bash
sudo apt update
sudo apt install -y podman podman-compose python3 python3-pip npm nodejs build-essential wget
```

#### macOS (Homebrew)
```bash
brew install podman npm python3
brew install podman-compose
```

#### Windows (WSL Ubuntu)
```powershell
wsl
sudo apt update
sudo apt install -y podman podman-compose python3 python3-pip npm nodejs build-essential wget
```

✅ Start Podman service if necessary:
```bash
systemctl --user start podman
```

---

## 🛠️ Building the  Node Container

Inside `TetraKlein/` folder:

```bash
podman build --no-cache -t tetraklein-genesis .
```

✅ This will:
- Install Circom, SnarkJS
- Prepare zkSNARK circuits
- Install Yggdrasil IPv6 mesh tools
- Build Mesh networking simulation layer
- Prepare Recursive Tesseract Hash entropy engine

---

## 🔄 Launching Your TetraKlein Genesis Node

### Option 1:  Node + Simulated Mesh (default)
```bash
podman run -it tetraklein-genesis
```

✅ Starts full Genesis Proof Cycle, creates ledger, proof, and blockchain.

---

### Option 2:  Node + Full Yggdrasil Mesh (if TUN support exists)
```bash
podman run --device /dev/net/tun --cap-add NET_ADMIN -it tetraklein-genesis
```
> ⚡ Requires TUN/TAP device access on host (Linux only)

✅ This will generate a live  IPv6 Yggdrasil Mesh Node!

---

## 📜 Genesis Events Executed

Upon launch:
- zkSNARK Circuit Compiled (Groth16)
- Trusted Setup Ceremony completed
- Witness generated
-  zkProof created
- Recursive Tesseract Hash generated
-  Hypercube Ledger Genesis Block anchored
- Optional Yggdrasil Mesh Identity generated

---

## 💡 Troubleshooting Tips

| Problem | Solution |
|:---|:---|
| Podman build fails | Ensure RAM > 4GB and Disk Space > 5GB |
| Missing TUN device | Launch in simulation mode (`podman run -it tetraklein-genesis`) |
| Proof generation errors | Reinstall NodeJS and npm inside container |
| WSL Docker issues (Windows) | Restart WSL: `wsl --shutdown`, `wsl`, then `systemctl start podman` |

---

## 💚 Support the  Mesh!

- ⭐ GitHub: [https://github.com/Abraxas618/TetraKlein](https://github.com/Abraxas618/TetraKlein)
- 🌐 Medium Genesis Article: [TetraKlein Genesis v1.4 Announcement](https://medium.com/@tassalphonse/tetraklein-genesis-v1-4-the-dawn-of-hyperdimensional--infrastructure-ad55ebca7025)
- 📆 IPFS Archive: [bafybeic2vtp7kfttu5xi3l4jckhbdnusndxaiiputha5lyawfxlgvqihdi](https://ipfs.io/ipfs/bafybeic2vtp7kfttu5xi3l4jckhbdnusndxaiiputha5lyawfxlgvqihdi)

---

🌟  
**Together we are building the Hyperdimensional  Civilization of the Future.**  
🌟

# 🚀 Long Live TetraKlein Genesis v1.4 — The Dawn of  Infrastructure.
