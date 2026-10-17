FROM debian:trixie-slim
RUN apt-get update && apt-get install -y --no-install-recommends maxima && rm -rf /var/lib/apt/lists/*
COPY --from=runner /runner /usr/local/bin/runner
COPY collatz.mac run.sh /app/
ENV STEP_CMD="/app/run.sh"
CMD ["runner"]
