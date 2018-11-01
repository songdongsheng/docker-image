#!/bin/bash

cat << EOF | su -l postgres
cd /opt/elasticsearch-5.6.8 && bin/elasticsearch &
echo -n $! > elasticsearch.pid
EOF

su -c 'pg_ctl -D /var/lib/postgresql/10/main -o "--config-file=/etc/postgresql/10/main/postgresql.conf" start' -l postgres

cat << EOF | su -l postgres
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
    -Dzookeeper.root.logger=INFO,CONSOLE \
    org.apache.zookeeper.server.quorum.QuorumPeerMain \
    /opt/zookeeper/conf/zoo.cfg &
echo -n $! > zookeeper.pid
EOF

cat << EOF | su -l postgres
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
EOF

while true; do
    sleep 900
done
