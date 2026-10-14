FROM debian:trixie-slim
ADD --checksum=sha256:3d265c80d9d039ad92524f42951eb546d8b42c680965dfa551210457e399653f \
    https://github.com/RockstarLang/rockstar/releases/download/v2.0.31/rockstar-v2.0.31-linux-x64.tar.gz /tmp/rockstar.tar.gz
RUN tar -xzf /tmp/rockstar.tar.gz -C /opt && rm /tmp/rockstar.tar.gz
COPY collatz.rock /app/
COPY --from=runner /runner /usr/local/bin/runner
ENV STEP_CMD="/opt/rockstar-linux-x64-binary/rockstar /app/collatz.rock" DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1
CMD ["runner"]
