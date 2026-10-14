FROM alpine:3.24
RUN apk add --no-cache fennel lua5.4 lua5.4-socket
COPY collatz.fnl /app/
CMD ["fennel5.4", "/app/collatz.fnl"]
