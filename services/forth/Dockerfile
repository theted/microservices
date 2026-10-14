# gforth was dropped from Debian trixie; bookworm still ships it.
FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y --no-install-recommends gforth && rm -rf /var/lib/apt/lists/*
COPY collatz.fs /app/
COPY --from=runner /runner /usr/local/bin/runner
ENV STEP_CMD='gforth /app/collatz.fs -e "$N step . bye"'
CMD ["runner"]
