# docker build --force-rm -t songdongsheng/openjdk:6 -f Dockerfile .
# docker tag songdongsheng/openjdk:6 songdongsheng/openjdk:6-1.6.0_97
# docker tag songdongsheng/openjdk:6 songdongsheng/openjdk:6-1.6.0_97-zulu_6.17.0.1
# https://docs.docker.com/engine/reference/builder/
# https://hub.docker.com/r/library/openjdk/
# https://github.com/zulu-openjdk/zulu-openjdk/blob/master/nanoserver/8-latest/Dockerfile
# https://github.com/docker-library/openjdk/blob/master/8-jdk/windows/nanoserver/Dockerfile
# https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/
FROM microsoft/nanoserver:latest

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

ENV CEK_URL http://cdn.azul.com/zcek/bin/ZuluJCEPolicies.zip
ENV JDK_URL http://cdn.azul.com/zulu/bin/zulu6.17.0.1-jdk6.0.97-win_x64.zip
ENV JDK_SHA256 2321C1F512CC4643E1CE2BA00674C20507080A43ADBF942EA422E2A08DAB25EB
ENV JAVA_HOME C:\\opt\\jdk-6

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
    Invoke-WebRequest -Uri $env:CEK_URL -OutFile cek.zip; \
    Expand-Archive cek.zip -DestinationPath ('{0}\jre\lib\security\' -f $env:JAVA_HOME); \
    Move-Item -Force -Path ('{0}\jre\lib\security\ZuluJCEPolicies\*' -f $env:JAVA_HOME) -Destination ('{0}\jre\lib\security\' -f $env:JAVA_HOME); \
    Remove-Item -Force cek.zip, ('{0}\jre\lib\security\ZuluJCEPolicies' -f $env:JAVA_HOME); \
    Write-Host 'Complete.'; \
    $newPath = ('{0}\bin;{0}\jre\bin;{1}' -f $env:JAVA_HOME, $env:PATH); \
    Write-Host ('Updating PATH: {0}' -f $newPath); \
    setx /M PATH $newPath
