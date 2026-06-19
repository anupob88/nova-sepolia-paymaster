# Nova P2P Sync Node — Docker
# Syncs to Oracle School main chain (20260619)
FROM ethereum/client-go:v1.13.15

WORKDIR /sync
COPY genesis.json /sync/genesis.json
COPY entrypoint.sh /sync/entrypoint.sh
RUN chmod +x /sync/entrypoint.sh

EXPOSE 8545 30303

ENTRYPOINT ["/sync/entrypoint.sh"]
