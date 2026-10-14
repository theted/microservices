FROM alpine:3.24 AS build
RUN apk add --no-cache nim gcc musl-dev
COPY collatz.nim /src/
RUN nim c -d:release --hints:off --passL:-static -o:/collatz /src/collatz.nim

FROM scratch
COPY --from=build /collatz /collatz
ENTRYPOINT ["/collatz"]
