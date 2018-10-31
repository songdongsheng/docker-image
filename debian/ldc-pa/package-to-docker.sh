#!/bin/bash

: <<'END_COMMENT'
docker build -t songdongsheng/ldc-pa:20181031-live .
docker tag      songdongsheng/ldc-pa:20181031-live songdongsheng/ldc-pa:live
docker push     songdongsheng/ldc-pa:20181031-live
docker push     songdongsheng/ldc-pa:live
END_COMMENT

docker build -t songdongsheng/ldc-pa:20181031-live .
