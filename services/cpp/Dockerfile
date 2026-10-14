FROM alpine:3.24 AS build
RUN apk add --no-cache g++
COPY collatz.cpp /src/
RUN g++ -std=c++23 -O2 -Wall -static -o /collatz /src/collatz.cpp

FROM alpine:3.24
COPY --from=build /collatz /app/collatz
COPY --from=runner /runner /usr/local/bin/runner
ENV STEP_CMD="/app/collatz"
CMD ["runner"]
