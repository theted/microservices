FROM alpine:3.24
RUN apk add --no-cache rakudo
COPY collatz.raku /app/
CMD ["rakudo", "/app/collatz.raku"]
