# ────────────────────────────────────────────────
# 🛰️ TetraKlein Genesis – Final Hardened Dockerfile
# ────────────────────────────────────────────────

FROM node:18-slim

# 1️⃣ Install system dependencies
RUN apt-get update && apt-get install -y \
    wget git build-essential curl libgmp-dev ca-certificates \
    python3 python3-venv python3-pip golang \
 && rm -rf /var/lib/apt/lists/*

# 2️⃣ Install Rust toolchain (for Circom build)
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# 3️⃣ Clone and Build Circom 2.1.5 (correct Cargo method)
RUN git clone https://github.com/iden3/circom.git /opt/circom && \
    cd /opt/circom && \
    git checkout v2.1.5 && \
    cargo build --release && \
    cp target/release/circom /usr/local/bin/

# 4️⃣ Install snarkjs globally (needed for trusted setup)
RUN npm install -g snarkjs

# 5️⃣ Install Go 1.20.5 (for Yggdrasil build)
RUN wget https://golang.org/dl/go1.20.5.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.20.5.linux-amd64.tar.gz && \
    rm go1.20.5.linux-amd64.tar.gz
ENV PATH="/usr/local/go/bin:${PATH}"

# 6️⃣ Setup Python venv and install numpy
RUN python3 -m venv /opt/venv && \
    /opt/venv/bin/pip install --upgrade pip && \
    /opt/venv/bin/pip install numpy
ENV PATH="/opt/venv/bin:$PATH"

# 7️⃣ Clone and Build Yggdrasil v0.5.5
RUN git clone https://github.com/yggdrasil-network/yggdrasil-go.git /opt/yggdrasil && \
    cd /opt/yggdrasil && \
    git checkout v0.5.5 && \
    go build -o yggdrasil ./cmd/yggdrasil && \
    cp yggdrasil /usr/local/bin/ && \
    chmod +x /usr/local/bin/yggdrasil && \
    rm -rf /opt/yggdrasil

# 8️⃣ Generate a fresh Yggdrasil configuration
RUN mkdir -p /etc/yggdrasil && \
    yggdrasil -genconf > /etc/yggdrasil/yggdrasil.conf

# 9️⃣ Set working directory for app
WORKDIR /opt/app

# 🔟 Copy full project into container
COPY . .

# 1️⃣1️⃣ Ensure zk_proof runner is executable
COPY ./run_zk_trust_proof.sh ./run_zk_trust_proof.sh
RUN chmod +x run_zk_trust_proof.sh

# 1️⃣2️⃣ Force overwrite clean zk_trust.circom
COPY ./ZK/zk_trust.circom ./ZK/zk_trust.circom

# 1️⃣3️⃣ Sovereign Runtime Command
CMD ["bash", "-c", "cd ZK && chmod +x compile.sh && ./compile.sh && cd .. && bash start.sh"]
