#!/bin/sh
# Nova Sync Node — P2P sync to Oracle School main chain (20260619)
set -e

DATA_DIR=${DATA_DIR:-/sync/data}
NETWORK_ID=20260619
BOOTNODE="enode://977e5865fb597d1c30780c15eff2af222afa994d83bfc1a9e5c9c41f0491a9284e32fe43052e9014d809db94e2f38a85ccef857f87d470e060dc75d88d7fd4d2@141.11.156.4:30303"

echo "🔮 Nova Sync Node — Chain 20260619"
echo "   Bootnode: 141.11.156.4:30303"

# Init genesis
if [ ! -f "$DATA_DIR/geth/chaindata/CURRENT" ]; then
  echo "   Initializing genesis..."
  geth init --datadir "$DATA_DIR" /sync/genesis.json
  echo "   ✅ Genesis: edf353cfb2c9...242906"
fi

# Start geth in background
echo "   Starting Geth..."
geth   --datadir "$DATA_DIR"   --networkid $NETWORK_ID   --port 30303   --http --http.addr 0.0.0.0 --http.port 8545   --http.api eth,net,web3,admin   --http.corsdomain "*"   --authrpc.port 8552   --syncmode full   --nodiscover   --maxpeers 10 &
GETH_PID=$!

# Wait for HTTP RPC
echo "   Waiting for RPC..."
for i in $(seq 1 20); do
  if curl -s -X POST http://127.0.0.1:8545 -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","method":"net_listening","params":[],"id":1}' 2>/dev/null | grep -q true; then
    echo "   ✅ RPC ready"
    break
  fi
  sleep 1
done

# Add bootnode
echo "   Adding peer..."
curl -s -X POST http://127.0.0.1:8545   -H "Content-Type: application/json"   -d "{"jsonrpc":"2.0","method":"admin_addPeer","params":["$BOOTNODE"],"id":1}" > /dev/null
echo "   ✅ Peer added"

# Wait for sync
echo "   Syncing..."
sleep 10
BLOCK=$(curl -s -X POST http://127.0.0.1:8545 -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' 2>/dev/null | grep -o '"0x[0-9a-f]*"' | tr -d '"')
PEERS=$(curl -s -X POST http://127.0.0.1:8545 -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","method":"net_peerCount","params":[],"id":1}' 2>/dev/null | grep -o '"0x[0-9a-f]*"' | tr -d '"')

echo ""
echo "✅ Nova Sync Node LIVE"
echo "   Chain: 20260619"
echo "   Block: $BLOCK"
echo "   Peers: $PEERS"
echo "   RPC:   http://localhost:8545"
echo ""

# Keep container alive
wait $GETH_PID
