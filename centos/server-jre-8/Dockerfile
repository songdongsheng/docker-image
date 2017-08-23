# docker build -t songdongsheng/server-jre-8:20170823_8u144_centos-7 .
# docker tag      songdongsheng/server-jre-8:20170823_8u144_centos-7 songdongsheng/server-jre-8:8u144_centos
# docker tag      songdongsheng/server-jre-8:20170823_8u144_centos-7 songdongsheng/server-jre-8:centos
# docker push     songdongsheng/server-jre-8:20170823_8u144_centos-7
# docker push     songdongsheng/server-jre-8:8u144_centos
# docker push     songdongsheng/server-jre-8:centos
# yum install coreutils vim-minimal iproute procps-ng tar xz yum
FROM scratch
ADD  rootfs_centos7_server-jre-8u144-linux-x64.yum.tar.xz /
CMD  ["/bin/bash"]
