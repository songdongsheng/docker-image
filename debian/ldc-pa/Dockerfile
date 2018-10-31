FROM songdongsheng/server-jre:stretch
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ADD  ldc_entry.sh docker-setup.sh META_RDC.sql elasticsearch-5.6.8-with-plugins.tar.gz baas-indexer-1.0-SNAPSHOT.jar 0x7FCC7D46ACCC4CF8.asc jvm.options /opt/
RUN  /opt/docker-setup.sh
EXPOSE 5432/tcp
EXPOSE 9200/tcp
EXPOSE 9300/tcp
CMD  ["/bin/bash"]
# CMD  ["/opt/ldc_entry.sh"]
