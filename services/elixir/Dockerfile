FROM elixir:1.20-alpine
COPY --from=runner /runner /usr/local/bin/runner
COPY collatz.exs /app/
ENV STEP_CMD="elixir /app/collatz.exs"
CMD ["runner"]
