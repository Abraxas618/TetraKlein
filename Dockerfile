FROM node:18-slim

# Install circom and snarkjs
RUN npm install -g circom snarkjs

# Install build essentials, wget, python, venv
RUN apt-get update && apt-get install -y wget gnupg2 build-essential python3 python3-venv python3-pip

# Create Python venv and install numpy inside it
RUN python3 -m venv /opt/venv && \
    /opt/venv/bin/pip install --upgrade pip && \
    /opt/venv/bin/pip install numpy

# Install yggdrasil manually
RUN wget https://github.com/yggdrasil-network/yggdrasil-go/releases/download/v0.5.4/yggdrasil-0.5.4-linux-amd64.tar.gz && \
    tar -xvzf yggdrasil-0.5.4-linux-amd64.tar.gz && \
    cp yggdrasil /usr/local/bin/yggdrasil && chmod +x /usr/local/bin/yggdrasil

# Set environment variables to use local venv python
ENV PATH="/opt/venv/bin:$PATH"

# Create app directory
WORKDIR /opt/app

# Copy all project files
COPY . .

# Build zkSNARK proof environment
RUN circom zk_trust.circom --r1cs --wasm --sym

# Default command
CMD ["bash", "start.sh"]
