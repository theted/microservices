FROM alpine:3.24 AS build
RUN apk add --no-cache gcc-gnat musl-dev
COPY collatz.adb /src/
RUN cd /src && gnatmake -O2 collatz.adb -bargs -static -largs -static

FROM alpine:3.24
COPY --from=build /src/collatz /app/collatz
COPY --from=runner /runner /usr/local/bin/runner
ENV STEP_CMD="/app/collatz"
CMD ["runner"]
