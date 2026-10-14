FROM perl:5.44-slim
COPY --from=runner /runner /usr/local/bin/runner
COPY collatz.pl /app/
ENV STEP_CMD="perl /app/collatz.pl"
CMD ["runner"]
