# Etapa 1: compilar con el SDK de .NET 10 (imagen grande, solo se usa para compilar).
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src
COPY NutriPlan.Api.csproj .
RUN dotnet restore
COPY . .
RUN dotnet publish -c Release -o /app/publish --no-restore

# Etapa 2: ejecutar solo con el runtime de ASP.NET (imagen pequeña).
FROM mcr.microsoft.com/dotnet/aspnet:10.0
WORKDIR /app
COPY --from=build /app/publish .
ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080
ENTRYPOINT ["dotnet", "NutriPlan.Api.dll"]