FROM alpine:3.24 AS build
RUN apk add --no-cache gcc musl-dev
COPY collatz.c /src/
RUN gcc -O2 -Wall -Wextra -static -o /collatz /src/collatz.c

FROM scratch
COPY --from=build /collatz /collatz
ENTRYPOINT ["/collatz"]
