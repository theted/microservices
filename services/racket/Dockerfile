FROM alpine:3.24
RUN apk add --no-cache racket
COPY --from=runner /runner /usr/local/bin/runner
COPY collatz.rkt /app/
ENV STEP_CMD="racket /app/collatz.rkt"
CMD ["runner"]
