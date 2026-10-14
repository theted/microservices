FROM alpine:3.24 AS build
RUN apk add --no-cache zig
COPY collatz.zig /src/
RUN cd /src && zig build-exe collatz.zig -O ReleaseSafe -femit-bin=/collatz

FROM alpine:3.24
RUN apk add --no-cache socat
COPY --from=build /collatz /app/collatz
COPY --from=shim . /shim/
ENV STEP_CMD="/app/collatz"
CMD ["/shim/serve"]
