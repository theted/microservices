FROM debian:trixie-slim AS build
RUN apt-get update && apt-get install -y --no-install-recommends gcc libc6-dev make && rm -rf /var/lib/apt/lists/*
# GNU marst translates ALGOL 60 to C.
ADD --checksum=sha256:3ee7b9d1cbe3cd9fb5f622717da7bb5506f1a6da3b30f812e2384b87bce4da50 \
    https://ftp.gnu.org/gnu/marst/marst-2.7.tar.gz /tmp/marst.tar.gz
RUN mkdir /marst && tar -xzf /tmp/marst.tar.gz -C /marst --strip-components=1 \
    && cd /marst && ./configure && make && make install
COPY collatz.alg /src/
RUN marst /src/collatz.alg -o /src/collatz.c && gcc -static /src/collatz.c -lalgol -lm -o /collatz

FROM debian:trixie-slim
COPY --from=runner /runner /usr/local/bin/runner
COPY --from=build /collatz /app/collatz
ENV STEP_CMD="/app/collatz"
CMD ["runner"]
