FROM python:3.10-slim
RUN apt-get update && apt-get install -y --no-install-recommends git && rm -rf /var/lib/apt/lists/*
RUN pip install --no-cache-dir git+https://github.com/DennisMitchell/jellylanguage@70c9fd93ab009c05dc396f8cc091f72b212fb188
COPY --from=runner /runner /usr/local/bin/runner
COPY collatz.jelly /app/
ENV STEP_CMD='jelly fu /app/collatz.jelly "$N"'
CMD ["runner"]
