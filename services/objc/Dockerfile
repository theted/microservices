FROM debian:trixie-slim AS build
RUN apt-get update && apt-get install -y --no-install-recommends gobjc && rm -rf /var/lib/apt/lists/*
COPY collatz.m /src/
RUN gcc -O2 -static /src/collatz.m -lobjc -o /collatz

FROM debian:trixie-slim
COPY --from=runner /runner /usr/local/bin/runner
COPY --from=build /collatz /app/collatz
ENV STEP_CMD="/app/collatz"
CMD ["runner"]
