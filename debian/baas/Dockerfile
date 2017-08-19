# docker build -t songdongsheng/baas:20170819 .
# docker tag      songdongsheng/baas:20170819 songdongsheng/baas:latest

#FROM centos:7
FROM debian:stretch-slim

ADD  application.conf bootstrap.sh elasticsearch.yml logback.xml \
     pool/server-jre-8u144-linux-x64-with-jce.tar.gz \
     pool/elasticsearch-2.4.5-with-plugins.tgz \
     /opt/
ADD  para-dev.tgz /opt/elasticsearch-2.4.5/data/
COPY pool/cn.abrain.backend.api-composite-1.0.jar /opt/blob/
COPY sqlite.db \
     pool/para-1.24.6-SNAPSHOT.war \
     /opt/baas/
COPY pool/cn.abrain.backend.api-bohandler-1.2.jar \
     pool/cn.abrain.backend.api-child-relation-handler-1.0.jar \
     pool/cn.abrain.backend.api-jdbcdao-1.0.jar \
     pool/cn.abrain.backend.api-linkhandler-1.0.jar \
     pool/cn.abrain.backend.api-mappinghandler-1.0.jar \
     pool/cn.abrain.backend.api-rbachandler-1.0.jar \
     pool/cn.abrain.backend.api-usermgr-1.0.jar \
     pool/cn.abrain.backend.api-validatesync-1.0.jar \
     pool/cn.abrain.backend.api-viewhandler-1.0.jar \
     /opt/baas/plugins/

COPY source.list /etc/apt/sources.list
RUN apt-get update && apt-get dist-upgrade \
    && apt-get install -y --no-install-recommends ca-certificates curl iproute2 procps vim-tiny \
    && apt-get clean \
    && addgroup --gid 1200 rdc \
    && adduser --quiet --disabled-password --gid 1200 --uid 1200 --gecos rdc rdc \
    && chown -R rdc:rdc /opt/
EXPOSE 8080/tcp 9090/tcp 9200/tcp
USER rdc:rdc
ENTRYPOINT ["/opt/bootstrap.sh"]
