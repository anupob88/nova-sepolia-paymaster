# Nova Oracle Chain — Chain ID 151205
# Runs Anvil L1 chain with ERC-4337 Paymaster pre-deployed
FROM ghcr.io/foundry-rs/foundry:latest

WORKDIR /chain
COPY . /chain

# Build all contracts
RUN forge build

# Expose Anvil RPC
EXPOSE 8545

# Start chain + deploy contracts
COPY entrypoint.sh /chain/entrypoint.sh
RUN chmod +x /chain/entrypoint.sh
ENTRYPOINT ["/chain/entrypoint.sh"]
