#!/bin/sh
# Nova Oracle Chain Entrypoint
# Chain ID: 151205 — derived from Oracle School guild ID
# Spins up Anvil L1, deploys ERC-4337 EntryPoint + TokenPaymaster

set -e

CHAIN_ID=${CHAIN_ID:-151205}
ANVIL_PORT=${ANVIL_PORT:-8545}
ANVIL_HOST="0.0.0.0"

echo "🔮 Nova Oracle Chain — Starting..."
echo "   Chain ID: $CHAIN_ID"
echo "   Port:     $ANVIL_PORT"
echo "   Host:     $ANVIL_HOST"

# Start Anvil in background
anvil \
  --host "$ANVIL_HOST" \
  --port "$ANVIL_PORT" \
  --chain-id "$CHAIN_ID" \
  --block-time 2 \
  --accounts 10 \
  --balance 10000 \
  > /tmp/anvil.log 2>&1 &

ANVIL_PID=$!
echo "   Anvil PID: $ANVIL_PID"

# Wait for Anvil RPC to be ready
echo "   Waiting for Anvil RPC..."
for i in $(seq 1 30); do
  if curl -s "http://127.0.0.1:$ANVIL_PORT" -X POST \
    -H "Content-Type: application/json" \
    -d '{"jsonrpc":"2.0","method":"eth_chainId","params":[],"id":1}' 2>/dev/null | grep -q "0x"; then
    echo "   ✅ Anvil RPC ready"
    break
  fi
  sleep 1
done

# Deploy contracts via Foundry script
if [ -f "script/DeployPaymaster.s.sol" ]; then
  echo "   🚀 Deploying ERC-4337 contracts..."

  export PRIVATE_KEY="0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80"

  forge script script/DeployPaymaster.s.sol \
    --rpc-url "http://127.0.0.1:$ANVIL_PORT" \
    --broadcast \
    --private-key "$PRIVATE_KEY" 2>&1 | tail -5

  echo "   ✅ Contracts deployed"
fi

echo ""
echo "🔮 Nova Chain $CHAIN_ID is LIVE on port $ANVIL_PORT"
echo "   RPC: http://$ANVIL_HOST:$ANVIL_PORT"
echo "   Chain ID: $CHAIN_ID"
echo ""

# Keep container alive
tail -f /tmp/anvil.log
