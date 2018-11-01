#!/bin/bash

INSTALL_ROOT=$(mktemp -p . -d)
cd $INSTALL_ROOT
echo $INSTALL_ROOT

# use minirootfs
curl -sSO http://dl-cdn.alpinelinux.org/alpine/v3.8/releases/x86_64/alpine-minirootfs-3.8.1-x86_64.tar.gz
tar -xzf alpine-minirootfs-3.8.1-x86_64.tar.gz
rm -f alpine-minirootfs-3.8.1-x86_64.tar.gz

cat << EOF | tee upgrade_alpine.sh
export PATH=/usr/sbin:/usr/bin:/sbin:/bin
apk -U upgrade && rm -rf /var/cache/apk/*
apk info -v | sort > manifest
EOF

cp /etc/resolv.conf etc/
cp ../IntelliJIDEALicenseServer_linux_amd64 .
chroot . /bin/sh upgrade_alpine.sh
mv manifest ../ && rm -f upgrade_alpine.sh

# rootfs.tar.xz
tar -cvJf ../rootfs.tar.xz *
cd ..
rm -fr $INSTALL_ROOT

# docker images
TS=`/bin/date +"%Y%m%d_%H%M%S"`

cat << EOF | tee Dockerfile-${TS}
FROM scratch
ADD  rootfs.tar.xz /

EXPOSE 1017/tcp
ENTRYPOINT ["/IntelliJIDEALicenseServer_linux_amd64"]
EOF

docker build -t songdongsheng/idea:alpine_${TS}-idea_1.6 -f Dockerfile-${TS} .
docker tag      songdongsheng/idea:alpine_${TS}-idea_1.6 songdongsheng/idea:alpine
docker push     songdongsheng/idea:alpine_${TS}-idea_1.6
docker push     songdongsheng/idea:alpine
rm -fr Dockerfile-${TS} rootfs.tar.xz
