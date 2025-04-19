# ─────────────────────────────────────────────────────────────
# 🛰️  TetraKlein Genesis – Dockerfile (compile.sh pipeline)
# ─────────────────────────────────────────────────────────────

## 1️⃣  Base NodeJS + Circom + SnarkJS
FROM node:18-slim
RUN npm install -g circom snarkjs

## 2️⃣  System tools, Python venv, Go 1.20.x (for Yggdrasil build)
RUN apt-get update && apt-get install -y \
        wget git build-essential ca-certificates \
        python3 python3-venv python3-pip golang \
    && rm -rf /var/lib/apt/lists/* \
 && wget https://golang.org/dl/go1.20.5.linux-amd64.tar.gz \
 && tar -C /usr/local -xzf go1.20.5.linux-amd64.tar.gz \
 && rm  go1.20.5.linux-amd64.tar.gz
ENV PATH="/usr/local/go/bin:${PATH}"

## 3️⃣  Python venv + NumPy
RUN python3 -m venv /opt/venv \
 && /opt/venv/bin/pip install --upgrade pip numpy
ENV PATH="/opt/venv/bin:${PATH}"

## 4️⃣  Build Yggdrasil v0.5.5 from source
RUN git clone https://github.com/yggdrasil-network/yggdrasil-go.git /opt/yggdrasil \
 && cd /opt/yggdrasil && git checkout v0.5.5 \
 && go build -o yggdrasil ./cmd/yggdrasil \
 && install -m755 yggdrasil /usr/local/bin/ \
 && rm -rf /opt/yggdrasil

## 5️⃣  Copy project
WORKDIR /opt/app
COPY . .

## 6️⃣  🔥  PATCH rogue “poom” line & make compile.sh executable
RUN sed -i '/poom/d' ZK/zk_trust.circom \
 && chmod +x ZK/compile.sh

## 7️⃣  Run full zk pipeline via compile.sh (already verified)
RUN cd ZK && ./compile.sh

## 8️⃣  Launch Sovereign Node
CMD ["bash", "start.sh"]
