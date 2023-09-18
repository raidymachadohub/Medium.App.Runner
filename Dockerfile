FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
#From MAC M1 or M2
#docker buildx build --platform linux/amd64 --output type=docker -t app-runner-lab .

#ENV ASPNETCORE_URLS=http://*:8080

WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src

COPY . .

RUN dotnet restore "AWS.App.Runner.Hello.Word/AWS.App.Runner.Hello.Word.csproj"
COPY . .

WORKDIR "/src/."
RUN dotnet build "AWS.App.Runner.Hello.Word/AWS.App.Runner.Hello.Word.csproj" -c Release -o /app/build

FROM build AS publish

RUN dotnet publish "AWS.App.Runner.Hello.Word/AWS.App.Runner.Hello.Word.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "AWS.App.Runner.Hello.Word.dll"]