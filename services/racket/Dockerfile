FROM alpine:3.24
RUN apk add --no-cache racket
COPY collatz.rkt /app/
CMD ["racket", "/app/collatz.rkt"]
