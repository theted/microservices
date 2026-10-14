FROM debian:trixie-slim
RUN apt-get update && apt-get install -y --no-install-recommends beef socat && rm -rf /var/lib/apt/lists/*
COPY collatz.bf /app/
COPY --from=shim . /shim/
ENV STEP_CMD="beef /app/collatz.bf"
CMD ["/shim/serve"]
