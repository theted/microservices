FROM alpine:3.24
RUN apk add --no-cache m4
COPY collatz.m4 /app/
COPY --from=runner /runner /usr/local/bin/runner
ENV STEP_CMD='m4 -DN="$N" /app/collatz.m4'
CMD ["runner"]
