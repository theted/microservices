# J's libj.so asks for an executable stack, which trixie's glibc refuses.
FROM debian:bookworm-slim
ADD --checksum=sha256:e217a94ae6f4f979420ba2809c0373fb4cb8500c0441f83692ae24099813341b \
    https://www.jsoftware.com/download/j9.6/install/j9.6_linux64.tar.gz /tmp/j.tar.gz
RUN tar -xzf /tmp/j.tar.gz -C /opt && rm /tmp/j.tar.gz
COPY --from=runner /runner /usr/local/bin/runner
COPY collatz.ijs /app/
ENV STEP_CMD="/opt/j9.6/bin/jconsole /app/collatz.ijs"
CMD ["runner"]
