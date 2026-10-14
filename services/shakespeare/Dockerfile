FROM python:3.15-slim
RUN pip install --no-cache-dir shakespearelang==1.0.0
COPY collatz.spl /app/
COPY --from=runner /runner /usr/local/bin/runner
ENV STEP_CMD="shakespeare run /app/collatz.spl"
CMD ["runner"]
