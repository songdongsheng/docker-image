#!/bin/bash

docker build -t songdongsheng/idea:busybox_1.27.2-idea_1.5 -f Dockerfile .
docker tag      songdongsheng/idea:busybox_1.27.2-idea_1.5 songdongsheng/idea:busybox
docker tag      songdongsheng/idea:busybox_1.27.2-idea_1.5 songdongsheng/idea:latest
docker push     songdongsheng/idea:busybox_1.27.2-idea_1.5
docker push     songdongsheng/idea:busybox
docker push     songdongsheng/idea:latest
