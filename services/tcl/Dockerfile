FROM alpine:3.24
RUN apk add --no-cache tcl
COPY --from=runner /runner /usr/local/bin/runner
COPY collatz.tcl /app/
ENV STEP_CMD="tclsh /app/collatz.tcl"
CMD ["runner"]
