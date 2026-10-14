# The last Emojicode release (2019) wants libtinfo5, which bookworm still has.
FROM debian:bookworm-slim AS build
RUN apt-get update && apt-get install -y --no-install-recommends g++ libtinfo5 && rm -rf /var/lib/apt/lists/*
ADD --checksum=sha256:c2e4a8ec156c198a80d844e747ce71c9d34efd54a2c5f3b6a116470d0cb8ef0f \
    https://github.com/emojicode/emojicode/releases/download/v1.0-beta.2/Emojicode-1.0-beta.2-Linux-x86_64.tar.gz /tmp/emojicode.tar.gz
RUN tar -xzf /tmp/emojicode.tar.gz -C /tmp && cd /tmp/Emojicode-1.0-beta.2-Linux-x86_64 \
    && cp emojicodec /usr/local/bin/ \
    && cp -r packages /usr/local/EmojicodePackages \
    && mkdir -p /usr/local/include && cp -r include /usr/local/include/emojicode
COPY collatz.🍇 /src/
RUN cd /src && emojicodec collatz.🍇

FROM debian:bookworm-slim
COPY --from=runner /runner /usr/local/bin/runner
COPY --from=build /src/collatz /app/collatz
ENV STEP_CMD="/app/collatz"
CMD ["runner"]
