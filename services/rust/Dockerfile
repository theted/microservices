FROM rust:1.99-alpine AS build
COPY collatz.rs /src/
RUN rustc -C opt-level=3 -o /collatz /src/collatz.rs

FROM alpine:3.24
COPY --from=runner /runner /usr/local/bin/runner
COPY --from=build /collatz /app/collatz
ENV STEP_CMD="/app/collatz"
CMD ["runner"]
