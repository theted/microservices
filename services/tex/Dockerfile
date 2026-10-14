FROM debian:trixie-slim
RUN apt-get update && apt-get install -y --no-install-recommends texlive-base && rm -rf /var/lib/apt/lists/*
COPY collatz.tex run.sh /app/
COPY --from=runner /runner /usr/local/bin/runner
ENV STEP_CMD="/app/run.sh"
CMD ["runner"]
