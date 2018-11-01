FROM debian:9-slim
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ADD  docker-setup.sh server-jre-8u192.tgz /opt/
RUN  /opt/docker-setup.sh
CMD  ["/bin/bash"]
