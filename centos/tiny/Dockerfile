# docker build -t songdongsheng/centos:7-tiny-20181101 .
# docker tag      songdongsheng/centos:7-tiny-20181101 songdongsheng/centos:7-tiny
# docker push     songdongsheng/centos:7-tiny-20181101
# docker push     songdongsheng/centos:7-tiny
# yum install coreutils vim-minimal iproute
FROM scratch
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ADD  rootfs-centos7.tiny.tar.xz /
CMD  ["/bin/bash"]
