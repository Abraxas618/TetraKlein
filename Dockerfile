# ───────────────────────────────────────────────────────────
# 🛰️ TetraKlein Genesis Node - Sovereign Hardened Dockerfile v2.0
# ───────────────────────────────────────────────────────────

# 1️⃣ Pull latest Node.js 20.x base
FROM node:20-slim

# 2️⃣ Install system dependencies
RUN apt-get update && apt-get install -y \
    wget git build-essential curl libgmp-dev ca-certificates \
    python3 python3-venv python3-pip golang \
 && rm -rf /var/lib/apt/lists/*

# 3️⃣ Install Rust toolchain (for Circom build)
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# 4️⃣ Install Go 1.22.2 (latest stable)
RUN wget https://golang.org/dl/go1.22.2.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.22.2.linux-amd64.tar.gz && \
    rm go1.22.2.linux-amd64.tar.gz
ENV PATH="/usr/local/go/bin:${PATH}"

# 5️⃣ Clone and Build Circom 2.1.9
RUN git clone https://github.com/iden3/circom.git /opt/circom && \
    cd /opt/circom && \
    git checkout v2.1.9 && \
    cargo build --release && \
    cp target/release/circom /usr/local/bin/

# 6️⃣ Install snarkjs 0.7.5 globally
RUN npm install -g snarkjs@0.7.5


# 7️⃣ Setup Python venv and install numpy
RUN python3 -m venv /opt/venv && \
    /opt/venv/bin/pip install --upgrade pip && \
    /opt/venv/bin/pip install numpy
ENV PATH="/opt/venv/bin:$PATH"

# 8️⃣ Clone and Build Yggdrasil v0.5.5 (no change)
RUN git clone https://github.com/yggdrasil-network/yggdrasil-go.git /opt/yggdrasil && \
    cd /opt/yggdrasil && \
    git checkout v0.5.5 && \
    go build -o yggdrasil ./cmd/yggdrasil && \
    cp yggdrasil /usr/local/bin/ && \
    chmod +x /usr/local/bin/yggdrasil && \
    rm -rf /opt/yggdrasil

# 9️⃣ Generate a fresh Yggdrasil configuration
RUN mkdir -p /etc/yggdrasil && \
    yggdrasil -genconf > /etc/yggdrasil/yggdrasil.conf

# 🔟 Set working directory for app
WORKDIR /opt/app

# 1️⃣1️⃣ Copy full project into container
COPY . .

# 1️⃣2️⃣ Ensure zk_proof runner is executable
COPY ./run_zk_trust_proof.sh ./run_zk_trust_proof.sh
RUN chmod +x run_zk_trust_proof.sh

# 1️⃣3️⃣ Force overwrite clean zk_trust.circom
COPY ./ZK/zk_trust.circom ./ZK/zk_trust.circom

# 1️⃣4️⃣ Sovereign Runtime Command
CMD ["bash", "-c", "cd ZK && chmod +x compile.sh && ./compile.sh && cd .. && bash start.sh"]
