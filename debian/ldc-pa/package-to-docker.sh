#!/bin/bash

: <<'END_COMMENT'
https://docs.docker.com/engine/reference/builder/
https://docs.docker.com/engine/reference/commandline/docker/
https://docs.docker.com/compose/compose-file/
https://docs.docker.com/compose/reference/overview/

docker run --rm -it -p 2181:2181 -p 5432:5432 -p 9092:9092 -p 9200:9200 -p 9300:9300 songdongsheng/ldc-pa:ide
docker run --rm -it -p 2181:2181 -p 5432:5432 -p 9092:9092 -p 9200:9200 -p 9300:9300 songdongsheng/ldc-pa:live

docker build -t songdongsheng/ldc-pa:20181101-live .
docker tag      songdongsheng/ldc-pa:20181101-live songdongsheng/ldc-pa:live
docker push     songdongsheng/ldc-pa:20181101-live
docker push     songdongsheng/ldc-pa:live
END_COMMENT

docker build -t songdongsheng/ldc-pa:20181101-live .
