FROM debian:trixie-slim
RUN apt-get update && apt-get install -y --no-install-recommends dc && rm -rf /var/lib/apt/lists/*
COPY collatz.dc /app/
COPY --from=runner /runner /usr/local/bin/runner
ENV STEP_CMD="dc /app/collatz.dc"
CMD ["runner"]
