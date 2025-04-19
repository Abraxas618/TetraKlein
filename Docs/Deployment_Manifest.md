# 🚁 TetraKlein Sovereign Node Deployment User Guide

**Project:** TetraKlein Genesis
**Creator:** Michael Tass MacDonald (Abraxas618)  
**Codex Certification:** Sovereign Infrastructure Genesis — 001

---

# Overview

This guide explains how to deploy the **TetraKlein Sovereign Quantum-Resilient Node** on **any OS**:
- Ubuntu / Debian / Fedora / Arch / Kali Linux / any Linux distro
- Windows (PowerShell and WSL)
- macOS

**IPFS Archive:**
- **Name:** `bafkreicpvxstnvvn4angq35coau55seazoytitlu4u5numg5jz2tw66ro4.gz`
- **Link:** [https://ipfs.io/ipfs/bafkreicpvxstnvvn4angq35coau55seazoytitlu4u5numg5jz2tw66ro4](https://ipfs.io/ipfs/bafkreicpvxstnvvn4angq35coau55seazoytitlu4u5numg5jz2tw66ro4)

**GitHub Repository:**
- [https://github.com/Abraxas618/TetraKlein](https://github.com/Abraxas618/TetraKlein)

---

# General Requirements

- Docker OR Podman installed
- IPFS client (optional for downloading via IPFS)
- Python3 and npm (automatically handled inside container)

---

# Deployment on Linux (Ubuntu, Debian, Fedora, Kali, Arch)

## 1. Install Docker

```bash
# Ubuntu / Debian
sudo apt update && sudo apt install docker.io -y

# Fedora
sudo dnf install docker -y

# Arch / Manjaro
sudo pacman -S docker

# Start and enable Docker
sudo systemctl start docker
sudo systemctl enable docker
```

## 2. Download the TetraKlein package

Option 1 (IPFS):
```bash
ipfs get bafkreicpvxstnvvn4angq35coau55seazoytitlu4u5numg5jz2tw66ro4 -o TetraKlein.tar.gz
```

Option 2 (GitHub Clone):
```bash
git clone https://github.com/Abraxas618/TetraKlein.git
cd TetraKlein
```

## 3. Build and Launch

```bash
# If using IPFS archive
tar -xvzf TetraKlein.tar.gz
cd TetraKlein

# Build container
sudo docker build -t tetraklein-node .

# Launch container
sudo docker run --network=host tetraklein-node
```

---

# Deployment on Windows (PowerShell)

## 1. Install Docker Desktop
- Download and install: [https://www.docker.com/products/docker-desktop/](https://www.docker.com/products/docker-desktop/)
- Enable WSL2 backend

## 2. Download TetraKlein package

Using PowerShell:
```powershell
# GitHub Clone
git clone https://github.com/Abraxas618/TetraKlein.git
cd TetraKlein

# (Optional) Or download from IPFS using Kubo/Helia clients
```

## 3. Build and Run

```powershell
# In PowerShell
docker build -t tetraklein-node .
docker run --network=host tetraklein-node
```

**Note:** Windows Docker Desktop simulates Linux networking; `--network=host` behaves differently. Consider using WSL2 Ubuntu Terminal for a true Linux-native mesh.

---

# Deployment on macOS

## 1. Install Docker

```bash
brew install --cask docker
open /Applications/Docker.app
```

## 2. Download and Launch

Same steps as Linux:
```bash
git clone https://github.com/Abraxas618/TetraKlein.git
cd TetraKlein

docker build -t tetraklein-node .
docker run --network=host tetraklein-node
```

---

# Notes for Advanced Users

- You can modify `Mesh/yggdrasil.conf` to manually add bootstrap Peers.
- Tun0 interface will be created when Yggdrasil mesh is active.
- Full sovereignty is enabled by default: SessionFirewall active, Multicast disabled.
- Docker container will automatically start Yggdrasil Mesh, then run zkSNARK Sovereign Proof cycle.

---

# Verification

After launch, verify:
```bash
# Check tun0 exists
ip addr | grep tun0

# Check Yggdrasil process running
ps aux | grep yggdrasil

# Proof system running
ls proof.json public.json verification_key.json
```
# For Questions / Mission Support

- GitHub Issues: [https://github.com/Abraxas618/TetraKlein/issues](https://github.com/Abraxas618/TetraKlein/issues)
