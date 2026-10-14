FROM alpine:3.24
RUN apk add --no-cache jq
COPY collatz.jq /app/
COPY --from=runner /runner /usr/local/bin/runner
ENV STEP_CMD="jq -f /app/collatz.jq"
CMD ["runner"]
