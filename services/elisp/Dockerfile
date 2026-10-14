FROM alpine:3.24
RUN apk add --no-cache emacs-nox
COPY collatz.el /app/
CMD ["emacs", "--batch", "-l", "/app/collatz.el"]
