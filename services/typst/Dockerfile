FROM alpine:3.24
RUN apk add --no-cache typst
COPY --from=runner /runner /usr/local/bin/runner
COPY collatz.typ /app/
ENV STEP_CMD='typst query --input n="$N" /app/collatz.typ "<next>" --field value --one'
CMD ["runner"]
