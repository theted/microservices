FROM alpine:3.24
RUN apk add --no-cache tcl
COPY collatz.tcl /app/
CMD ["tclsh", "/app/collatz.tcl"]
