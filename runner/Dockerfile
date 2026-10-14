# Built once; every language image copies /runner out of this one.
FROM golang:1.27-alpine AS build
WORKDIR /src
COPY go.mod main.go ./
RUN CGO_ENABLED=0 go build -ldflags="-s -w" -o /runner

FROM scratch
COPY --from=build /runner /runner
