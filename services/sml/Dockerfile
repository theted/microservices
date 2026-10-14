FROM alpine:3.24
RUN apk add --no-cache polyml socat
COPY collatz.sml /app/
COPY --from=shim . /shim/
ENV STEP_CMD="poly --script /app/collatz.sml"
CMD ["/shim/serve"]
