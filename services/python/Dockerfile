FROM python:3.15-slim
COPY --from=runner /runner /usr/local/bin/runner
COPY collatz.py /app/
ENV STEP_CMD="python3 /app/collatz.py"
CMD ["runner"]
