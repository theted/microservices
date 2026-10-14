FROM debian:trixie-slim
RUN apt-get update && apt-get install -y --no-install-recommends dc socat && rm -rf /var/lib/apt/lists/*
COPY collatz.dc /app/
COPY --from=shim . /shim/
ENV STEP_CMD="dc /app/collatz.dc"
CMD ["/shim/serve"]
