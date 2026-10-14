FROM alpine:3.24 AS build
RUN apk add --no-cache gfortran musl-dev
COPY collatz.f /src/
RUN gfortran -O2 -static -o /collatz /src/collatz.f

FROM alpine:3.24
COPY --from=build /collatz /app/collatz
COPY --from=runner /runner /usr/local/bin/runner
ENV STEP_CMD="/app/collatz"
CMD ["runner"]
