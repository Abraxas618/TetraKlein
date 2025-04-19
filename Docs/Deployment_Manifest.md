# 🚀 TetraKlein-Genesis-RTH-MeshReady User Deployment Guide

**Project:** TetraKlein Genesis 
**Version:** Sovereign Quantum-Resilient Infrastructure Release 1.0
**Archive:** `TetraKlein-Genesis-RTH-MeshReady.tar.gz`
By Michael Tass MacDonald (Abraxas618)

---

# 🌐 Deployment Sources

- **IPFS Archive:** [TetraKlein on IPFS](https://ipfs.io/ipfs/bafkreicpvxstnvvn4angq35coau55seazoytitlu4u5numg5jz2tw66ro4)
- **GitHub Repository:** [TetraKlein GitHub Clone](https://github.com/Abraxas618/TetraKlein)

Clone Command:
```bash
git clone https://github.com/Abraxas618/TetraKlein.git
```

---

# 📁 Contents of Archive

- `Dockerfile`
- `start.sh`
- `run_zk_trust_proof.sh`
- `Core/rth.py` (Recursive Tesseract Hashing)
- `Mesh/yggdrasil.conf` (Hardened Mesh Configuration)
- `ZK/zk_trust.circom`
- `ZK/input.json`

All files needed for full sovereign deployment.

---

# 🔧 Universal Deployment Instructions

## 💡 Requirements (All Systems)

- Docker or Podman Installed (rootless preferred)
- Ports `54545` open if peering publicly
- Python3 + pip (for RTH inside container)

---

# 🌍 Linux Deployment Instructions (Ubuntu, Kali, Debian, Fedora, Arch)

### 1. Install Docker
```bash
sudo apt update
sudo apt install docker.io -y
sudo systemctl start docker
sudo systemctl enable docker
```
OR Install Podman:
```bash
sudo apt install podman -y
```

### 2. Clone and Extract Project
```bash
mkdir -p ~/TetraKlein
cd ~/TetraKlein
wget https://ipfs.io/ipfs/bafkreicpvxstnvvn4angq35coau55seazoytitlu4u5numg5jz2tw66ro4 -O TetraKlein-Genesis-RTH-MeshReady.tar.gz
tar -xvzf TetraKlein-Genesis-RTH-MeshReady.tar.gz
```

OR Clone GitHub:
```bash
git clone https://github.com/Abraxas618/TetraKlein.git
cd TetraKlein
```

### 3. Build Docker Container
```bash
docker build -t tetraklein-genesis .
```

### 4. Run Sovereign Node
```bash
docker run -it --rm --network host tetraklein-genesis
```

- `--network host` is important to expose mesh ports.

---

# 💻 Windows Deployment Instructions (PowerShell)

### 1. Install Docker Desktop
- Download and install from: [Docker for Windows](https://www.docker.com/products/docker-desktop/)
- Ensure "Use WSL2 Backend" is enabled.

### 2. Open PowerShell (Admin) and Clone Project
```powershell
mkdir C:\TetraKlein
cd C:\TetraKlein
Invoke-WebRequest -Uri "https://ipfs.io/ipfs/bafkreicpvxstnvvn4angq35coau55seazoytitlu4u5numg5jz2tw66ro4" -OutFile "TetraKlein-Genesis-RTH-MeshReady.tar.gz"
Expand-Archive -LiteralPath TetraKlein-Genesis-RTH-MeshReady.tar.gz -DestinationPath .
```

OR Clone GitHub:
```powershell
git clone https://github.com/Abraxas618/TetraKlein.git
cd TetraKlein
```

### 3. Build Docker Container
```powershell
docker build -t tetraklein-genesis .
```

### 4. Run Sovereign Node
```powershell
docker run -it --rm --network host tetraklein-genesis
```
(If `--network host` causes issues on Windows, consider using a bridge network manually.)

---

# 🛡️ Advanced Sovereign Tips

- Change PrivateKey/PublicKey in `Mesh/yggdrasil.conf` before launching for unique node identity.
- Set `BootstrapPeers` in `Mesh/yggdrasil.conf` if you want to connect to other sovereign nodes.
- Use `Podman` instead of Docker if you require rootless containers.
- Use `systemd` services for auto-starting the node on boot.

---

# 🌟 Full Sovereign Lifecycle

| Phase | Action |
|:--|:--|
| Mesh Startup | Yggdrasil starts from hardened `Mesh/yggdrasil.conf`. |
| Proof Cycle | `run_zk_trust_proof.sh` executes zkSNARK generation using Recursive Tesseract entropy. |
| Ledger Genesis | Proofs anchored against Post-Quantum Hyperdimensional Ledger. |
| Sovereign Expansion | Connect to other TetraKlein nodes via BootstrapPeers. |

---

 Michael Tass MacDonald (Abraxas618)  
