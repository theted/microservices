FROM alpine:3.24
RUN apk add --no-cache sed socat
COPY collatz.sed /app/
COPY --from=shim . /shim/
ENV STEP_CMD="sed -f /app/collatz.sed"
CMD ["/shim/serve"]
