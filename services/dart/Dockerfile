FROM dart:3.13 AS build
COPY collatz.dart /src/
RUN dart compile exe /src/collatz.dart -o /collatz

FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /collatz /collatz
ENTRYPOINT ["/collatz"]
