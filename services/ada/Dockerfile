FROM alpine:3.24 AS build
RUN apk add --no-cache gcc-gnat musl-dev
COPY collatz.adb /src/
RUN cd /src && gnatmake -O2 collatz.adb -bargs -static -largs -static

FROM alpine:3.24
RUN apk add --no-cache socat
COPY --from=build /src/collatz /app/collatz
COPY --from=shim . /shim/
ENV STEP_CMD="/app/collatz"
CMD ["/shim/serve"]
