FROM debian:trixie-slim
RUN apt-get update && apt-get install -y --no-install-recommends gnucobol3 socat && rm -rf /var/lib/apt/lists/*
COPY collatz.cob /app/
RUN cobc -x -o /app/collatz /app/collatz.cob
COPY --from=shim . /shim/
ENV STEP_CMD="/app/collatz"
CMD ["/shim/serve"]
