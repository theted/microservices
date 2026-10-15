FROM debian:trixie-slim
ADD --checksum=sha256:567239b0b5fe4222d26bb871ad4c6b6f00f7dc885e149191d4fef7197e280551 \
    https://github.com/factor/factor/releases/download/0.102/factor-linux-x86-64-0.102.tar.gz /tmp/factor.tar.gz
RUN tar -xzf /tmp/factor.tar.gz -C /opt && rm /tmp/factor.tar.gz
COPY --from=runner /runner /usr/local/bin/runner
COPY collatz.factor /app/
ENV STEP_CMD="/opt/factor/factor /app/collatz.factor"
CMD ["runner"]
