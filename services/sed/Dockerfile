FROM alpine:3.24
RUN apk add --no-cache sed
COPY collatz.sed /app/
COPY --from=runner /runner /usr/local/bin/runner
ENV STEP_CMD="sed -f /app/collatz.sed"
CMD ["runner"]
