FROM alpine:3.24
RUN apk add --no-cache janet
COPY collatz.janet /app/
CMD ["janet", "/app/collatz.janet"]
