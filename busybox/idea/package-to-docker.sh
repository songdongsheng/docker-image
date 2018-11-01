#!/bin/bash

docker build -t songdongsheng/idea:busybox_1.29.3-idea_1.6 -f Dockerfile .
docker tag      songdongsheng/idea:busybox_1.29.3-idea_1.6 songdongsheng/idea:busybox
docker tag      songdongsheng/idea:busybox_1.29.3-idea_1.6 songdongsheng/idea:1.6
docker tag      songdongsheng/idea:busybox_1.29.3-idea_1.6 songdongsheng/idea:latest
docker push     songdongsheng/idea:busybox_1.29.3-idea_1.6
docker push     songdongsheng/idea:busybox
docker push     songdongsheng/idea:1.6
docker push     songdongsheng/idea:latest
