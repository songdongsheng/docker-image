export JAVA_HOME=/opt/jdk-8
export PATH=/usr/sbin:/usr/bin:/sbin:/bin:/opt/jdk-8/bin:/opt/jdk-8/jre/bin

cd /opt/baas-composite/ ; java \
    -Xmx512m \
    -Duser.language=en -Duser.country=US -Dfile.encoding=UTF-8 -Djava.awt.headless=true \
    -Dpara.homepage="http://39.107.111.176" \
    -Dpara.db.url="jdbc:postgresql://ldc-pa-01:5432/meta_rdc?stringtype=unspecified" \
    -Dpara.db.username=rdc -Dpara.db.password=gDbEaa8c \
    -jar baas-composite-1.0-SNAPSHOT.jar &
echo -n $! > composite.pid

cd /opt/baas-etl/ ; java \
    -Xmx512m \
    -Duser.language=en -Duser.country=US -Dfile.encoding=UTF-8 -Djava.awt.headless=true \
    -Dbaas.jdbc.url="jdbc:postgresql://ldc-pa-01:5432/meta_rdc?stringtype=unspecified" \
    -Dbaas.jdbc.username="rdc" -Dbaas.jdbc.password="gDbEaa8c" \
    -Dolap.jdbc.url="jdbc:postgresql://ldc-pa-01:5432/meta_rdc?stringtype=unspecified" \
    -Dolap.jdbc.username="rdc" -Dolap.jdbc.password="gDbEaa8c" \
    -Dserver.port=9695 \
    -jar baas-etl-1.0-SNAPSHOT.jar &
echo -n $! > etl.pid

cd /opt/baas-mybaas/ ; java \
    -Xmx512m \
    -Duser.language=en -Duser.country=US -Dfile.encoding=UTF-8 -Djava.awt.headless=true \
    -Dconfig.file=application.conf \
    -Dpara.es.transportclient_host="ldc-pa-01" \
    -Dpara.jdbc.url="jdbc:postgresql://ldc-pa-01:5432/meta_rdc?stringtype=unspecified" \
    -Dpara.jdbc.username="rdc" -Dpara.jdbc.password="gDbEaa8c" \
    -jar para-1.26.3-SNAPSHOT.war &
echo -n $! > baas.pid

cd /opt/baas-notification/ ; java \
    -Xmx512m \
    -Duser.language=en -Duser.country=US -Dfile.encoding=UTF-8 -Djava.awt.headless=true \
    -Dpara.db.url="jdbc:postgresql://ldc-pa-01:5432/meta_rdc?stringtype=unspecified" \
    -Dpara.db.username="rdc" -Dpara.db.password="gDbEaa8c" \
    -jar baas-websocket-1.0-SNAPSHOT.jar &
echo -n $! > websocket.pid

cd /opt/baas-olap/ ; java \
    -Xmx1536m \
    -Duser.language=en -Duser.country=US -Dfile.encoding=UTF-8 -Djava.awt.headless=true \
    -Dbaas.jdbc.url="jdbc:postgresql://ldc-pa-01:5432/meta_rdc?stringtype=unspecified" \
    -Dbaas.jdbc.username="rdc" -Dbaas.jdbc.password="gDbEaa8c" \
    -Dolap.jdbc.url="jdbc:postgresql://ldc-pa-01:5432/meta_rdc?stringtype=unspecified" \
    -Dolap.jdbc.username="rdc" -Dolap.jdbc.password="gDbEaa8c" \
    -Dloader.path=. \
    -jar baas-olap-1.0-SNAPSHOT.jar &
echo -n $! > olap.pid

cd /opt/baas-workflow/ ; java \
    -Xmx512m \
    -Duser.language=en -Duser.country=US -Dfile.encoding=UTF-8 -Djava.awt.headless=true \
    -Dspring.datasource.url="jdbc:postgresql://ldc-pa-01:5432/meta_rdc?stringtype=unspecified" \
    -Dspring.datasource.username="rdc" -Dspring.datasource.password="gDbEaa8c" \
    -Dbaas.jdbc.url="jdbc:postgresql://ldc-pa-01:5432/meta_rdc?stringtype=unspecified" \
    -Dbaas.jdbc.username="rdc" -Dbaas.jdbc.password="gDbEaa8c" \
    -Dpara.api.host="http://localhost:8080" \
    -Dpara.api.token="18588812307::11111111" \
    -jar baas-workflow-1.0.jar &
echo -n $! > workflow.pid

while true; do
    sleep 900
done
