# Use official lightweight node image
FROM node:18-slim

# Install circom and snarkjs
RUN npm install -g circom snarkjs

# Install yggdrasil manually
RUN apt-get update && apt-get install -y wget gnupg2 build-essential && \
    wget https://github.com/yggdrasil-network/yggdrasil-go/releases/download/v0.5.4/yggdrasil-0.5.4-linux-amd64.tar.gz && \
    tar -xvzf yggdrasil-0.5.4-linux-amd64.tar.gz && \
    cp yggdrasil /usr/local/bin/yggdrasil && chmod +x /usr/local/bin/yggdrasil

# Create app directory
WORKDIR /opt/app

# Copy all project files
COPY . .

# Build zkSNARK proof environment
RUN circom zk_trust.circom --r1cs --wasm --sym

# Default command
CMD ["bash", "start.sh"]
