FROM debian:trixie-slim
RUN apt-get update && apt-get install -y --no-install-recommends algol68g && rm -rf /var/lib/apt/lists/*
COPY collatz.a68 /app/
COPY --from=runner /runner /usr/local/bin/runner
ENV STEP_CMD="a68g --quiet /app/collatz.a68"
CMD ["runner"]
