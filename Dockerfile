# 🛰️ Base NodeJS Slim Image
FROM node:18-slim

# 🛰️ Install Circom and SnarkJS for zkSNARKs
RUN npm install -g circom snarkjs

# 🛰️ Install System Tools, Go, and Python3 Environment
RUN apt-get update && apt-get install -y \
    wget \
    git \
    golang-go \
    build-essential \
    python3 \
    python3-venv \
    python3-pip \
    ca-certificates \
 && rm -rf /var/lib/apt/lists/*

# 🛰️ Create Python venv and Install NumPy inside it
RUN python3 -m venv /opt/venv && \
    /opt/venv/bin/pip install --upgrade pip && \
    /opt/venv/bin/pip install numpy

# 🛰️ Clone and Build Yggdrasil v0.5.5 from Source (using Go directly)
RUN git clone https://github.com/yggdrasil-network/yggdrasil-go.git /opt/yggdrasil && \
    cd /opt/yggdrasil && \
    git checkout v0.5.5 && \
    go build -o yggdrasil ./cmd/yggdrasil && \
    cp yggdrasil /usr/local/bin/ && \
    chmod +x /usr/local/bin/yggdrasil && \
    rm -rf /opt/yggdrasil

# 🛰️ Set Environment to Use Local Sovereign Python venv
ENV PATH="/opt/venv/bin:$PATH"

# 🛰️ Create Sovereign App Directory
WORKDIR /opt/app

# 🛰️ Copy All Project Files
COPY . .

# 🛰️ Prebuild zkSNARK Proof Environment
RUN circom zk_trust.circom --r1cs --wasm --sym

# 🛰️ Sovereign Boot Command
CMD ["bash", "start.sh"]
