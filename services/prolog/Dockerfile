FROM swipl:10.1.18
COPY --from=runner /runner /usr/local/bin/runner
COPY collatz.pl /app/
ENV STEP_CMD="swipl /app/collatz.pl"
CMD ["runner"]
