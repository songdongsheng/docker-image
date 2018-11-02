FROM songdongsheng/server-jre:stretch
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ADD ldc-api-entry.sh \
    deploy/ \
    /opt/
EXPOSE 12345/tcp
CMD  ["/bin/bash"]
#CMD  ["/opt/ldc-api-entry.sh"]
