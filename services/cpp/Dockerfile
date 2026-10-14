FROM alpine:3.24 AS build
RUN apk add --no-cache g++
COPY collatz.cpp /src/
RUN g++ -std=c++23 -O2 -Wall -static -o /collatz /src/collatz.cpp

FROM alpine:3.24
RUN apk add --no-cache socat
COPY --from=build /collatz /app/collatz
COPY --from=shim . /shim/
ENV STEP_CMD="/app/collatz"
CMD ["/shim/serve"]
