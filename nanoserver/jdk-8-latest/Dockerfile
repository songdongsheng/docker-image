# docker build --force-rm -t songdongsheng/zulu-openjdk:8 -f Dockerfile .
# https://docs.docker.com/engine/reference/builder/
# https://hub.docker.com/r/library/openjdk/
# https://github.com/zulu-openjdk/zulu-openjdk/blob/master/nanoserver/8-latest/Dockerfile
# https://github.com/docker-library/openjdk/blob/master/8-jdk/windows/nanoserver/Dockerfile
# https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/
FROM microsoft/nanoserver:latest

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

ENV JDK_URL http://cdn.azul.com/zulu/bin/zulu8.23.0.3-jdk8.0.144-win_x64.zip
ENV JDK_SHA256 F1D9D3341EF7C8C9BAFF3597953E99A6A7C64F8608EE62C03FDD7574B7655C02
ENV JAVA_HOME C:\\opt\\zulujdk

RUN Write-Host ('Downloading {0} ...' -f $env:JDK_URL); \
    Invoke-WebRequest -Uri $env:JDK_URL -OutFile jdk.zip; \
    Write-Host ('Verifying sha256 ({0}) ...' -f $env:JDK_SHA256); \
    if ((Get-FileHash jdk.zip -Algorithm sha256).Hash -ne $env:JDK_SHA256) { \
        Write-Host 'FAILED !'; \
        exit 1; \
    }; \
    Write-Host 'Expanding ...'; \
    Expand-Archive jdk.zip -DestinationPath 'C:\'; \
    if (-Not (Test-Path -Path (Split-Path $env:JAVA_HOME) )) { \
        New-Item -ItemType directory -Path (Split-Path $env:JAVA_HOME); \
    }; \
    $tmpPath=('C:\{0}' -f ($env:JDK_URL.substring($env:JDK_URL.LastIndexOf('/')+1) -Replace '.zip$', '')); \
    Write-Host ('TMP JDK path: {0}' -f $tmpPath); \
    Move-Item -Path $tmpPath -Destination $env:JAVA_HOME; \
    Remove-Item -Force jdk.zip; \
    Write-Host 'Complete.'; \
    $newPath = ('{0}\bin;{0}\jre\bin;{1}' -f $env:JAVA_HOME, $env:PATH); \
    Write-Host ('Updating PATH: {0}' -f $newPath); \
    setx /M PATH $newPath
