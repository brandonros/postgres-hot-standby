# postgres-hot-standby
Terraform + Docker + Postgres + stunnel + streaming replication + hot standby

## Master

```sh
# apply terraform plan
cd master
terraform init
terraform plan -out plan
terraform apply plan
rm plan
# open shell in container
docker exec -it postgres-master sh
# switch to postgres user
su postgres
# set up replication
psql -c "CREATE USER replicator WITH REPLICATION ENCRYPTED PASSWORD 'secret';"
echo "host replication replicator 127.0.0.1/32 md5" >> $PGDATA/pg_hba.conf # STANDBY_IP=127.0.0.1
# reload configuration
psql -c "select pg_reload_conf()"
```

## Standby

```
pg_basebackup -h $MASTER_IP -U replicator -p 5432 -D $PGDATA -Fp -Xs -P -R
```
