FROM debian:trixie-slim AS build
RUN apt-get update && apt-get install -y --no-install-recommends zstd ca-certificates && rm -rf /var/lib/apt/lists/*
ADD https://github.com/leanprover/lean4/releases/download/v4.35.0/lean-4.35.0-linux.tar.zst /tmp/lean.tar.zst
RUN mkdir /opt/lean && tar --zstd -xf /tmp/lean.tar.zst -C /opt/lean --strip-components=1 && rm /tmp/lean.tar.zst
COPY Collatz.lean /src/
RUN cd /src && /opt/lean/bin/lean -c Collatz.c Collatz.lean && /opt/lean/bin/leanc Collatz.c -o /collatz

FROM debian:trixie-slim
RUN apt-get update && apt-get install -y --no-install-recommends socat && rm -rf /var/lib/apt/lists/*
COPY --from=build /collatz /app/collatz
COPY --from=shim . /shim/
ENV STEP_CMD="/app/collatz"
CMD ["/shim/serve"]
