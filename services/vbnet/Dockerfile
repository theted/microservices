FROM mcr.microsoft.com/dotnet/sdk:10.0-alpine AS build
WORKDIR /src
COPY collatz.vbproj .
RUN dotnet restore
COPY Program.vb .
RUN dotnet publish -c Release -o /app

FROM mcr.microsoft.com/dotnet/runtime:10.0-alpine
RUN apk add --no-cache socat
COPY --from=build /app /app
COPY --from=shim . /shim/
ENV STEP_CMD="dotnet /app/collatz.dll" DOTNET_TieredPGO=0 DOTNET_TC_QuickJitForLoops=1
CMD ["/shim/serve"]
