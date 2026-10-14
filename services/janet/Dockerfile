FROM alpine:3.24
RUN apk add --no-cache janet
COPY --from=runner /runner /usr/local/bin/runner
COPY collatz.janet /app/
ENV STEP_CMD="janet /app/collatz.janet"
CMD ["runner"]
