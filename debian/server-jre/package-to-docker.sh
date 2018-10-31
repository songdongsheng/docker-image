#!/bin/bash

: <<'END_COMMENT'
docker build -t songdongsheng/server-jre:20181031_8u192_stretch .
docker tag      songdongsheng/server-jre:20181031_8u192_stretch songdongsheng/server-jre:8u192_stretch
docker tag      songdongsheng/server-jre:20181031_8u192_stretch songdongsheng/server-jre:8u192
docker tag      songdongsheng/server-jre:20181031_8u192_stretch songdongsheng/server-jre:stretch
docker push     songdongsheng/server-jre:20181031_8u192_stretch
docker push     songdongsheng/server-jre:8u192_stretch
docker push     songdongsheng/server-jre:8u192
docker push     songdongsheng/server-jre:stretch
END_COMMENT

docker build -t songdongsheng/server-jre:20181031_8u192_stretch .
