FROM node:26-alpine
WORKDIR /app
RUN npm install --no-fund --no-audit befunge93@1.0.5
COPY collatz.bf93 run.js /app/
COPY --from=runner /runner /usr/local/bin/runner
ENV STEP_CMD="node /app/run.js /app/collatz.bf93"
CMD ["runner"]
