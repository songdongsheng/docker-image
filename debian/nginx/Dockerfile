# docker build -t songdongsheng/nginx .
# docker tag  songdongsheng/nginx songdongsheng/nginx:1.14.2
# docker push songdongsheng/nginx
# docker push songdongsheng/nginx:1.14.2
# docker run --rm -it -e "LANG=en_US.UTF-8" -e "LC_ALL=en_US.UTF-8" debian:9-slim
# docker run --rm -it -p 1080:80 --name nginx --hostname nginx songdongsheng/nginx

FROM debian:9-slim

ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ADD  docker-setup.sh nginx-signing-key.gpg nginx.conf /opt/
RUN  ["/bin/bash", "/opt/docker-setup.sh"]
EXPOSE 80/tcp
#CMD  ["/bin/bash"]
CMD  ["/usr/sbin/nginx"]
