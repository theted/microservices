FROM debian:trixie-slim AS build
RUN apt-get update && apt-get install -y --no-install-recommends gcc libc6-dev make libgd-dev && rm -rf /var/lib/apt/lists/*
ADD --checksum=sha256:2ded856062abd73599e85e1e768ce6bc60ba2db22dc7d6a9b62763dca04b855a \
    https://www.bertnase.de/npiet/npiet-1.3f.tar.gz /tmp/npiet.tar.gz
RUN mkdir /npiet && tar -xzf /tmp/npiet.tar.gz -C /npiet --strip-components=1 \
    && cd /npiet && ./configure && make npiet

FROM debian:trixie-slim
RUN apt-get update && apt-get install -y --no-install-recommends libgd3 && rm -rf /var/lib/apt/lists/*
COPY --from=build /npiet/npiet /usr/local/bin/npiet
COPY --from=runner /runner /usr/local/bin/runner
COPY collatz.png /app/
# Each codel is drawn 20 pixels wide, so people can see it.
ENV STEP_CMD="npiet -q -cs 20 /app/collatz.png"
CMD ["runner"]
