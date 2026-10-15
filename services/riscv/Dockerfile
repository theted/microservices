FROM alpine:3.24 AS build
RUN apk add --no-cache binutils-riscv64
COPY collatz.s /src/
# --no-relax: there's no C runtime to set up gp, so la must not become gp-relative.
RUN riscv64-alpine-linux-musl-as /src/collatz.s -o /src/collatz.o \
    && riscv64-alpine-linux-musl-ld --no-relax -o /collatz /src/collatz.o

FROM alpine:3.24
RUN apk add --no-cache qemu-riscv64
COPY --from=runner /runner /usr/local/bin/runner
COPY --from=build /collatz /app/collatz
ENV STEP_CMD="qemu-riscv64 /app/collatz"
CMD ["runner"]
