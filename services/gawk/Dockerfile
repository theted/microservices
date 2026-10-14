FROM alpine:3.24
RUN apk add --no-cache gawk
COPY --from=runner /runner /usr/local/bin/runner
COPY collatz.awk /app/
ENV STEP_CMD="gawk -f /app/collatz.awk"
CMD ["runner"]
