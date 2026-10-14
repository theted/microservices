FROM erlang:29-alpine
COPY --from=runner /runner /usr/local/bin/runner
COPY collatz.escript /app/
ENV STEP_CMD="escript /app/collatz.escript"
CMD ["runner"]
