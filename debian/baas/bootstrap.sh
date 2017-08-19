#!/bin/bash

# first run
     [ -f /opt/elasticsearch-2.4.5/config/elasticsearch.yml ] \
  && [ -f /opt/baas/application.conf ] \
  && [ -f /opt/baas/logback.xml ] \
  && [ -f /opt/blob/logback.xml ] || (
    SEED=`dd status=none if=/dev/urandom bs=36 count=1 | base64 -w0 | tr -d "+/=" | dd status=none bs=16 count=1`
    sed "s/aYF7bvrBAcJxBBb6/${SEED}/" /opt/elasticsearch.yml > /opt/elasticsearch-2.4.5/config/elasticsearch.yml

    SEED=`dd status=none if=/dev/urandom bs=36 count=1 | base64 -w0 | tr -d "+/=" | dd status=none bs=16 count=1`
    sed "s/aYF7bvrBAcJxBBb6/${SEED}/" /opt/application.conf > /opt/baas/application.conf

    SEED=`dd status=none if=/dev/urandom bs=36 count=1 | base64 -w0 | tr -d "+/=" | dd status=none bs=16 count=1`
    sed "s/aYF7bvrBAcJxBBb6/baas/" /opt/logback.xml > /opt/baas/logback.xml

    SEED=`dd status=none if=/dev/urandom bs=36 count=1 | base64 -w0 | tr -d "+/=" | dd status=none bs=16 count=1`
    sed "s/aYF7bvrBAcJxBBb6/blob/" /opt/logback.xml > /opt/blob/logback.xml
)

export JAVA_HOME=/opt/server-jre-8u144-linux-x64
export PATH=$JAVA_HOME/bin:$JAVA_HOME/jre/bin:/usr/sbin:/usr/bin:/sbin:/sbin

cd /opt/elasticsearch-2.4.5/
java -Xms512m -Xmx512m \
    -XX:+UseParNewGC -XX:+UseConcMarkSweepGC \
    -XX:CMSInitiatingOccupancyFraction=75 -XX:+UseCMSInitiatingOccupancyOnly \
    -XX:+HeapDumpOnOutOfMemoryError -XX:+DisableExplicitGC \
    -Dfile.encoding=UTF-8 -Djava.awt.headless=true \
    -Djna.nosys=true -Djna.debug_load=true \
    -Des.path.home=/opt/elasticsearch-2.4.5 \
    -cp /opt/elasticsearch-2.4.5/lib/elasticsearch-2.4.5.jar:/opt/elasticsearch-2.4.5/lib/* \
    org.elasticsearch.bootstrap.Elasticsearch start &

cd /opt/blob/
java -Xms128m -Xmx128m \
    -XX:+UseParNewGC -XX:+UseConcMarkSweepGC \
    -XX:CMSInitiatingOccupancyFraction=75 -XX:+UseCMSInitiatingOccupancyOnly \
    -XX:+HeapDumpOnOutOfMemoryError -XX:+DisableExplicitGC \
    -Dfile.encoding=UTF-8 -Djava.awt.headless=true \
    -Djna.nosys=true -Djna.debug_load=true \
    -Dlogging.config=logback.xml \
    -jar cn.abrain.backend.api-composite-1.0.jar &

while true; do
    curl -si http://127.0.0.1:9200;
    [ $? -eq 0 ] && break;
    sleep 1;
done

cd /opt/baas/
java -Xms512m -Xmx512m \
    -XX:+UseParNewGC -XX:+UseConcMarkSweepGC \
    -XX:CMSInitiatingOccupancyFraction=75 -XX:+UseCMSInitiatingOccupancyOnly \
    -XX:+HeapDumpOnOutOfMemoryError -XX:+DisableExplicitGC \
    -Dfile.encoding=UTF-8 -Djava.awt.headless=true \
    -Djna.nosys=true -Djna.debug_load=true \
    -Dconfig.file=application.conf \
    -Dlogging.config=logback.xml \
    -jar para-1.24.6-SNAPSHOT.war
