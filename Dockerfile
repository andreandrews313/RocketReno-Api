#Depending on the operating system of the host machines(s) that will build or run the containers, the image specified in the FROM statement may need to be changed.
#For more information, please see https://aka.ms/containercompat

FROM microsoft/dotnet:2.1-aspnetcore-runtime-nanoserver-sac2016 AS base
WORKDIR /app
EXPOSE 29744
EXPOSE 44392

FROM microsoft/dotnet:2.1-sdk-nanoserver-sac2016 AS build
WORKDIR /src
COPY ["RocketReno-Api/RocketReno-Api.csproj", "RocketReno-Api/"]
RUN dotnet restore "RocketReno-Api/RocketReno-Api.csproj"
COPY . .
WORKDIR "/src/RocketReno-Api"
RUN dotnet build "RocketReno-Api.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "RocketReno-Api.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "RocketReno-Api.dll"]