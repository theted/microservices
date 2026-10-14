FROM alpine:3.24
RUN apk add --no-cache rakudo
COPY --from=runner /runner /usr/local/bin/runner
COPY collatz.raku /app/
ENV STEP_CMD="rakudo /app/collatz.raku"
CMD ["runner"]
