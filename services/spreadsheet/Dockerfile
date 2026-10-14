FROM debian:trixie-slim
RUN apt-get update && apt-get install -y --no-install-recommends libreoffice-calc-nogui socat && rm -rf /var/lib/apt/lists/*
COPY collatz.fods run.sh /app/
# Warm up a profile at build time, so the first request doesn't pay for it.
RUN N=27 /app/run.sh
COPY --from=shim . /shim/
ENV STEP_CMD="/app/run.sh" STEP_TIMEOUT=20
CMD ["/shim/serve"]
