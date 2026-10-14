FROM debian:trixie-slim
RUN apt-get update && apt-get install -y --no-install-recommends regina-rexx socat && rm -rf /var/lib/apt/lists/*
COPY collatz.rexx /app/
COPY --from=shim . /shim/
ENV STEP_CMD="regina /app/collatz.rexx"
CMD ["/shim/serve"]
