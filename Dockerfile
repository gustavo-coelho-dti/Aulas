FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["BudgetTracker/BudgetTracker.csproj", "BudgetTracker/"]
RUN dotnet restore "BudgetTracker/BudgetTracker.csproj"
COPY . .
WORKDIR "/src/BudgetTracker"
RUN dotnet build "BudgetTracker.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "BudgetTracker.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "BudgetTracker.dll"]
