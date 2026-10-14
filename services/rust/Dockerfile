FROM rust:1.99-alpine AS build
COPY main.rs /src/
RUN rustc -C opt-level=3 -o /collatz /src/main.rs

FROM scratch
COPY --from=build /collatz /collatz
ENTRYPOINT ["/collatz"]
