FROM node:26-alpine
COPY --from=runner /runner /usr/local/bin/runner
COPY collatz.js /app/
ENV STEP_CMD="node /app/collatz.js"
CMD ["runner"]
