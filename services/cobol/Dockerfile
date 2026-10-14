FROM debian:trixie-slim
RUN apt-get update && apt-get install -y --no-install-recommends gnucobol3 && rm -rf /var/lib/apt/lists/*
COPY collatz.cob /app/
RUN cobc -x -o /app/collatz /app/collatz.cob
COPY --from=runner /runner /usr/local/bin/runner
ENV STEP_CMD="/app/collatz"
CMD ["runner"]
