#!/bin/bash

: <<'END_COMMENT'
https://docs.docker.com/engine/reference/builder/
https://docs.docker.com/engine/reference/commandline/docker/
https://docs.docker.com/compose/compose-file/
https://docs.docker.com/compose/reference/overview/

docker run --rm -it -p 12345:12345 songdongsheng/ldc-scg

docker build -t songdongsheng/ldc-scg:20181102 .
docker tag      songdongsheng/ldc-scg:20181102 songdongsheng/ldc-scg
docker push     songdongsheng/ldc-scg:20181102
docker push     songdongsheng/ldc-scg
END_COMMENT

docker build -t songdongsheng/ldc-scg:20181102 .
