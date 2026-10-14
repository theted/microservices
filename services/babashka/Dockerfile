FROM babashka/babashka:1.13.226-alpine
COPY --from=runner /runner /usr/local/bin/runner
COPY collatz.clj /app/
ENV STEP_CMD="bb /app/collatz.clj"
CMD ["runner"]
