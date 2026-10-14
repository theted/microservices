FROM mcr.microsoft.com/dotnet/sdk:10.0-alpine AS build
WORKDIR /src
COPY collatz.fsproj .
RUN dotnet restore
COPY collatz.fs .
RUN dotnet publish -c Release -o /app

FROM mcr.microsoft.com/dotnet/runtime:10.0-alpine
COPY --from=runner /runner /usr/local/bin/runner
COPY --from=build /app /app
ENV STEP_CMD="dotnet /app/collatz.dll"
CMD ["runner"]
