FROM debian:trixie-slim
RUN apt-get update && apt-get install -y --no-install-recommends regina-rexx && rm -rf /var/lib/apt/lists/*
COPY collatz.rexx /app/
COPY --from=runner /runner /usr/local/bin/runner
ENV STEP_CMD="regina /app/collatz.rexx"
CMD ["runner"]
