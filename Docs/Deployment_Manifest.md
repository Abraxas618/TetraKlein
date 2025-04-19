# 🚀 TetraKlein Sovereign Node Deployment: Full User Guide

---

## 🌍 Overview

Welcome to the **TetraKlein Genesis** sovereign quantum-resilient node deployment guide.
This guide explains step-by-step **how to download, verify, extract, and deploy** the TetraKlein Sovereign Node on:

- 🔧 **Ubuntu Linux**
- 🔧 **Debian Linux**
- 🔧 **Kali Linux**
- 🔧 **Other Linux Distros**
- 🔧 **Windows PowerShell** (with WSL/Native)
- 🔧 **MacOS Terminal**

**No matter your OS, this guide ensures you can deploy TetraKlein successfully.**

---

## 🌐 Downloading TetraKlein Archive

### Download via IPFS

Primary IPFS Archive:
```
https://ipfs.io/ipfs/bafkreicpvxstnvvn4angq35coau55seazoytitlu4u5numg5jz2tw66ro4
```

You can manually download from browser or install **IPFS Desktop** / **command-line ipfs** client.

Example IPFS CLI Download:
```bash
ipfs get bafkreicpvxstnvvn4angq35coau55seazoytitlu4u5numg5jz2tw66ro4 -o TetraKlein-Genesis-RTH-MeshReady.tar.gz
```

### Download via GitHub (Alternative)
```bash
git clone https://github.com/Abraxas618/TetraKlein.git
```

Note: **Official Archive Name Before Upload:**
```
TetraKlein-Genesis-RTH-MeshReady.tar.gz
```

---

## 🔒 Verify Archive Integrity

SHA-256 checksum should match:
```
4fade536d6ade01a686fa27029dec880cbb1344d74e53ada30dd4e753b7bd177
```

#### Linux/macOS Terminal
```bash
sha256sum TetraKlein-Genesis-RTH-MeshReady.tar.gz
```

#### Windows PowerShell
```powershell
Get-FileHash TetraKlein-Genesis-RTH-MeshReady.tar.gz -Algorithm SHA256
```

**Match hashes before proceeding!**

---

## 🔢 Extract the Archive

#### Linux/macOS Terminal
```bash
tar -xvzf TetraKlein-Genesis-RTH-MeshReady.tar.gz
```

#### Windows PowerShell (with 7zip or WSL)
```powershell
7z x TetraKlein-Genesis-RTH-MeshReady.tar.gz
```
_or if using WSL:_
```bash
tar -xvzf TetraKlein-Genesis-RTH-MeshReady.tar.gz
```

Result: You should now have a folder structure:
```
TetraKlein-main/
├── Core/
├── Mesh/
├── ZK/
├── start.sh
├── Dockerfile
└── run_zk_trust_proof.sh
```

---

## 🎓 Install Required Software

#### Ubuntu/Debian/Kali Linux
```bash
sudo apt update
sudo apt install -y docker.io docker-compose python3 python3-pip npm nodejs build-essential wget
sudo systemctl start docker
sudo systemctl enable docker
```

#### macOS (with Homebrew)
```bash
brew install docker npm python3
```
(Ensure Docker Desktop is installed for macOS)

#### Windows PowerShell (with WSL Ubuntu)
```powershell
wsl
sudo apt update
sudo apt install -y docker.io docker-compose python3 python3-pip npm nodejs build-essential wget
sudo service docker start
```

---

## 🛠️ Building the TetraKlein Sovereign Container

From inside the extracted `TetraKlein-main/` directory:

```bash
sudo docker build -t tetraklein-genesis .
```

This will:
- Install Circom and SnarkJS
- Install Yggdrasil binary
- Build zkSNARK circuits
- Prepare Mesh encrypted networking layer

✅ You will now have the `tetraklein-genesis` container ready.

---

## 🔄 Running the Sovereign Genesis Node

```bash
sudo docker run -it --network host tetraklein-genesis
```

This will automatically:
- 📡 Bootstrap Yggdrasil Mesh Sovereign Node
- 🧰 Generate zkSNARKs with Recursive Tesseract Hashing (RTH)
- 🔢 Produce Proofs anchoring hyperdimensional ledgers

✅ Your TetraKlein Sovereign Node is now live!

---

## 💡 Troubleshooting Tips

| Problem | Solution |
|:--|:--|
| Docker build fails | Make sure system memory >4GB and disk space >5GB |
| Yggdrasil won't start | Check if ports 54545 are open; check `Mesh/yggdrasil.conf` file |
| Proof generation fails | Ensure Node.js, Circom, SnarkJS installed inside container |
| WSL Docker issues (Windows) | Start WSL manually: `wsl --update`, `wsl` then `service docker start` |

---

## 💚 Support the Sovereign Mesh!

- ⭐ GitHub: [https://github.com/Abraxas618/TetraKlein](https://github.com/Abraxas618/TetraKlein)
- 📦 Archive: [IPFS Archive Link](https://ipfs.io/ipfs/bafkreicpvxstnvvn4angq35coau55seazoytitlu4u5numg5jz2tw66ro4)

Together we build a sovereign hyperdimensional future!
