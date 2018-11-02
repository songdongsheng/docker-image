FROM songdongsheng/server-jre:stretch
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ADD ldc-scg-entry.sh \
    spring-cloud-gateway-service-1.0.0.jar \
    /opt/
EXPOSE 12345/tcp
#CMD  ["/bin/bash"]
CMD  ["/opt/ldc-scg-entry.sh"]
