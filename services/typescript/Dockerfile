FROM oven/bun:1.4-alpine
COPY --from=runner /runner /usr/local/bin/runner
COPY collatz.ts /app/
ENV STEP_CMD="bun /app/collatz.ts"
CMD ["runner"]
