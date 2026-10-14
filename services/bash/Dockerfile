FROM debian:trixie-slim
RUN apt-get update && apt-get install -y --no-install-recommends bash-builtins && rm -rf /var/lib/apt/lists/*
COPY collatz.bash /app/
CMD ["bash", "/app/collatz.bash"]
