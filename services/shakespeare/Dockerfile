FROM python:3.15-slim
RUN apt-get update && apt-get install -y --no-install-recommends socat && rm -rf /var/lib/apt/lists/*
RUN pip install --no-cache-dir shakespearelang==1.0.0
COPY collatz.spl /app/
COPY --from=shim . /shim/
ENV STEP_CMD="shakespeare run /app/collatz.spl"
CMD ["/shim/serve"]
