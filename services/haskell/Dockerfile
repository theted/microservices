FROM alpine:3.24 AS build
RUN apk add --no-cache ghc musl-dev gmp-dev libffi-dev
COPY collatz.hs /src/
RUN cd /src && ghc -O2 -o /collatz collatz.hs

FROM alpine:3.24
RUN apk add --no-cache socat gmp libffi
COPY --from=build /collatz /app/collatz
COPY --from=shim . /shim/
ENV STEP_CMD="/app/collatz"
CMD ["/shim/serve"]
