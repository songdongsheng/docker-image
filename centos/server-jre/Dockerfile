# docker build -t songdongsheng/server-jre:20190109_8u202_centos-7 .
# docker tag      songdongsheng/server-jre:20190109_8u202_centos-7 songdongsheng/server-jre:8u202_centos
# docker tag      songdongsheng/server-jre:20190109_8u202_centos-7 songdongsheng/server-jre:centos
# docker tag      songdongsheng/server-jre:20190109_8u202_centos-7 songdongsheng/server-jre:8u202
# docker tag      songdongsheng/server-jre:20190109_8u202_centos-7 songdongsheng/server-jre
# docker push     songdongsheng/server-jre:20190109_8u202_centos-7
# docker push     songdongsheng/server-jre:8u202_centos
# docker push     songdongsheng/server-jre:centos
# docker push     songdongsheng/server-jre:8u202
# docker push     songdongsheng/server-jre
# yum install vim-minimal yum
FROM scratch
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ADD  rootfs_centos7_server-jre-8u202.yum.tar.xz /
CMD  ["/bin/bash"]
