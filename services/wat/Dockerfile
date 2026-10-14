FROM alpine:3.24
RUN apk add --no-cache wasmtime socat
COPY collatz.wat /app/
COPY --from=shim . /shim/
ENV STEP_CMD='wasmtime run --invoke step /app/collatz.wat "$N"'
CMD ["/shim/serve"]
