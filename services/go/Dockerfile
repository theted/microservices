FROM golang:1.27-alpine AS build
WORKDIR /src
COPY go.mod main.go ./
RUN CGO_ENABLED=0 go build -ldflags="-s -w" -o /collatz

FROM scratch
COPY --from=build /collatz /collatz
ENTRYPOINT ["/collatz"]
