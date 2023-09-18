FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["AWS.App.Runner.Hello.Word/AWS.App.Runner.Hello.Word.csproj", "AWS.App.Runner.Hello.Word/"]
RUN dotnet restore "AWS.App.Runner.Hello.Word/AWS.App.Runner.Hello.Word.csproj"
COPY . .
WORKDIR "/src/AWS.App.Runner.Hello.Word"
RUN dotnet build "AWS.App.Runner.Hello.Word.csproj" -c Release -o /app/build

FROM build AS publish
RUN apt-get update -yq \
    && apt-get install curl gnupg -yq \
    && curl -sL https://deb.nodesource.com/setup_14.x | bash \
    && apt-get install nodejs -yq
RUN dotnet publish "AWS.App.Runner.Hello.Word.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "AWS.App.Runner.Hello.Word.dll"]
