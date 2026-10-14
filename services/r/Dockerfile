FROM alpine:3.24
RUN apk add --no-cache R
COPY collatz.R /app/
CMD ["Rscript", "/app/collatz.R"]
