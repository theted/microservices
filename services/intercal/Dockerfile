FROM debian:trixie-slim
RUN apt-get update && apt-get install -y --no-install-recommends intercal gcc libc6-dev gawk \
    && rm -rf /var/lib/apt/lists/*
COPY collatz.i run.sh /app/
RUN cd /app && ick collatz.i
COPY --from=runner /runner /usr/local/bin/runner
ENV STEP_CMD="/app/run.sh"
CMD ["runner"]
