FROM python:3.15-slim
RUN apt-get update && apt-get install -y --no-install-recommends socat && rm -rf /var/lib/apt/lists/*
RUN pip install --no-cache-dir whitespace==1.0.0b8
COPY collatz.ws /app/
COPY --from=shim . /shim/
ENV STEP_CMD="whitespace /app/collatz.ws"
CMD ["/shim/serve"]
