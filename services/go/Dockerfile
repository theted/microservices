FROM golang:1.27-alpine AS build
COPY collatz.go /src/
RUN cd /src && CGO_ENABLED=0 go build -ldflags="-s -w" -o /collatz collatz.go

FROM alpine:3.24
COPY --from=runner /runner /usr/local/bin/runner
COPY --from=build /collatz /app/collatz
ENV STEP_CMD="/app/collatz"
CMD ["runner"]
