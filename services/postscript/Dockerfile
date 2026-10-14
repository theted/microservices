FROM alpine:3.24
RUN apk add --no-cache ghostscript
COPY collatz.ps /app/
COPY --from=runner /runner /usr/local/bin/runner
ENV STEP_CMD="gs -q -dNODISPLAY -dBATCH -dNOPAUSE /app/collatz.ps"
CMD ["runner"]
