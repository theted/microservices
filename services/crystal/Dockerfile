FROM alpine:3.24 AS build
RUN apk add --no-cache crystal gcc musl-dev pcre2-dev gc-dev openssl-dev zlib-dev yaml-dev
COPY collatz.cr /src/
RUN crystal build --release -o /collatz /src/collatz.cr

FROM alpine:3.24
RUN apk add --no-cache pcre2 gc libgcc
COPY --from=build /collatz /app/collatz
CMD ["/app/collatz"]
