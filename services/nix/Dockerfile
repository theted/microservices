FROM alpine:3.24
RUN apk add --no-cache nix
COPY collatz.nix /app/
COPY --from=runner /runner /usr/local/bin/runner
ENV STEP_CMD='nix-instantiate --eval --arg n "$N" /app/collatz.nix'
CMD ["runner"]
