# 🚀 TetraKlein Genesis Node Deployment User Guide

**Project:** TetraKlein-Genesis-RTH-MeshReady  
**Creator:** Michael Tass MacDonald (Abraxas618)  
**IPFS Archive:** [bafkreicpvxstnvvn4angq35coau55seazoytitlu4u5numg5jz2tw66ro4](https://ipfs.io/ipfs/bafkreicpvxstnvvn4angq35coau55seazoytitlu4u5numg5jz2tw66ro4)  
**GitHub Repository:** [Abraxas618/TetraKlein](https://github.com/Abraxas618/TetraKlein.git)

---

# Overview
This guide explains **how to deploy** the TetraKlein Sovereign Quantum-Resilient Node on:
- Ubuntu Linux
- Debian Linux
- Kali Linux
- Fedora Linux
- Arch Linux
- Windows 10/11 (PowerShell + WSL2 recommended)
- macOS (Intel and Apple Silicon)

No matter the system, this manual ensures you can fully deploy your own **sovereign encrypted mesh node** + **hyperdimensional ledger genesis**.

---

# Pre-requisites

| Requirement | Minimum Version | Notes |
|:--|:--|:--|
| Docker or Podman | Latest | Sovereign container deployment |
| curl, wget, tar, gzip | Installed | Archive management |
| git | Installed | Clone GitHub repo |
| Python3 + pip3 | Installed | Required inside container |
| Internet access (optional) | | Only needed for initial bootstrap |

---

# 1. Ubuntu / Debian / Kali Linux Instructions

```bash
# 1. Update system
sudo apt update && sudo apt upgrade -y

# 2. Install dependencies
sudo apt install -y docker.io curl wget tar gzip python3 python3-pip git

# 3. Clone TetraKlein Genesis
git clone https://github.com/Abraxas618/TetraKlein.git
cd TetraKlein

# 4. (OR) Download from IPFS
wget https://ipfs.io/ipfs/bafkreicpvxstnvvn4angq35coau55seazoytitlu4u5numg5jz2tw66ro4 -O TetraKlein-Genesis-RTH-MeshReady.tar.gz

# 5. Extract archive
mkdir TetraKleinGenesis
tar -xvzf TetraKlein-Genesis-RTH-MeshReady.tar.gz -C TetraKleinGenesis
cd TetraKleinGenesis

# 6. Build container (Docker)
sudo docker build -t tetraklein-genesis .

# 7. Run sovereign node
sudo docker run --rm -it tetraklein-genesis
```

---

# 2. Fedora / Arch Linux Instructions

```bash
# 1. Update system
sudo dnf update -y   # (Fedora)
sudo pacman -Syu     # (Arch)

# 2. Install dependencies
sudo dnf install -y docker curl wget tar gzip python3-pip git   # (Fedora)
sudo pacman -S docker curl wget tar gzip python-pip git        # (Arch)

# 3. Enable Docker
sudo systemctl enable docker
sudo systemctl start docker

# 4. Proceed same as Ubuntu
# (Clone GitHub or IPFS download)
...
```

---

# 3. Windows 10/11 (PowerShell + WSL2 Recommended)

### A. WSL2 Setup

```powershell
# 1. Enable WSL
wsl --install

# 2. Install Ubuntu from Microsoft Store
# (Or use Debian, Fedora, Kali Linux)

# 3. Open Ubuntu Terminal inside Windows

# 4. Follow Ubuntu instructions from earlier
```

### B. Native PowerShell (Docker Desktop)

```powershell
# 1. Install Docker Desktop for Windows
# https://www.docker.com/products/docker-desktop

# 2. Open PowerShell as Administrator

# 3. Clone repo
git clone https://github.com/Abraxas618/TetraKlein.git
cd TetraKlein

# 4. (OR) Download via curl
curl -LO https://ipfs.io/ipfs/bafkreicpvxstnvvn4angq35coau55seazoytitlu4u5numg5jz2tw66ro4
Expand-Archive TetraKlein-Genesis-RTH-MeshReady.tar.gz -DestinationPath .

# 5. Build and run
docker build -t tetraklein-genesis .
docker run --rm -it tetraklein-genesis
```

---

# 4. macOS (Intel or Apple Silicon)

```bash
# 1. Install Homebrew if missing
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. Install dependencies
brew install docker git python3

# 3. Start Docker Desktop

# 4. Clone and build
git clone https://github.com/Abraxas618/TetraKlein.git
cd TetraKlein

# (OR IPFS download)
...

# 5. Build container
docker build -t tetraklein-genesis .

# 6. Run container
docker run --rm -it tetraklein-genesis
```

---

# 5. After Deployment — Mesh + Proof Instructions

- Yggdrasil encrypted Mesh auto-starts.
- Sovereign IPv6 `tun0` interface will initialize.
- zkSNARK RTH proof system will generate and validate Genesis.
- Logs will display `Sovereign Mesh Online. Launching zkSNARK Proof Node...`

✅ You are now inside **TetraKlein Sovereign Genesis Node**.

---

# Troubleshooting

| Issue | Solution |
|:--|:--|
| Docker permission denied | `sudo usermod -aG docker $USER` then reboot |
| IPFS download slow | Use `wget` with `--tries=10` or clone from GitHub |
| Yggdrasil errors | Check `/opt/app/Mesh/yggdrasil.conf` for typos |
| Proof fails | Ensure `Core/rth.py` and `run_zk_trust_proof.sh` exist |

---

# 🌌 You Are Now Sovereign.

Congratulations, Operator — you now have a:
- Sovereign encrypted mesh
- Hyperdimensional post-quantum proof node
- Independence from all centralized systems

Built by **Michael Tass MacDonald (Abraxas618)**.
