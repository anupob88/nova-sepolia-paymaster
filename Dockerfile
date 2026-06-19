FROM ghcr.io/foundry-rs/foundry:nightly

WORKDIR /app
COPY . .

RUN forge build

ENTRYPOINT ["anvil", "--host", "0.0.0.0"]
