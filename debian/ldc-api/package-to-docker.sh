#!/bin/bash

: <<'END_COMMENT'
https://docs.docker.com/engine/reference/builder/
https://docs.docker.com/engine/reference/commandline/docker/
https://docs.docker.com/compose/compose-file/
https://docs.docker.com/compose/reference/overview/

docker run --rm -it -p 12345:12345 songdongsheng/ldc-api

docker build -t songdongsheng/ldc-api:20181102 .
docker tag      songdongsheng/ldc-api:20181102 songdongsheng/ldc-api
docker push     songdongsheng/ldc-api:20181102
docker push     songdongsheng/ldc-api

rsync -avz ci@139.159.161.115:/ci/build-script/dist/baas-composite .
rsync -avz ci@139.159.161.115:/ci/build-script/dist/baas-main .
rsync -avz ci@139.159.161.115:/ci/build-script/dist/baas-notification .
rsync -avz ci@139.159.161.115:/ci/build-script/dist/baas-olap .
rsync -avz ci@139.159.161.115:/ci/build-script/dist/baas-workflow .

END_COMMENT

docker build -t songdongsheng/ldc-api:20181102 .
