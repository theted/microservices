FROM alpine:3.24
RUN apk add --no-cache jq socat
COPY collatz.jq /app/
COPY --from=shim . /shim/
ENV STEP_CMD="jq -f /app/collatz.jq"
CMD ["/shim/serve"]
