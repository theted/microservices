FROM ruby:4.0-alpine
# The original 2008 interpreter, which still runs on Ruby 4.
ADD --checksum=sha256:c88159fc65b422ae7f84b07f520b32feae3f3a6240524b9f64e0bd30050f74ad \
    http://www.golfscript.com/golfscript/golfscript.rb /opt/golfscript.rb
COPY --from=runner /runner /usr/local/bin/runner
COPY collatz.gs /app/
ENV STEP_CMD="ruby /opt/golfscript.rb /app/collatz.gs"
CMD ["runner"]
