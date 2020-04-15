FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /src
COPY ["WeatherApp.sln", "."]
COPY ["Client/WeatherApp.Client.csproj", "Client/"]
COPY ["Server/WeatherApp.Server.csproj", "Server/"]
COPY ["Shared/WeatherApp.Shared.csproj", "Shared/"]
COPY . .
WORKDIR "/src"
RUN dotnet build -c Release -o /app/build

FROM build AS publish
RUN dotnet publish -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "WeatherApp.Server.dll"]