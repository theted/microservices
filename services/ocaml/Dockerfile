FROM alpine:3.24 AS build
RUN apk add --no-cache ocaml gcc musl-dev binutils
COPY collatz.ml /src/
RUN cd /src && ocamlopt -O2 collatz.ml -o /collatz 2>/dev/null || ocamlopt collatz.ml -o /collatz

FROM alpine:3.24
COPY --from=runner /runner /usr/local/bin/runner
COPY --from=build /collatz /app/collatz
ENV STEP_CMD="/app/collatz"
CMD ["runner"]
