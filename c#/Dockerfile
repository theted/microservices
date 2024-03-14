FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["csharp-server.csproj", "./"]
RUN dotnet restore "csharp-server.csproj"

COPY . .
# WORKDIR "/src/csharp-server"
RUN dotnet build "csharp-server.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "csharp-server.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "csharp-server.dll"]


# # FROM microsoft/dotnet:2.1-sdk AS build
# FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
# WORKDIR /app

# # copy csproj and restore as distinct layers
# COPY *.csproj ./dotnetapp/
# WORKDIR /app/dotnetapp
# RUN dotnet restore

# # copy and build everything else
# WORKDIR /app/
# COPY . ./dotnetapp/
# WORKDIR /app/dotnetapp
# RUN dotnet publish -c Release -o out


# # FROM microsoft/dotnet:2.1-runtime AS runtime
# FROM mcr.microsoft.com/dotnet/runtime:6.0 AS runtime
# WORKDIR /app
# COPY --from=build /app/dotnetapp/out ./
# ENTRYPOINT ["dotnet", "cscharp-server.dll"]


####################################################


# FROM mcr.microsoft.com/dotnet/core/sdk:2.2 AS build-env
# WORKDIR /app

# # Copy csproj and restore as distinct layers
# COPY *.csproj ./
# RUN dotnet restore

# # Copy everything else and build
# COPY . ./
# RUN dotnet publish -c Release -o out

# # Build runtime image
# FROM mcr.microsoft.com/dotnet/core/aspnet:2.2
# WORKDIR /app
# COPY --from=build-env /app/out .
# ENTRYPOINT ["dotnet", "aspnetcoreapp.dll"]

