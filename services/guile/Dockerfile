FROM alpine:3.24
RUN apk add --no-cache guile
COPY collatz.scm /app/
CMD ["guile", "--no-auto-compile", "/app/collatz.scm"]
