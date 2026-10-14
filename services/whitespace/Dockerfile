FROM python:3.15-slim
RUN pip install --no-cache-dir whitespace==1.0.0b8
COPY collatz.ws /app/
COPY --from=runner /runner /usr/local/bin/runner
ENV STEP_CMD="whitespace /app/collatz.ws"
CMD ["runner"]
