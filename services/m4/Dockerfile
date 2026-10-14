FROM alpine:3.24
RUN apk add --no-cache m4 socat
COPY collatz.m4 /app/
COPY --from=shim . /shim/
ENV STEP_CMD='m4 -DN="$N" /app/collatz.m4'
CMD ["/shim/serve"]
