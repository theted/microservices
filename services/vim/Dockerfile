FROM alpine:3.24
RUN apk add --no-cache vim socat
COPY collatz.vim /app/
COPY --from=shim . /shim/
ENV STEP_CMD="vim -Nu NONE -i NONE -es -S /app/collatz.vim"
CMD ["/shim/serve"]
