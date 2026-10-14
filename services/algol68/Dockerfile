FROM debian:trixie-slim
RUN apt-get update && apt-get install -y --no-install-recommends algol68g socat && rm -rf /var/lib/apt/lists/*
COPY collatz.a68 /app/
COPY --from=shim . /shim/
ENV STEP_CMD="a68g --quiet /app/collatz.a68"
CMD ["/shim/serve"]
