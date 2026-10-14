FROM alpine:3.24
RUN apk add --no-cache hy
COPY --from=runner /runner /usr/local/bin/runner
COPY collatz.hy /app/
ENV STEP_CMD="hy /app/collatz.hy"
CMD ["runner"]
