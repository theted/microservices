# Dyalog APL is free for non-commercial use: https://www.dyalog.com/prices-and-licences.htm
FROM dyalog/dyalog:20.0
USER root
RUN apt-get update && apt-get install -y --no-install-recommends socat && rm -rf /var/lib/apt/lists/*
USER dyalog
COPY collatz.apls /app/
COPY --from=shim . /shim/
ENV STEP_CMD="dyalogscript /app/collatz.apls"
ENTRYPOINT []
CMD ["/shim/serve"]
