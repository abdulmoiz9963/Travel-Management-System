# ---------- BUILD STAGE ----------
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src

# Copy csproj first (for layer caching)
COPY MVCPro/*.csproj MVCPro/
RUN dotnet restore MVCPro/MVCPro.csproj

# Copy everything else
COPY . .

# Publish the app
WORKDIR /src/MVCPro
RUN dotnet publish -c Release -o /app/publish /p:UseAppHost=false


# ---------- RUNTIME STAGE ----------
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app

COPY --from=build /app/publish .

# ASP.NET Core listens on 8080 inside container
ENV ASPNETCORE_URLS=http://+:8080

EXPOSE 8080

ENTRYPOINT ["dotnet", "MVCPro.dll"]
