#!/bin/bash

export JAVA_HOME=/opt/jdk-8
export PATH=/usr/sbin:/usr/bin:/sbin:/bin:/opt/jdk-8/bin:/opt/jdk-8/jre/bin
cd /opt/ && java \
    -Djava.awt.headless=true \
    -Xmx512M -Xms512M -Djava.awt.headless=true \
    -Duser.language=en -Duser.country=US -Dfile.encoding=UTF-8 \
    -Dreactor.netty.http.server.accessLogEnabled=true \
    -Dspring.datasource.primary.url="jdbc:postgresql://ldc-pa-01:5432/meta_rdc?stringtype=unspecified" \
    -Dspring.datasource.primary.username="rdc" -Dspring.datasource.primary.password="gDbEaa8c" \
    -Dspring.kafka.bootstrap-servers="ldc-pa-01:9092" \
    -Dspring.kafka.consumer.group-id="accessLog" \
    -Dldc.uri.main="http://ldc-api-01:8080" \
    -Dldc.uri.ws="http://ldc-api-01:8686" \
    -Dldc.uri.bi="http://ldc-api-01:9696" \
    -Dldc.uri.wf="http://ldc-api-01:9091" \
    -Dldc.uri.composite="http://ldc-api-01:9090" \
    -Dldc.uri.js="http://ldc-api-01:9500" \
    -jar spring-cloud-gateway-service-1.0.0.jar
