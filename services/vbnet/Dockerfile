FROM mcr.microsoft.com/dotnet/sdk:10.0-alpine AS build
WORKDIR /src
COPY collatz.vbproj .
RUN dotnet restore
COPY collatz.vb .
RUN dotnet publish -c Release -o /app

FROM mcr.microsoft.com/dotnet/runtime:10.0-alpine
COPY --from=build /app /app
COPY --from=runner /runner /usr/local/bin/runner
ENV STEP_CMD="dotnet /app/collatz.dll"
CMD ["runner"]
