FROM alpine:3.24
RUN apk add --no-cache guile
COPY --from=runner /runner /usr/local/bin/runner
COPY collatz.scm /app/
ENV STEP_CMD="guile --no-auto-compile -s /app/collatz.scm"
CMD ["runner"]
