#!/bin/bash

: <<'END_COMMENT'
https://docs.docker.com/engine/reference/builder/
https://docs.docker.com/engine/reference/commandline/docker/
https://docs.docker.com/compose/compose-file/
https://docs.docker.com/compose/reference/overview/

docker run --rm -it -h ldc-api-01 --name ldc-api-01 --link ldc-pa-01 \
-p 8080:8080 -p 8686:8686 -p 9090:9090 -p 9091:9091 -p 9695:9695 -p 9696:9696 songdongsheng/ldc-api

docker build -t songdongsheng/ldc-api:20181102 .
docker tag      songdongsheng/ldc-api:20181102 songdongsheng/ldc-api
docker push     songdongsheng/ldc-api:20181102
docker push     songdongsheng/ldc-api

cd docker-image/debian/ldc-api/deploy
ssh ci@39.107.111.176 'cd /ci && tar -cf - baas-composite/baas-composite-1.0-SNAPSHOT.jar baas-etl/baas-etl-1.0-SNAPSHOT.jar baas-mybaas/application.conf baas-mybaas/para-1.26.3-SNAPSHOT.war baas-mybaas/baas-exchanger-1.0-SNAPSHOT.jar baas-mybaas/baas-indexer-1.0-SNAPSHOT.jar baas-mybaas/plugins/ baas-notification/baas-websocket-1.0-SNAPSHOT.jar baas-olap/baas-olap-1.0-SNAPSHOT.jar baas-scg/spring-cloud-gateway-service-1.0.0.jar baas-workflow/baas-workflow-1.0.jar | gzip -9' | tar -xvz

live:
    ldc-baas/application.conf
    ldc-baas/para-1.26.3-SNAPSHOT.war
    ldc-baas/baas-exchanger-1.0-SNAPSHOT.jar
    ldc-baas/baas-indexer-1.0-SNAPSHOT.jar
    ldc-baas/plugins
    ldc-composite/baas-composite-1.0-SNAPSHOT.jar
    ldc-nodejs
    ldc-websocket/baas-websocket-1.0-SNAPSHOT.jar
END_COMMENT

docker build -t songdongsheng/ldc-api:20181102 .
docker tag      songdongsheng/ldc-api:20181102 songdongsheng/ldc-api
