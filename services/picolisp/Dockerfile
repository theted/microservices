FROM alpine:3.24
RUN apk add --no-cache picolisp
COPY --from=runner /runner /usr/local/bin/runner
COPY collatz.l /app/
ENV STEP_CMD="pil /app/collatz.l"
CMD ["runner"]
