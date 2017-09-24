@SET JDN_HOME=%~dp0
@SET CD_HOME=%CD%

@rem echo %JDN_HOME%

@cd %JDN_HOME%jdk-6-latest
docker build --force-rm -t songdongsheng/openjdk:6 -f Dockerfile .
docker tag songdongsheng/openjdk:6 songdongsheng/openjdk:6-1.6.0_97
docker tag songdongsheng/openjdk:6 songdongsheng/openjdk:6-1.6.0_97-zulu_6.17.0.1

@cd %JDN_HOME%jdk-7-latest
docker build --force-rm -t songdongsheng/openjdk:7 -f Dockerfile .
docker tag songdongsheng/openjdk:7 songdongsheng/openjdk:7-1.7.0_154
docker tag songdongsheng/openjdk:7 songdongsheng/openjdk:7-1.7.0_154-zulu_7.20.0.3

@cd %JDN_HOME%jdk-8-latest
docker build --force-rm -t songdongsheng/openjdk:8 -f Dockerfile .
docker tag songdongsheng/openjdk:8 songdongsheng/openjdk:8-1.8.0_144
docker tag songdongsheng/openjdk:8 songdongsheng/openjdk:8-1.8.0_144-zulu_8.23.0.3
docker tag songdongsheng/openjdk:8 songdongsheng/openjdk:latest

@cd %JDN_HOME%jdk-9-latest
docker build --force-rm -t songdongsheng/openjdk:9 -f Dockerfile .
docker tag songdongsheng/openjdk:9 songdongsheng/openjdk:9
docker tag songdongsheng/openjdk:9 songdongsheng/openjdk:9-zulu_9.0.0.15

docker push songdongsheng/openjdk:6
docker push songdongsheng/openjdk:6-1.6.0_97
docker push songdongsheng/openjdk:6-1.6.0_97-zulu_6.17.0.1
docker push songdongsheng/openjdk:7
docker push songdongsheng/openjdk:7-1.7.0_154
docker push songdongsheng/openjdk:7-1.7.0_154-zulu_7.20.0.3
docker push songdongsheng/openjdk:latest
docker push songdongsheng/openjdk:8
docker push songdongsheng/openjdk:8-1.8.0_144
docker push songdongsheng/openjdk:8-1.8.0_144-zulu_8.23.0.3
docker push songdongsheng/openjdk:9
docker push songdongsheng/openjdk:9-zulu_9.0.0.15
@cd %CD_HOME%

pause
