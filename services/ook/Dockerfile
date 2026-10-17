FROM perl:5.44-slim
RUN apt-get update && apt-get install -y --no-install-recommends make && rm -rf /var/lib/apt/lists/*
RUN cpanm --notest Acme::Ook
COPY --from=runner /runner /usr/local/bin/runner
COPY collatz.ook /app/
ENV STEP_CMD="ook /app/collatz.ook"
CMD ["runner"]
