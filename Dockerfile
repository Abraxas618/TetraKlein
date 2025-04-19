# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃  TetraKlein Genesis • FINAL FAIL‑SAFE DOCKERFILE    ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

################ 1️⃣ BASE & TOOLING #####################
FROM node:18-slim
RUN npm install -g circom snarkjs          # Circom 2 / SnarkJS

# core utilities + dos2unix + Go & Python venv
RUN apt-get update && apt-get install -y \
        wget git build-essential ca-certificates \
        python3 python3-venv python3-pip golang dos2unix \
    && rm -rf /var/lib/apt/lists/* \
 && wget https://golang.org/dl/go1.20.5.linux-amd64.tar.gz \
 && tar -C /usr/local -xzf go1.20.5.linux-amd64.tar.gz \
 && rm  go1.20.5.linux-amd64.tar.gz
ENV PATH="/usr/local/go/bin:${PATH}"

# Python venv + NumPy
RUN python3 -m venv /opt/venv \
 && /opt/venv/bin/pip install --upgrade pip numpy
ENV PATH="/opt/venv/bin:${PATH}"

################ 2️⃣ BUILD YGGDRASIL ####################
RUN git clone https://github.com/yggdrasil-network/yggdrasil-go.git /opt/yggdrasil \
 && cd /opt/yggdrasil && git checkout v0.5.5 \
 && go build -o yggdrasil ./cmd/yggdrasil \
 && install -m755 yggdrasil /usr/local/bin/ \
 && rm -rf /opt/yggdrasil

################ 3️⃣ COPY PROJECT #######################
WORKDIR /opt/app
COPY . .

################ 4️⃣ PATCH & CONVERT ####################
# 1. convert CRLF to LF for both files
# 2. remove any rogue “poom” line
# 3. ensure compile.sh is executable
RUN dos2unix ZK/zk_trust.circom ZK/compile.sh \
 && sed -i '/poom/d' ZK/zk_trust.circom \
 && chmod +x ZK/compile.sh \
 && head -n 3 ZK/zk_trust.circom   # debug line (shows pragma+include)

################ 5️⃣ RUN PROVEN ZK PIPELINE #############
RUN cd ZK && ./compile.sh

################ 6️⃣ LAUNCH NODE ########################
CMD ["bash", "start.sh"]
