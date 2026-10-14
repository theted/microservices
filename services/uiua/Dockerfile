FROM debian:trixie-slim
RUN apt-get update && apt-get install -y --no-install-recommends socat unzip && rm -rf /var/lib/apt/lists/*
ADD --checksum=sha256:c90e6aac694a7e26b0c02303bc20788fcbca816e0ee31ee2f69b1dfb50d316cd \
    https://github.com/uiua-lang/uiua/releases/download/0.19.1/uiua-bin-x86_64-unknown-linux-gnu-no-audio.zip /tmp/uiua.zip
RUN unzip -q /tmp/uiua.zip -d /usr/local/bin && chmod +x /usr/local/bin/uiua && rm /tmp/uiua.zip
COPY collatz.ua /app/
COPY --from=shim . /shim/
ENV STEP_CMD="uiua run --no-format /app/collatz.ua"
CMD ["/shim/serve"]
