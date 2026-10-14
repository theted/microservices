FROM php:8.5-cli-alpine
COPY --from=runner /runner /usr/local/bin/runner
COPY collatz.php /app/
ENV STEP_CMD="php /app/collatz.php"
CMD ["runner"]
