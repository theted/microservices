FROM alpine:3.24 AS build
RUN apk add --no-cache nim gcc musl-dev
COPY collatz.nim /src/
RUN nim c -d:release --hints:off -o:/collatz /src/collatz.nim

FROM alpine:3.24
COPY --from=runner /runner /usr/local/bin/runner
COPY --from=build /collatz /app/collatz
ENV STEP_CMD="/app/collatz"
CMD ["runner"]
