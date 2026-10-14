FROM alpine:3.24 AS build
RUN apk add --no-cache ldc gcc musl-dev zlib-static
COPY collatz.d /src/
RUN ldc2 -O -static -of=/collatz /src/collatz.d

FROM alpine:3.24
COPY --from=runner /runner /usr/local/bin/runner
COPY --from=build /collatz /app/collatz
ENV STEP_CMD="/app/collatz"
CMD ["runner"]
