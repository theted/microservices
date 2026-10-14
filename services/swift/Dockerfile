FROM swift:6.4-trixie AS build
COPY collatz.swift /src/
RUN swiftc -O -static-stdlib -o /collatz /src/collatz.swift

FROM debian:trixie-slim
RUN apt-get update && apt-get install -y --no-install-recommends libstdc++6 && rm -rf /var/lib/apt/lists/*
COPY --from=build /collatz /app/collatz
COPY --from=runner /runner /usr/local/bin/runner
ENV STEP_CMD="/app/collatz"
CMD ["runner"]
