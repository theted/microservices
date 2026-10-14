FROM debian:trixie-slim
RUN apt-get update && apt-get install -y --no-install-recommends beef && rm -rf /var/lib/apt/lists/*
COPY collatz.bf /app/
COPY --from=runner /runner /usr/local/bin/runner
ENV STEP_CMD="beef /app/collatz.bf"
CMD ["runner"]
