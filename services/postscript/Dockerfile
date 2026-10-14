FROM alpine:3.24
RUN apk add --no-cache ghostscript socat
COPY collatz.ps /app/
COPY --from=shim . /shim/
ENV STEP_CMD="gs -q -dNODISPLAY -dBATCH -dNOPAUSE /app/collatz.ps"
CMD ["/shim/serve"]
