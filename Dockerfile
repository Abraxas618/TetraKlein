# ─────────────────────────────────────────────────────────────
# 🛰️  TetraKlein Genesis – Final Hardened Dockerfile
# ─────────────────────────────────────────────────────────────

# 1️⃣ Base NodeJS image
FROM node:18-slim

# 2️⃣ Circom 2 + SnarkJS
RUN npm install -g circom snarkjs

# 3️⃣ System tools, Python venv, and Go toolchain deps
RUN apt-get update && apt-get install -y \
    wget git build-essential ca-certificates \
    python3 python3-venv python3-pip golang \
 && rm -rf /var/lib/apt/lists/*

# 4️⃣ Install Go 1.20.5 (needed for Yggdrasil v0.5.5 build)
RUN wget https://golang.org/dl/go1.20.5.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.20.5.linux-amd64.tar.gz && \
    rm  go1.20.5.linux-amd64.tar.gz
ENV PATH="/usr/local/go/bin:${PATH}"

# 5️⃣ Python venv + NumPy
RUN python3 -m venv /opt/venv && \
    /opt/venv/bin/pip install --upgrade pip && \
    /opt/venv/bin/pip install numpy
ENV PATH="/opt/venv/bin:${PATH}"

# 6️⃣ Build Yggdrasil v0.5.5 from source (requires Go 1.20+)
RUN git clone https://github.com/yggdrasil-network/yggdrasil-go.git /opt/yggdrasil && \
    cd /opt/yggdrasil && \
    git checkout v0.5.5 && \
    go build -o yggdrasil ./cmd/yggdrasil && \
    cp yggdrasil /usr/local/bin/ && \
    chmod +x /usr/local/bin/yggdrasil && \
    rm -rf /opt/yggdrasil

# 7️⃣ App root
WORKDIR /opt/app
COPY . .

# 8️⃣ 🔥  PATCH zk_trust.circom (remove rogue line, trim leading blanks)
RUN sed -i '/poom/d' ZK/zk_trust.circom && \
    sed -i '1{/^$/d}' ZK/zk_trust.circom

# 9️⃣ Pre‑compile zk‑SNARK circuit
RUN circom ZK/zk_trust.circom --r1cs --wasm --sym -I ZK/circomlib/circuits

# 🔟 Boot command
CMD ["bash", "start.sh"]
