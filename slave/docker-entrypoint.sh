#!/bin/bash
if [ ! -s "$PGDATA/PG_VERSION" ]; then
echo "*:*:*:$PG_REP_USER:$PG_REP_PASSWORD" > ~/.pgpass
chmod 0600 ~/.pgpass
until pg_basebackup -h ${PG_MASTER} -p 6662 -D ${PGDATA} -U ${PG_REP_USER} -P -Xs -R
do
echo "Waiting for master to connect..."
sleep 1s
done
cat >> ${PGDATA}/postgresql.conf <<EOF
max_standby_archive_delay = 300s
max_standby_streaming_delay = 300s
EOF
echo "host replication all 0.0.0.0/0 md5" >> "$PGDATA/pg_hba.conf"
set -e
echo "hello1"
cat > ${PGDATA}/recovery.conf <<EOF
standby_mode = on
primary_conninfo = 'host=$PG_MASTER port=6662 user=$PG_REP_USER password=$PG_REP_PASSWORD'
trigger_file = '/tmp/touch_me_to_promote_to_me_master'
EOF
echo "hello2"
chown postgres. ${PGDATA} -R
echo "hello3"
chmod 700 ${PGDATA} -R
echo "hello4"
fi
echo "hello5"
sed -i 's/wal_level = hot_standby/wal_level = replica/g' ${PGDATA}/postgresql.conf
echo "hello6"
exec "$@"