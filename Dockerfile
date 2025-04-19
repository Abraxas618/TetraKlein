# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃    TETRAKLEIN GENESIS • FINAL FUTURE‑PROOF DOCKERFILE ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

######## 1️⃣ BASE IMAGE + CIRCOM / SNARKJS ################
FROM node:18-slim
RUN npm install -g circom snarkjs

######## 2️⃣ CORE TOOLS, GO 1.20.5, PYTHON VENV ##########
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

######## 3️⃣ BUILD YGGDRASIL v0.5.5 FROM SOURCE ###########
RUN git clone https://github.com/yggdrasil-network/yggdrasil-go.git /opt/yggdrasil \
 && cd /opt/yggdrasil \
 && git checkout v0.5.5 \
 && go build -o yggdrasil ./cmd/yggdrasil \
 && install -m755 yggdrasil /usr/local/bin/ \
 && rm -rf /opt/yggdrasil

######## 4️⃣ COPY PROJECT #################################
WORKDIR /opt/app
COPY . .

######## 5️⃣ ZK PATCH & LINE‑ENDING CONVERSION ############
#  • delete rogue “poom” line if present
#  • convert CRLF → LF to avoid line‑merge parse errors
#  • ensure compile.sh is executable
RUN sed -i '/poom/d' ZK/zk_trust.circom \
 && dos2unix ZK/zk_trust.circom ZK/compile.sh \
 && chmod +x ZK/compile.sh

######## 6️⃣ RUN PROVEN ZK PIPELINE #######################
RUN cd ZK && ./compile.sh

######## 7️⃣ LAUNCH SOVEREIGN NODE ########################
CMD ["bash", "start.sh"]
