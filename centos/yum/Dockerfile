# docker build -t songdongsheng/centos:7-yum-20181101 .
# docker tag      songdongsheng/centos:7-yum-20181101 songdongsheng/centos:7-yum
# docker tag      songdongsheng/centos:7-yum-20181101 songdongsheng/centos:latest
# yum install coreutils vim-minimal iproute procps-ng tar xz yum
FROM scratch
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ADD  rootfs-centos7.yum.tar.xz /
CMD  ["/bin/bash"]
