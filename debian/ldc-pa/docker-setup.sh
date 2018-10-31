#!/bin/bash

apt-get update && apt-get dist-upgrade -y
apt-get install -y ca-certificates curl libterm-ui-perl gnupg gnupg-agent

curl -sL "http://pool.sks-keyservers.net/pks/lookup?op=get&search=0x7FCC7D46ACCC4CF8" | apt-key add -

cat << EOF >> /etc/apt/sources.list
deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main
EOF
apt-get update && apt-get install -y postgresql-10

cat << EOF > /root/.bashrc
export JAVA_HOME=/opt/jdk-8
export PATH=/usr/sbin:/usr/bin:/sbin:/bin:/opt/jdk-8/bin:/opt/jdk-8/jre/bin:/usr/lib/postgresql/10/bin
EOF
cat << EOF > /var/lib/postgresql/.profile
export JAVA_HOME=/opt/jdk-8
export PATH=/usr/sbin:/usr/bin:/sbin:/bin:/opt/jdk-8/bin:/opt/jdk-8/jre/bin:/usr/lib/postgresql/10/bin
EOF
chown postgres:postgres /var/lib/postgresql/.profile /opt
source /root/.profile

su -c 'pg_ctl -D /var/lib/postgresql/10/main -o "--config-file=/etc/postgresql/10/main/postgresql.conf" start' -l postgres

cat << EOF | su -c 'psql' -l postgres
CREATE ROLE rdc LOGIN PASSWORD 'gDbEaa8c'
     SUPERUSER INHERIT CREATEDB CREATEROLE REPLICATION;

CREATE DATABASE meta_rdc
  WITH OWNER = rdc
       ENCODING = 'UTF-8';
EOF

export PGPASSWORD=gDbEaa8c
# PGPASSWORD=gDbEaa8c pg_dump -h 139.159.231.200 -p 5432 -U rdc -d meta_rdc -f META_RDC.sql   # SIT
# PGPASSWORD=gDbEaa8c pg_dump -h 39.107.93.253   -p 5432 -U rdc -d meta_rdc -f META_RDC.sql   # LIVE: DB-03

psql --quiet --echo-errors -h 127.0.0.1 -p 5432 -U rdc -d meta_rdc -1qb -f /opt/META_RDC.sql

cd /opt/elasticsearch-5.6.8 && bin/elasticsearch &
while true ; do
    rs=$(curl -isS http://127.0.0.1:9200/_cat/health -o /dev/null -w "%{http_code}\n")
    [ $rs -eq 200 ] && break
    sleep 1
done

cd /opt
export BAAS_INDEX="baas_"`/bin/date +"%Y%m%d_%H%M"`
java -Dbaas.jdbc.url="jdbc:postgresql://127.0.0.1:5432/meta_rdc?stringtype=unspecified" \
    -Dbaas.jdbc.username="rdc" \
    -Dbaas.jdbc.password="gDbEaa8c" \
    -Dindex.base.url="http://127.0.0.1:9200/" \
    -Dindex.name="${BAAS_INDEX}" \
    -jar baas-indexer-1.0-SNAPSHOT.jar
curl -sS -X PUT "127.0.0.1:9200/${BAAS_INDEX}/_alias/mybaas?pretty"
echo "Load data to ES done"

su -c 'pg_ctl -D /var/lib/postgresql/10/main -o "--config-file=/etc/postgresql/10/main/postgresql.conf" stop' -l postgres
chown -R postgres:postgres /opt
rm -f /opt/docker-setup.sh -f /opt/META_RDC.sql
