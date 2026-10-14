FROM alpine:3.24
RUN apk add --no-cache picolisp
COPY collatz.l /app/
CMD ["pil", "/app/collatz.l"]
