# docker build -t songdongsheng/centos:7-tiny-20170823 .
# docker tag      songdongsheng/centos:7-tiny-20170823 songdongsheng/centos:7-tiny
# docker push     songdongsheng/centos:7-tiny-20170823
# docker push     songdongsheng/centos:7-tiny
# yum install coreutils vim-minimal iproute
FROM scratch
ADD  rootfs-centos7.tiny.tar.xz /
CMD  ["/bin/bash"]
