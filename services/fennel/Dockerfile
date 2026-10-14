FROM alpine:3.24
RUN apk add --no-cache fennel lua5.4
COPY --from=runner /runner /usr/local/bin/runner
COPY collatz.fnl /app/
ENV STEP_CMD="fennel5.4 /app/collatz.fnl"
CMD ["runner"]
