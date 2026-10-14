FROM debian:trixie-slim AS build
RUN apt-get update && apt-get install -y --no-install-recommends gcc libc6-dev make && rm -rf /var/lib/apt/lists/*
# mist64/cbmbasic: Commodore 64 BASIC V2, statically recompiled from the 6502 ROM to C.
ADD https://github.com/mist64/cbmbasic/archive/3b9e48d370241deded3bc3341ef7c8fc319bbb1f.tar.gz /cbmbasic.tar.gz
RUN mkdir /cbmbasic && tar -xzf /cbmbasic.tar.gz -C /cbmbasic --strip-components=1 \
    && make -C /cbmbasic

FROM debian:trixie-slim
RUN apt-get update && apt-get install -y --no-install-recommends socat && rm -rf /var/lib/apt/lists/*
COPY --from=build /cbmbasic/cbmbasic /usr/local/bin/cbmbasic
COPY collatz.bas /app/
COPY --from=shim . /shim/
ENV STEP_CMD="cbmbasic /app/collatz.bas"
CMD ["/shim/serve"]
