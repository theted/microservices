FROM alpine:3.24
RUN apk add --no-cache vim
COPY collatz.vim /app/
COPY --from=runner /runner /usr/local/bin/runner
ENV STEP_CMD="vim -Nu NONE -i NONE -es -S /app/collatz.vim"
CMD ["runner"]
