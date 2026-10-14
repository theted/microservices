FROM alpine:3.24 AS build
RUN apk add --no-cache gfortran musl-dev
COPY collatz.f /src/
RUN gfortran -O2 -static -o /collatz /src/collatz.f

FROM alpine:3.24
RUN apk add --no-cache socat
COPY --from=build /collatz /app/collatz
COPY --from=shim . /shim/
ENV STEP_CMD="/app/collatz"
CMD ["/shim/serve"]
