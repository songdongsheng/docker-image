#!/bin/bash

export JAVA_HOME=/opt/jdk-8
export PATH=/usr/sbin:/usr/bin:/sbin:/bin:/opt/jdk-8/bin:/opt/jdk-8/jre/bin:/usr/lib/postgresql/10/bin

cd /opt/elasticsearch-5.6.8 && mkdir -p data log
java -Xms2g -Xmx4g -Xss1m -Djava.awt.headless=true \
    -Duser.language=en -Duser.country=US -Dfile.encoding=UTF-8 \
    -Xloggc:/opt/elasticsearch-5.6.8/log/gc.log -verbose:gc \
    -XX:+PrintGCDetails -XX:+PrintGCDateStamps \
    -XX:+PrintGCTimeStamps -XX:+UseGCLogFileRotation \
    -XX:NumberOfGCLogFiles=8 -XX:GCLogFileSize=64M \
    -XX:+HeapDumpOnOutOfMemoryError -XX:+DisableExplicitGC \
    -Dcom.sun.management.jmxremote \
    -Dcom.sun.management.jmxremote.local.only=false \
    -Dcom.sun.management.jmxremote.authenticate=false \
    -Dcom.sun.management.jmxremote.ssl=false \
    -Djna.nosys=true -Djdk.io.permissionsUseCanonicalPath=true \
    -Dio.netty.noUnsafe=true -Dio.netty.noKeySetOptimization=true \
    -Dio.netty.recycler.maxCapacityPerThread=0 \
    -Dlog4j.shutdownHookEnabled=false \
    -Dlog4j2.disable.jmx=true -Dlog4j.skipJansi=true \
    -Des.path.home=/opt/elasticsearch-5.6.8 \
    -Des.logs.base_path=/opt/elasticsearch-5.6.8/log \
    -cp /opt/elasticsearch-5.6.8/config:/opt/elasticsearch-5.6.8/lib/* \
    org.elasticsearch.bootstrap.Elasticsearch &
echo -n $! > elasticsearch.pid

cd /var/lib/postgresql/10/main
pg_ctl -D /var/lib/postgresql/10/main -o "--config-file=/etc/postgresql/10/main/postgresql.conf" start

cd /opt/zookeeper && mkdir -p data log
echo '1' > /opt/zookeeper/data/myid
java \
    -Xms1G -Xmx1G -Djava.awt.headless=true \
    -Duser.language=en -Duser.country=US -Dfile.encoding=UTF-8 \
    -Xloggc:/opt/zookeeper/log/gc.log -verbose:gc \
    -XX:+PrintGCDetails -XX:+PrintGCDateStamps \
    -XX:+PrintGCTimeStamps -XX:+UseGCLogFileRotation \
    -XX:NumberOfGCLogFiles=8 -XX:GCLogFileSize=64M \
    -XX:+HeapDumpOnOutOfMemoryError -XX:+DisableExplicitGC \
    -Dcom.sun.management.jmxremote \
    -Dcom.sun.management.jmxremote.local.only=false \
    -Dcom.sun.management.jmxremote.authenticate=false \
    -Dcom.sun.management.jmxremote.ssl=false \
    -cp /opt/zookeeper/conf:/opt/zookeeper/zookeeper-3.4.13.jar:/opt/zookeeper/lib/* \
    -Dzookeeper.log.dir=/opt/zookeeper/log \
    -Dzookeeper.tracelog.dir=/opt/zookeeper/log \
    -Dzookeeper.root.logger=INFO,CONSOLE \
    org.apache.zookeeper.server.quorum.QuorumPeerMain \
    /opt/zookeeper/conf/zoo.cfg &
echo -n $! > zookeeper.pid

cd /opt/kafka && mkdir -p data log
java \
    -Xms1G -Xmx1G -Djava.awt.headless=true \
    -Duser.language=en -Duser.country=US -Dfile.encoding=UTF-8 \
    -Xloggc:/opt/kafka/log/gc.log -verbose:gc \
    -XX:+PrintGCDetails -XX:+PrintGCDateStamps \
    -XX:+PrintGCTimeStamps -XX:+UseGCLogFileRotation \
    -XX:NumberOfGCLogFiles=8 -XX:GCLogFileSize=64M \
    -XX:+HeapDumpOnOutOfMemoryError -XX:+DisableExplicitGC \
    -Dcom.sun.management.jmxremote \
    -Dcom.sun.management.jmxremote.local.only=false \
    -Dcom.sun.management.jmxremote.authenticate=false \
    -Dcom.sun.management.jmxremote.ssl=false \
    -cp '/opt/kafka/libs/*' \
    -Dkafka.logs.dir=/opt/kafka/logs \
    -Dlog4j.configuration=file:/opt/kafka/config/log4j.properties \
    kafka.Kafka config/server.properties &
echo -n $! > kafka.pid

while true; do
    sleep 900
done
