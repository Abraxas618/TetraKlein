FROM node:18-slim

RUN apt-get update && apt-get install -y \
    wget git build-essential curl libgmp-dev ca-certificates \
    python3 python3-venv python3-pip golang \
 && rm -rf /var/lib/apt/lists/*

# Install Rust (for Circom build)
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Build Circom 2.1.5 using cargo (Rust)
RUN git clone https://github.com/iden3/circom.git /opt/circom && \
    cd /opt/circom && \
    git checkout v2.1.5 && \
    cargo build --release && \
    cp target/release/circom /usr/local/bin/

# Correct Go Install
RUN wget https://golang.org/dl/go1.20.5.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.20.5.linux-amd64.tar.gz && \
    rm go1.20.5.linux-amd64.tar.gz
ENV PATH="/usr/local/go/bin:${PATH}"


# Setup Python venv
RUN python3 -m venv /opt/venv && \
    /opt/venv/bin/pip install --upgrade pip && \
    /opt/venv/bin/pip install numpy
ENV PATH="/opt/venv/bin:$PATH"

# Build Yggdrasil
RUN git clone https://github.com/yggdrasil-network/yggdrasil-go.git /opt/yggdrasil && \
    cd /opt/yggdrasil && \
    git checkout v0.5.5 && \
    go build -o yggdrasil ./cmd/yggdrasil && \
    cp yggdrasil /usr/local/bin/ && \
    chmod +x /usr/local/bin/yggdrasil && \
    rm -rf /opt/yggdrasil

# App workspace
WORKDIR /opt/app

COPY . .

COPY ./ZK/zk_trust.circom ./ZK/zk_trust.circom

CMD ["bash", "-c", "cd ZK && chmod +x compile.sh && ./compile.sh && cd .. && bash start.sh"]
