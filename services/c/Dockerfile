FROM alpine:3.24 AS build
RUN apk add --no-cache gcc musl-dev
COPY collatz.c /src/
RUN gcc -O2 -Wall -Wextra -o /collatz /src/collatz.c

FROM alpine:3.24
COPY --from=runner /runner /usr/local/bin/runner
COPY --from=build /collatz /app/collatz
ENV STEP_CMD="/app/collatz"
CMD ["runner"]
