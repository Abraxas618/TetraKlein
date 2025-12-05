# ───────────────────────────────────────────────────────────
# TetraKlein Genesis Node – Dockerfile v2.2
# Clean, deterministic, reproducible, build-stable
# ───────────────────────────────────────────────────────────

FROM node:20-slim

# ------------------------------------------------------------
# 1. System Dependencies
# ------------------------------------------------------------
RUN apt-get update && apt-get install -y \
    git wget curl build-essential python3 python3-pip python3-venv \
    golang libgmp-dev ca-certificates \
 && rm -rf /var/lib/apt/lists/*

# ------------------------------------------------------------
# 2. Rust Toolchain (for Circom build)
# ------------------------------------------------------------
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# ------------------------------------------------------------
# 3. Go 1.22.2 (Yggdrasil dependency)
# ------------------------------------------------------------
RUN wget https://golang.org/dl/go1.22.2.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.22.2.linux-amd64.tar.gz && \
    rm go1.22.2.linux-amd64.tar.gz
ENV PATH="/usr/local/go/bin:${PATH}"

# ------------------------------------------------------------
# 4. Build Circom 2.1.9
# ------------------------------------------------------------
RUN git clone https://github.com/iden3/circom.git /opt/circom && \
    cd /opt/circom && git checkout v2.1.9 && \
    cargo build --release && \
    cp target/release/circom /usr/local/bin && \
    rm -rf /opt/circom

# ------------------------------------------------------------
# 5. Install snarkjs
# ------------------------------------------------------------
RUN npm install -g snarkjs@0.7.5

# ------------------------------------------------------------
# 6. Python Virtual Environment + Dependencies
# ------------------------------------------------------------
RUN python3 -m venv /opt/venv && \
    /opt/venv/bin/pip install --upgrade pip && \
    /opt/venv/bin/pip install numpy pynacl
ENV PATH="/opt/venv/bin:${PATH}"

# ------------------------------------------------------------
# 7. Build Yggdrasil v0.5.5
# ------------------------------------------------------------
RUN git clone https://github.com/yggdrasil-network/yggdrasil-go.git /opt/ygg && \
    cd /opt/ygg && git checkout v0.5.5 && \
    go build -o yggdrasil ./cmd/yggdrasil && \
    mv yggdrasil /usr/local/bin && \
    chmod +x /usr/local/bin/yggdrasil && \
    rm -rf /opt/ygg

# ------------------------------------------------------------
# 8. Generate Default Yggdrasil Configuration
# ------------------------------------------------------------
RUN mkdir -p /etc/yggdrasil && \
    yggdrasil -genconf > /etc/yggdrasil/yggdrasil.conf

# ------------------------------------------------------------
# 9. App Directory
# ------------------------------------------------------------
WORKDIR /opt/app
RUN mkdir -p /data

# ------------------------------------------------------------
# 10. Copy Entire TetraKlein Project
# ------------------------------------------------------------
COPY . .

# ------------------------------------------------------------
# 11. Permissions Fix
# ------------------------------------------------------------
RUN chmod +x start.sh && \
    chmod +x run_zk_trust_proof.sh

# ------------------------------------------------------------
# 12. Deterministic Entrypoint
# ------------------------------------------------------------
CMD ["bash", "start.sh"]
