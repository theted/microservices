# Debian's ucblogo is built with a wxWidgets GUI and refuses to start without a
# display, so this builds the same 6.2.5 release with the graphics left out.
FROM debian:trixie-slim AS build
RUN apt-get update && apt-get install -y --no-install-recommends gcc g++ libc6-dev make libncurses-dev texinfo \
    && rm -rf /var/lib/apt/lists/*
ADD --checksum=sha256:8f4033a79c95efd0d4d2fb257b1f45dd7ba33cf7a2c8d942c29b5467ce31a4fa \
    https://github.com/jrincayc/ucblogo-code/releases/download/version_6.2.5/ucblogo-6.2.5.tar.gz /tmp/ucblogo.tar.gz
RUN mkdir /ucblogo && tar -xzf /tmp/ucblogo.tar.gz -C /ucblogo --strip-components=1 \
    && cd /ucblogo && ./configure --disable-wx --prefix=/opt/ucblogo && make && make install

FROM debian:trixie-slim
RUN apt-get update && apt-get install -y --no-install-recommends libtinfo6 && rm -rf /var/lib/apt/lists/*
COPY --from=build /opt/ucblogo /opt/ucblogo
COPY collatz.lg /app/
COPY --from=runner /runner /usr/local/bin/runner
ENV TERM=dumb STEP_CMD="/opt/ucblogo/bin/ucblogo /app/collatz.lg"
CMD ["runner"]
