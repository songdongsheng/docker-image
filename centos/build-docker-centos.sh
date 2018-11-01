vi /etc/yum/yum.conf or /etc/yum.conf
    multilib_policy=best

vi /etc/systemd/journald.conf
    # systemctl restart systemd-journald
    SystemMaxUse=4GB
    SystemKeepFree=1GB
    SystemMaxFileSize=64M
    MaxRetentionSec=31day
   #ForwardToSyslog=yes
   #MaxLevelStore=debug
   #MaxLevelSyslog=debug

systemd-journal-remote
    /lib/systemd/system/systemd-journal-gatewayd.service    serves journal events over the network by HTTP port 19531
    /lib/systemd/system/systemd-journal-remote.service      receive serialized journal events and store them to journal files
    /lib/systemd/system/systemd-journal-upload.service      upload journal entries to the URL

journald-forwarder.service
    [Unit]
    Description=Forward journald logs to Loggly
    After=docker.service

    [Service]
    ExecStartPre=-/bin/mkdir -pv /opt/uswitch/journald-forwarder
    ExecStartPre=-/usr/bin/curl -L -o /opt/uswitch/journald-forwarder/journald-forwarder https://github.com/uswitch/journald-forwarder/releases/download/v0.3/journald-forwarder
    ExecStartPre=-/bin/chmod +x /opt/uswitch/journald-forwarder/journald-forwarder
    ExecStart=/opt/uswitch/journald-forwarder/journald-forwarder -token [token] -tag [tag]

yum makecache
yum update -y --downloadonly

rpm --querytags | grep -i time
rpm -qa --qf '%{BUILDTIME} (%{BUILDTIME:date}): %{NAME}-%{VERSION}-%{RELEASE}.%{ARCH} %{LONGSIZE}\n' | sort -n

# sed -i "s/\$releasever/7/g" *

INSTALL_ROOT=$(mktemp -d)
echo $INSTALL_ROOT
rm -fr $INSTALL_ROOT
yum --installroot $INSTALL_ROOT -y --nogpgcheck --releasever=7 \
    install yum install coreutils vim-minimal iproute procps-ng tar xz yum
rpm --dbpath $INSTALL_ROOT/var/lib/rpm -qa | sort | wc -l

yum --installroot $INSTALL_ROOT list installed
rpm --dbpath $INSTALL_ROOT/root/.rpmdb -qa | sort

rpm --dbpath $INSTALL_ROOT/var/lib/rpm -qa --qf '%{BUILDTIME} (%{BUILDTIME:date}): %{NAME}-%{VERSION}-%{RELEASE}.%{ARCH} %{LONGSIZE}\n' | sort -n

yum --installroot $INSTALL_ROOT -y --nogpgcheck --releasever=7 clean all

cat << EOF > $INSTALL_ROOT/root/.bashrc
export JAVA_HOME=/opt/jdk-8/bin
export PATH=/usr/sbin:/usr/bin:/sbin:/bin:/opt/jdk-8/bin:/opt/jdk-8/jre/bin
EOF

cat << EOF > $INSTALL_ROOT/etc/profile
export JAVA_HOME=/opt/jdk-8/bin
export PATH=/usr/sbin:/usr/bin:/sbin:/bin:/opt/jdk-8/bin:/opt/jdk-8/jre/bin
EOF

rm -fr  $INSTALL_ROOT/root/.rpmdb $INSTALL_ROOT/var/lib/rpm $INSTALL_ROOT/var/lib/yum
/bin/rm $INSTALL_ROOT/etc/localtime && /bin/cp $INSTALL_ROOT/usr/share/zoneinfo/Asia/Shanghai $INSTALL_ROOT/etc/localtime
echo "Asia/Shanghai" > $INSTALL_ROOT/etc/timezone

rm -fr \
$INSTALL_ROOT/usr/share/man \
$INSTALL_ROOT/usr/share/doc \
$INSTALL_ROOT/usr/share/i18n \
$INSTALL_ROOT/usr/share/info \
$INSTALL_ROOT/usr/share/locale \
$INSTALL_ROOT/usr/share/zoneinfo \
$INSTALL_ROOT/usr/lib/locale/* \
$INSTALL_ROOT/var/cache/yum/*

localedef --prefix=$INSTALL_ROOT -c -i en_US -f UTF-8 en_US.UTF-8
localedef --prefix=$INSTALL_ROOT -c -i zh_CN -f UTF-8 zh_CN.UTF-8
localedef --prefix=$INSTALL_ROOT --list-archive

# tiny only
rm -fr \
    $INSTALL_ROOT/var/lib/rpm* \
    $INSTALL_ROOT/var/lib/yum \
    $INSTALL_ROOT/etc/yum* \
    $INSTALL_ROOT/var/log/* \
    $INSTALL_ROOT/var/cache/yum/

[ -f $INSTALL_ROOT/root/.rpmdb/Packages ] && mv $INSTALL_ROOT/root/.rpmdb/* $INSTALL_ROOT/var/lib/rpm && rm -fr $INSTALL_ROOT/root/.rpmdb

cd $INSTALL_ROOT && du -ms .

ls -a . | grep -v \\.$ | xargs du -ms | sort -n

tar -cvJf ~/docker-image/centos/tiny/rootfs-centos7.tiny.tar.xz *
tar -cvJf ~/docker-image/centos/yum/rootfs-centos7.yum.tar.xz *
tar -cvJf ~/docker-image/centos/server-jre/rootfs_centos7_server-jre-8u192.yum.tar.xz *

tar -xzf ~/server-jre-8u192-linux-x64.tar.gz
mv jdk1.8.0_192 server-jre-8u192-linux-x64; 
ln -s server-jre-8u192-linux-x64 jdk-8
cd server-jre-8u192-linux-x64
rm -fr \
    bin/javafxpackager \
    jre/lib/amd64/libjavafx* \
    jre/lib/amd64/libjfx* \
    jre/lib/amd64/libjfxwebkit.so \
    jre/lib/ext/jfxrt.jar \
    jre/lib/javafx.properties \
    jre/lib/jfxswt.jar \
    lib/ant-javafx.jar \
    lib/javafx-mx.jar \
    lib/missioncontrol \
    lib/visualvm \
    man/ \
    javafx-src.zip \
    src.zip

docker tag songdongsheng/server-jre:8u192 swr.cn-north-1.myhuaweicloud.com/songdongsheng/server-jre:8u192
docker push swr.cn-north-1.myhuaweicloud.com/songdongsheng/server-jre:8u192
