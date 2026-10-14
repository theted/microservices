FROM alpine:3.24
RUN apk add --no-cache sqlite
COPY --from=runner /runner /usr/local/bin/runner
COPY collatz.sql /app/
ENV STEP_CMD='sqlite3 -cmd ".parameter set :n $N" :memory: < /app/collatz.sql'
CMD ["runner"]
