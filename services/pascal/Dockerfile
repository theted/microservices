FROM debian:trixie-slim AS build
RUN apt-get update && apt-get install -y --no-install-recommends fp-compiler && rm -rf /var/lib/apt/lists/*
COPY collatz.pas /src/
RUN fpc -O2 -o/collatz /src/collatz.pas

FROM alpine:3.24
RUN apk add --no-cache socat
COPY --from=build /collatz /app/collatz
COPY --from=shim . /shim/
ENV STEP_CMD="/app/collatz"
CMD ["/shim/serve"]
