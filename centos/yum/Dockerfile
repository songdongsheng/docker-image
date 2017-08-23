# docker build -t songdongsheng/centos:7-yum-20170823 .
# docker tag      songdongsheng/centos:7-yum-20170823 songdongsheng/centos:7-yum
# docker tag      songdongsheng/centos:7-yum-20170823 songdongsheng/centos:latest
# yum install coreutils vim-minimal iproute procps-ng tar xz yum
FROM scratch
ADD  rootfs-centos7.yum.tar.xz /
CMD  ["/bin/bash"]
