FROM debian:9-slim
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ADD  docker-setup.sh jdk-8u192-linux-x64.tgz /opt/
RUN  apt-get update && apt-get -y dist-upgrade && apt-get clean && /opt/docker-setup.sh
CMD  ["/bin/bash"]
