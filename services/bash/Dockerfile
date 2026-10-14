FROM debian:trixie-slim
COPY --from=runner /runner /usr/local/bin/runner
COPY collatz.bash /app/
ENV STEP_CMD="bash /app/collatz.bash"
CMD ["runner"]
