# Dyalog APL is free for non-commercial use: https://www.dyalog.com/prices-and-licences.htm
FROM dyalog/dyalog:20.0
COPY collatz.apls /app/
COPY --from=runner /runner /usr/local/bin/runner
ENV STEP_CMD="dyalogscript /app/collatz.apls"
ENTRYPOINT []
CMD ["runner"]
