#!/bin/bash

INSTALL_ROOT=$(mktemp -p . -d)
cd $INSTALL_ROOT
echo $INSTALL_ROOT

# use minirootfs
curl -sSO http://dl-cdn.alpinelinux.org/alpine/v3.6/releases/x86_64/alpine-minirootfs-3.6.2-x86_64.tar.gz
tar -xzf alpine-minirootfs-3.6.2-x86_64.tar.gz
rm -f alpine-minirootfs-3.6.2-x86_64.tar.gz

cat << EOF | tee upgrade_alpine.sh
export PATH=/usr/sbin:/usr/bin:/sbin:/bin
apk -U upgrade && rm -rf /var/cache/apk/*
apk info -v | sort > manifest
EOF

cp /etc/resolv.conf etc/
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

EXPOSE 3128/tcp
ENTRYPOINT ["/usr/sbin/squid", "-N", "-Y", "-C", "-d", "1" ]
EOF

docker build -t songdongsheng/squid:${TS} -f Dockerfile-${TS} .
docker tag      songdongsheng/squid:${TS} songdongsheng/squid:${SQUID_VERSION}
docker tag      songdongsheng/squid:${TS} songdongsheng/squid:latest
docker push     songdongsheng/squid:${TS}
docker push     songdongsheng/squid:${SQUID_VERSION}
docker push     songdongsheng/squid:latest
rm -fr Dockerfile-${TS} rootfs.tar.xz
