FROM debian:trixie-slim AS build
RUN apt-get update && apt-get install -y --no-install-recommends cc65 && rm -rf /var/lib/apt/lists/*
COPY collatz.s /src/
# sim6502 is cc65's simulator target: read() and write() reach the host.
RUN ca65 /src/collatz.s -o /src/collatz.o && ld65 -t sim6502 /src/collatz.o sim6502.lib -o /collatz

FROM debian:trixie-slim
COPY --from=build /usr/bin/sim65 /usr/local/bin/sim65
COPY --from=runner /runner /usr/local/bin/runner
COPY --from=build /collatz /app/collatz
ENV STEP_CMD="sim65 /app/collatz"
CMD ["runner"]
