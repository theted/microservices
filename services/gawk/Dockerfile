FROM alpine:3.24
RUN apk add --no-cache gawk
COPY collatz.awk /app/
CMD ["gawk", "-f", "/app/collatz.awk"]
