#!/bin/sh
pg_basebackup -w -h autossh -p 10000 -U replicator -D $PGDATA -Fp -Xs -P -R
chmod 0700 $PGDATA
su -c "postgres -c hot_standby=on -c primary_conninfo='user=replicator host=autossh port=10000'" postgres
