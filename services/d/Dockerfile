FROM alpine:3.24 AS build
RUN apk add --no-cache ldc gcc musl-dev zlib-static
COPY collatz.d /src/
RUN ldc2 -O -static -of=/collatz /src/collatz.d

FROM scratch
COPY --from=build /collatz /collatz
ENTRYPOINT ["/collatz"]
