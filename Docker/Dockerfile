# Use official lightweight node image
FROM node:18-slim

# Install circom and snarkjs
RUN npm install -g circom snarkjs

# Create app directory
WORKDIR /opt/app

# Copy all necessary project files
COPY . .

# Build the proof environment
RUN circom zk_trust.circom --r1cs --wasm --sym

# Default command: Run proof generation script
CMD ["bash", "run_zk_trust_proof.sh"]
