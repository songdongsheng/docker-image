export JAVA_HOME=/opt/jdk-8
export PATH=/usr/sbin:/usr/bin:/sbin:/bin:/opt/jdk-8/bin:/opt/jdk-8/jre/bin
cd /opt/ && java \
    -Djava.awt.headless=true \
    -Xmx512M -Xms512M -Djava.awt.headless=true \
    -Duser.language=en -Duser.country=US -Dfile.encoding=UTF-8 \
    -Xloggc:/ci/baas-scg/gc.log -verbose:gc \
    -XX:+PrintGCDetails -XX:+PrintGCDateStamps \
    -XX:+PrintGCTimeStamps -XX:+UseGCLogFileRotation \
    -XX:NumberOfGCLogFiles=8 -XX:GCLogFileSize=64M \
    -XX:+HeapDumpOnOutOfMemoryError -XX:+DisableExplicitGC \
    -Dcom.sun.management.jmxremote \
    -Dcom.sun.management.jmxremote.local.only=false \
    -Dcom.sun.management.jmxremote.authenticate=false \
    -Dcom.sun.management.jmxremote.ssl=false \
    -Dreactor.netty.http.server.accessLogEnabled=true \
    -jar spring-cloud-gateway-service-1.0.0.jar
