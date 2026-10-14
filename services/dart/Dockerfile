FROM dart:3.13 AS build
COPY collatz.dart /src/
RUN dart compile exe /src/collatz.dart -o /collatz

FROM debian:trixie-slim
COPY --from=runner /runner /usr/local/bin/runner
COPY --from=build /collatz /app/collatz
ENV STEP_CMD="/app/collatz"
CMD ["runner"]
