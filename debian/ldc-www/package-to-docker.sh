#!/bin/bash

: <<'END_COMMENT'
https://docs.docker.com/engine/reference/builder/
https://docs.docker.com/engine/reference/commandline/docker/
https://docs.docker.com/compose/compose-file/
https://docs.docker.com/compose/reference/overview/

docker run --rm -it -p 80:80 songdongsheng/ldc-www

docker build -t songdongsheng/ldc-www:20181102 .
docker tag      songdongsheng/ldc-www:20181102 songdongsheng/ldc-www
docker push     songdongsheng/ldc-www:20181102
docker push     songdongsheng/ldc-www
END_COMMENT

docker build -t songdongsheng/ldc-www:20181102 .
