# ─────────────────────────────────────────────────────────────
# 🛰️  TetraKlein Genesis – Final Proven Hardened Dockerfile
# ─────────────────────────────────────────────────────────────

# 1️⃣ Base NodeJS slim image
FROM node:18-slim

# 2️⃣ Circom and SnarkJS
RUN npm install -g circom snarkjs

# 3️⃣ System tools, Python venv, Go compiler
RUN apt-get update && apt-get install -y \
    wget git build-essential ca-certificates \
    python3 python3-venv python3-pip \
    golang \
 && rm -rf /var/lib/apt/lists/*

# 4️⃣ Install Go 1.20.5 manually
RUN wget https://golang.org/dl/go1.20.5.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.20.5.linux-amd64.tar.gz && \
    rm go1.20.5.linux-amd64.tar.gz
ENV PATH="/usr/local/go/bin:${PATH}"

# 5️⃣ Create Python venv + Install NumPy
RUN python3 -m venv /opt/venv && \
    /opt/venv/bin/pip install --upgrade pip && \
    /opt/venv/bin/pip install numpy
ENV PATH="/opt/venv/bin:$PATH"

# 6️⃣ Build Yggdrasil v0.5.5 from source
RUN git clone https://github.com/yggdrasil-network/yggdrasil-go.git /opt/yggdrasil && \
    cd /opt/yggdrasil && \
    git checkout v0.5.5 && \
    go build -o yggdrasil ./cmd/yggdrasil && \
    cp yggdrasil /usr/local/bin/ && \
    chmod +x /usr/local/bin/yggdrasil && \
    rm -rf /opt/yggdrasil

# 7️⃣ App workspace
WORKDIR /opt/app
COPY . .

# 🛑 **NO SED PATCHING**  
# 🛑 **NO circom pre-build at build time**  
# 🛑 **NO compile.sh during build**

# 🔟 Run-time final build using your working compile.sh
CMD ["bash", "-c", "cd ZK && chmod +x compile.sh && ./compile.sh && cd .. && bash start.sh"]
