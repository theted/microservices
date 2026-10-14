FROM alpine:3.24 AS build
RUN apk add --no-cache nasm binutils
COPY collatz.asm /src/
RUN nasm -f elf64 -o /src/collatz.o /src/collatz.asm && ld -s -o /collatz /src/collatz.o

FROM scratch
COPY --from=build /collatz /collatz
ENTRYPOINT ["/collatz"]
