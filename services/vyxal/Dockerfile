FROM python:3.10-slim
RUN pip install --no-cache-dir vyxal==2.22.4.3
COPY --from=runner /runner /usr/local/bin/runner
COPY collatz.vy /app/
ENV STEP_CMD='vyxal /app/collatz.vy "" "$N"'
CMD ["runner"]
