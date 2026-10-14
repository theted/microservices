FROM alpine:3.24 AS build
RUN apk add --no-cache nasm binutils
COPY collatz.asm /src/
RUN nasm -f elf64 -o /src/collatz.o /src/collatz.asm && ld -s -o /collatz /src/collatz.o

FROM alpine:3.24
COPY --from=runner /runner /usr/local/bin/runner
COPY --from=build /collatz /app/collatz
ENV STEP_CMD="/app/collatz"
CMD ["runner"]
