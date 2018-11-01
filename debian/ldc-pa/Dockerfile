FROM songdongsheng/server-jre:stretch
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ADD ldc_entry.sh docker-setup.sh \
    0x7FCC7D46ACCC4CF8.asc \
    pg_hba.conf \
    postgresql.conf \
    META_RDC.sql \
    jvm.options \
    elasticsearch-5.6.8-with-plugins.tar.gz \
    baas-indexer-1.0-SNAPSHOT.jar \
    zoo.cfg \
    zookeeper-3.4.13.tar.gz \
    server.properties \
    kafka_2.12-2.0.0.tgz \
    /opt/
RUN /opt/docker-setup.sh
USER postgres:postgres
EXPOSE 2181/tcp
EXPOSE 5432/tcp
EXPOSE 9092/tcp
EXPOSE 9200/tcp
EXPOSE 9300/tcp
#CMD  ["/bin/bash"]
CMD  ["/opt/ldc_entry.sh"]
