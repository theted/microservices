FROM debian:trixie-slim AS build
RUN apt-get update && apt-get install -y --no-install-recommends gcc libc6-dev make m4 && rm -rf /var/lib/apt/lists/*
ADD --checksum=sha256:702f73b4107438bd251ebc253d335994f37bb40379242360d876e2de6dc03f78 \
    https://ftp.regressive.org/snobol4/snobol4-2.3.4.tar.gz /tmp/snobol4.tar.gz
RUN mkdir /snobol4 && tar -xzf /tmp/snobol4.tar.gz -C /snobol4 --strip-components=1 \
    && cd /snobol4 && ./configure --prefix=/opt/snobol4 && make && make install

FROM debian:trixie-slim
COPY --from=build /opt/snobol4 /opt/snobol4
COPY --from=runner /runner /usr/local/bin/runner
COPY collatz.sno /app/
ENV STEP_CMD="/opt/snobol4/bin/snobol4 /app/collatz.sno"
CMD ["runner"]
