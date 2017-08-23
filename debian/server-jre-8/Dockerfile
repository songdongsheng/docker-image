# docker build -t songdongsheng/server-jre-8:20170823_8u144_stretch .
# docker tag      songdongsheng/server-jre-8:20170823_8u144_stretch songdongsheng/server-jre-8:8u144_stretch
# docker tag      songdongsheng/server-jre-8:20170823_8u144_stretch songdongsheng/server-jre-8:stretch
# docker push     songdongsheng/server-jre-8:20170823_8u144_stretch
# docker push     songdongsheng/server-jre-8:8u144_stretch
# docker push     songdongsheng/server-jre-8:stretch
FROM debian:stretch-slim
RUN  apt-get update && apt-get -y dist-upgrade && apt-get clean
ADD  server-jre-8u144-linux-x64-with-jce.tar.xz /opt/
CMD  ["/bin/bash"]
