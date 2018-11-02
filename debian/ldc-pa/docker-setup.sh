#!/bin/bash

cat << EOF >  /etc/apt/apt.conf.d/80setting
APT::Install-Recommends "0";
APT::Install-Suggests "0";
Acquire::http { Proxy "http://192.168.180.102:3128"; };
EOF

apt-get update && apt-get dist-upgrade -y
apt-get install -y ca-certificates curl libterm-ui-perl gnupg gnupg-agent

apt-key add /opt/0x7FCC7D46ACCC4CF8.asc

cat << EOF > /etc/apt/sources.list
deb http://cdn-aws.deb.debian.org/debian/ stretch main contrib non-free
deb http://cdn-aws.deb.debian.org/debian/ stretch-updates main contrib non-free
deb http://cdn-aws.deb.debian.org/debian/ stretch-proposed-updates main contrib non-free
deb http://cdn-aws.deb.debian.org/debian/ stretch-backports main contrib non-free
deb http://security.debian.org/debian-security stretch/updates main contrib non-free
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

/bin/mv /opt/limits.conf /etc/security/limits.conf

/bin/mv /opt/pg_hba.conf /etc/postgresql/10/main/pg_hba.conf
/bin/mv /opt/postgresql.conf /etc/postgresql/10/main/postgresql.conf

/bin/mv /opt/zoo.cfg /opt/zookeeper-3.4.13/conf
/bin/mv /opt/server.properties /opt/kafka_2.12-2.0.0/config
cd /opt && ln -s zookeeper-3.4.13 zookeeper && ln -s kafka_2.12-2.0.0 kafka

/bin/mv /opt/jvm.options /opt/elasticsearch-5.6.8/config
chown -R postgres:postgres /var/lib/postgresql/.profile /opt
source /root/.profile

su -c 'pg_ctl -D /var/lib/postgresql/10/main -o "--config-file=/etc/postgresql/10/main/postgresql.conf" start' -l postgres

cat << EOF | su -c 'psql' -l postgres
CREATE ROLE rdc LOGIN PASSWORD 'gDbEaa8c'
     SUPERUSER INHERIT CREATEDB CREATEROLE REPLICATION;

CREATE DATABASE meta_rdc
  WITH OWNER = rdc
       ENCODING = 'UTF-8';

CREATE ROLE meta_next LOGIN PASSWORD 'gDbEaa8c'
     SUPERUSER INHERIT CREATEDB CREATEROLE REPLICATION;

CREATE DATABASE meta_next
  WITH OWNER = meta_next
       ENCODING = 'UTF-8';
EOF

: <<'END_COMMENT'
PGPASSWORD=gDbEaa8c psql -P pager -h 127.0.0.1 -p 5432 -U rdc -d meta_rdc
PGPASSWORD=gDbEaa8c psql -P pager -h 127.0.0.1 -p 5432 -U meta_next -d meta_next

du -ms META_RDC_SCHEMA.sql; du -ms META_RDC_DATA.sql

# IDE
PGPASSWORD=gDbEaa8c pg_dump -h 39.107.111.176 -p 5432 -U meta_next -d meta_next -s \
    -t kafka_api_log -t ldc_event -t ldc_job_track -t meta_api_log -t meta_data \
    -t notification_queue -t tcc_crud_rollback -t tcc_dtc_rollback \
    -f META_RDC_SCHEMA.sql
PGPASSWORD=gDbEaa8c pg_dump -h 39.107.111.176 -p 5432 -U meta_next -d meta_next -a \
    -t ldc_event -t meta_data\
    -f META_RDC_DATA.sql

# SIT
PGPASSWORD=gDbEaa8c pg_dump -h 139.159.231.200 -p 5432 -U rdc -d meta_rdc -s \
    -t kafka_api_log -t ldc_event -t ldc_job_track -t meta_api_log -t meta_data \
    -t notification_queue -t tcc_crud_rollback -t tcc_dtc_rollback \
    -f META_RDC_SCHEMA.sql
PGPASSWORD=gDbEaa8c pg_dump -h 139.159.231.200 -p 5432 -U rdc -d meta_rdc -a \
    -t ldc_event -t meta_data\
    -f META_RDC_DATA.sql

# LIVE - DB-03
PGPASSWORD=gDbEaa8c pg_dump -h 39.107.93.253 -p 5432 -U rdc -d meta_rdc -s \
    -t kafka_api_log -t ldc_event -t ldc_job_track -t meta_api_log -t meta_data \
    -t notification_queue -t tcc_crud_rollback -t tcc_dtc_rollback \
    -f META_RDC_SCHEMA.sql
PGPASSWORD=gDbEaa8c pg_dump -h 39.107.93.253 -p 5432 -U rdc -d meta_rdc -a \
    -t ldc_event -t meta_data\
    -f META_RDC_DATA.sql

END_COMMENT

export PGPASSWORD=gDbEaa8c
psql --quiet --echo-errors -h 127.0.0.1 -p 5432 -U rdc -d meta_rdc -1qb -f /opt/META_RDC_SCHEMA.sql
psql --quiet --echo-errors -h 127.0.0.1 -p 5432 -U rdc -d meta_rdc -1qb -f /opt/META_RDC_DATA.sql

cat << EOF | su -l postgres
cd /opt/elasticsearch-5.6.8 && bin/elasticsearch &
EOF

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

curl 'localhost:9200/_flush?pretty&wait_if_ongoing=true'
curl -sS 127.0.0.1:9200/_cat/indices
curl -sS 127.0.0.1:9200/_cat/aliases
psql -h 127.0.0.1 -p 5432 -U rdc -d meta_rdc -A --tuples-only -c "SELECT COUNT(*) FROM META_DATA"

su -c 'pg_ctl -D /var/lib/postgresql/10/main -o "--config-file=/etc/postgresql/10/main/postgresql.conf" stop' -l postgres
chown -R postgres:postgres /opt
rm -f /opt/docker-setup.sh /opt/META_RDC_SCHEMA.sql /opt/META_RDC_DATA.sql /opt/0x7FCC7D46ACCC4CF8.asc /opt/jvm.options /opt/baas-indexer-1.0-SNAPSHOT.jar /opt/log-baas-indexer-*.txt
