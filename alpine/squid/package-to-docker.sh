#!/bin/bash

set -Eeu -o pipefail

INSTALL_ROOT=$(mktemp -p . -d)
cd $INSTALL_ROOT
echo $INSTALL_ROOT

# use minirootfs
curl -sS http://dl-cdn.alpinelinux.org/alpine/v3.11/releases/x86_64/alpine-minirootfs-3.11.4-x86_64.tar.gz | tar -xvzf -

# apk add squid
cat << EOF | tee add_squid.sh
export PATH=/usr/sbin:/usr/bin:/sbin:/bin
apk -U upgrade && apk add squid && rm -rf /var/cache/apk/*
apk info -v | sort > manifest
EOF

cp /etc/resolv.conf etc/
chroot . /bin/sh /add_squid.sh
cp ../squid.conf etc/squid/
mv manifest ../ && rm -f add_squid.sh

# rootfs.tar.xz
tar -cvJf ../rootfs.tar.xz *
cd ..
rm -fr $INSTALL_ROOT

SQUID_VERSION=`cat manifest  | grep squid`
echo SQUID_VERSION:${SQUID_VERSION}
SQUID_VERSION=${SQUID_VERSION:6}
echo SQUID_VERSION:${SQUID_VERSION}

# docker images
TS=`/bin/date +"%Y%m%d_%H%M%S"`

cat << EOF | tee Dockerfile-${TS}
FROM scratch
ADD  rootfs.tar.xz /
RUN  mkdir -p /var/spool/squid /var/log/squid \
     && chown -R squid:squid /var/log/squid /var/spool/squid \
     && /usr/sbin/squid -N -C -f /etc/squid/squid.conf -z

EXPOSE 3128/tcp
ENTRYPOINT ["/usr/sbin/squid", "-N", "-Y", "-C", "-d", "1" ]
EOF

docker build -t songdongsheng/squid:${TS} -f Dockerfile-${TS} .
docker tag      songdongsheng/squid:${TS} songdongsheng/squid:${SQUID_VERSION}
docker tag      songdongsheng/squid:${TS} songdongsheng/squid:latest

exit 0

docker push     songdongsheng/squid:${TS}
docker push     songdongsheng/squid:${SQUID_VERSION}
docker push     songdongsheng/squid:latest
rm -fr Dockerfile-${TS} rootfs.tar.xz
