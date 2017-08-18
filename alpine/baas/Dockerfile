# docker build -t songdongsheng/bass:20170819 .
# docker tag      songdongsheng/bass:20170819 songdongsheng/bass:latest

FROM openjdk:8-jre-alpine
RUN apk update && apk upgrade && rm -rf /var/cache/apk/*

ADD  /var/www/meta-parent/docker/bootstrap.sh \
     /var/download/elasticsearch-2.4.5-with-plugins.tgz /opt/
ADD  /var/www/meta-parent/docker/para-dev.tgz /opt/elasticsearch-2.4.5/data/
COPY /var/www/meta-parent/docker/elasticsearch.yml /opt/elasticsearch-2.4.5/config/
COPY cn.abrain.backend.api-composite-1.0.jar /opt/blob/
COPY /var/www/meta-parent/docker/application.conf \
     /var/www/meta-parent/docker/sqlite.db \
     /var/download/para-1.24.6-SNAPSHOT-20170815.war \
     /opt/bass/
COPY bohandler/target/cn.abrain.backend.api-bohandler-1.2.jar \
     cn.abrain.backend.api-child-relation-handler-1.0.jar \
     cn.abrain.backend.api-jdbcdao-1.0.jar \
     cn.abrain.backend.api-linkhandler-1.0.jar \
     cn.abrain.backend.api-mappinghandler-1.0.jar \
     cn.abrain.backend.api-rbachandler-1.0.jar \
     cn.abrain.backend.api-usermgr-1.0.jar \
     cn.abrain.backend.api-validatesync-1.0.jar \
     cn.abrain.backend.api-viewhandler-1.0.jar \
     /opt/para/plugins/
RUN addgroup -g 1200 rdc && adduser -D -G rdc -u 1200 rdc && chown -R rdc:rdc /opt/*

EXPOSE 8080/tcp 9090/tcp 9200/tcp 9300/tcp
USER rdc:rdc
ENTRYPOINT ["/opt/bootstrap.sh"]
