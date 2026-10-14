FROM alpine:3.24
RUN apk add --no-cache wasmtime
COPY collatz.wat /app/
COPY --from=runner /runner /usr/local/bin/runner
ENV STEP_CMD='wasmtime run --invoke step /app/collatz.wat "$N"'
CMD ["runner"]
