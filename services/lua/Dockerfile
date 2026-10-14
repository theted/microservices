FROM alpine:3.24
RUN apk add --no-cache lua5.4 lua5.4-socket
COPY collatz.lua /app/
CMD ["lua5.4", "/app/collatz.lua"]
