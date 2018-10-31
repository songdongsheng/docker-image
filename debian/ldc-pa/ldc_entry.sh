#!/bin/bash

cat << EOF | su -l postgres
cd /opt/elasticsearch-5.6.8 && bin/elasticsearch &
echo -n $! > elasticsearch.pid
EOF

su -c 'pg_ctl -D /var/lib/postgresql/10/main -o "--config-file=/etc/postgresql/10/main/postgresql.conf" start' -l postgres

while true; do
    sleep 900
done
