FROM alpine:3.24 AS build
RUN apk add --no-cache ocaml gcc musl-dev binutils
COPY collatz.ml /src/
WORKDIR /src
RUN ocamlfind ocamlopt -package unix -linkpkg collatz.ml -o /collatz 2>/dev/null \
    || ocamlopt unix.cmxa collatz.ml -o /collatz

FROM alpine:3.24
COPY --from=build /collatz /app/collatz
CMD ["/app/collatz"]
