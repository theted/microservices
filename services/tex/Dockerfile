FROM debian:trixie-slim
RUN apt-get update && apt-get install -y --no-install-recommends texlive-base socat && rm -rf /var/lib/apt/lists/*
COPY collatz.tex run.sh /app/
COPY --from=shim . /shim/
ENV STEP_CMD="/app/run.sh"
CMD ["/shim/serve"]
