FROM alpine:3.24
RUN apk add --no-cache sbcl
COPY --from=runner /runner /usr/local/bin/runner
COPY collatz.lisp /app/
ENV STEP_CMD="sbcl --script /app/collatz.lisp"
CMD ["runner"]
