FROM alpine:3.24
RUN apk add --no-cache lua5.4
COPY --from=runner /runner /usr/local/bin/runner
COPY collatz.lua /app/
ENV STEP_CMD="lua5.4 /app/collatz.lua"
CMD ["runner"]
