FROM alpine:3.24
RUN apk add --no-cache emacs-nox
COPY --from=runner /runner /usr/local/bin/runner
COPY collatz.el /app/
ENV STEP_CMD="emacs -Q --batch -l /app/collatz.el"
CMD ["runner"]
