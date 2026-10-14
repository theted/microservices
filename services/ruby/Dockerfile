FROM ruby:4.0-alpine
COPY --from=runner /runner /usr/local/bin/runner
COPY collatz.rb /app/
ENV STEP_CMD="ruby /app/collatz.rb"
CMD ["runner"]
