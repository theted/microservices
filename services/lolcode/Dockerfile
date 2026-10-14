FROM debian:trixie-slim AS build
RUN apt-get update && apt-get install -y --no-install-recommends gcc g++ libc6-dev cmake make && rm -rf /var/lib/apt/lists/*
# justinmeza/lci, the LOLCODE 1.2 interpreter (main branch).
ADD https://github.com/justinmeza/lci/archive/0b32ed1cc52abd1971d199db9bd77c387316cae1.tar.gz /lci.tar.gz
RUN mkdir /lci && tar -xzf /lci.tar.gz -C /lci --strip-components=1 \
    && cd /lci && cmake . && make lci

FROM debian:trixie-slim
COPY --from=build /lci/lci /usr/local/bin/lci
COPY collatz.lol /app/
COPY --from=runner /runner /usr/local/bin/runner
ENV STEP_CMD="lci /app/collatz.lol"
CMD ["runner"]
