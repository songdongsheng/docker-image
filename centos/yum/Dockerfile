# docker build -t songdongsheng/centos:7-20181101 .
# docker tag      songdongsheng/centos:7-20181101 songdongsheng/centos:7
# docker tag      songdongsheng/centos:7-20181101 songdongsheng/centos
# docker push songdongsheng/centos:7-20181101
# docker push songdongsheng/centos:7
# docker push songdongsheng/centos
# yum install vim-minimal yum
FROM scratch
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ADD  rootfs-centos7.yum.tar.xz /
CMD  ["/bin/bash"]
