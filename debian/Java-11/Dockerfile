# docker build -t songdongsheng/jdk-11-debian .
# docker tag  songdongsheng/jdk-11-debian songdongsheng/jdk-11-debian:11.0.1
# docker push songdongsheng/jdk-11-debian
# docker push songdongsheng/jdk-11-debian:11.0.1
# docker run --rm -it -e "LANG=en_US.UTF-8" -e "LC_ALL=en_US.UTF-8" debian:9-slim
# docker run --rm -it -p 1080:80 --name jdk-11-debian --hostname jdk-11-debian songdongsheng/jdk-11-debian

FROM debian:9-slim

ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ADD  docker-setup.sh /opt/
RUN  ["/bin/bash", "/opt/docker-setup.sh"]
CMD  ["/bin/bash"]
