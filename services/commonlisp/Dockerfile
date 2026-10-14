FROM alpine:3.24
RUN apk add --no-cache sbcl
COPY collatz.lisp /app/
CMD ["sbcl", "--script", "/app/collatz.lisp"]
