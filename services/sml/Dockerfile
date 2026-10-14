FROM alpine:3.24
RUN apk add --no-cache polyml
COPY collatz.sml /app/
COPY --from=runner /runner /usr/local/bin/runner
ENV STEP_CMD="poly --script /app/collatz.sml"
CMD ["runner"]
