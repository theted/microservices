FROM alpine:3.24
RUN apk add --no-cache nix socat
COPY collatz.nix /app/
COPY --from=shim . /shim/
ENV STEP_CMD='nix-instantiate --eval --arg n "$N" /app/collatz.nix'
CMD ["/shim/serve"]
