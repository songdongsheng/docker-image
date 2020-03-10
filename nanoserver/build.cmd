@SET JDN_HOME=%~dp0
@SET CD_HOME=%CD%

@rem echo %JDN_HOME%
@rem https://hub.docker.com/_/microsoft-powershell
@rem docker pull mcr.microsoft.com/powershell:lts-nanoserver-1809
@rem docker pull mcr.microsoft.com/powershell:nanoserver-1809
@rem docker pull mcr.microsoft.com/powershell:lts-debian-10
@rem docker pull mcr.microsoft.com/powershell:debian-10
@rem docker pull mcr.microsoft.com/powershell:lts-ubuntu-18.04
@rem docker pull mcr.microsoft.com/powershell:ubuntu-18.04

@cd %JDN_HOME%Java-8
docker build --force-rm -t songdongsheng/openjdk:8 -f Dockerfile .
docker tag songdongsheng/openjdk:8 songdongsheng/openjdk:8-1.8.0_144
docker tag songdongsheng/openjdk:8 songdongsheng/openjdk:8-1.8.0_144-zulu_8.23.0.3
docker tag songdongsheng/openjdk:8 songdongsheng/openjdk:latest

@cd %JDN_HOME%Java-11
docker build --force-rm -t songdongsheng/openjdk:9 -f Dockerfile .
docker tag songdongsheng/openjdk:9 songdongsheng/openjdk:9
docker tag songdongsheng/openjdk:9 songdongsheng/openjdk:9-zulu_9.0.0.15

@cd %CD_HOME%

docker push songdongsheng/openjdk:8
docker push songdongsheng/openjdk:8-1.8.0_144
docker push songdongsheng/openjdk:8-1.8.0_144-zulu_8.23.0.3

pause
