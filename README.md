# postgres-hot-standby
Terraform + Docker + Postgres + autossh port forwarding + streaming replication + hot standby

## Master

```sh
# apply terraform plan
cd master
terraform init && terraform plan -out plan && terraform apply plan && rm plan
# open shell in container
docker exec -it postgres-master sh
# switch to postgres user
su postgres
# set up replication
psql -c "CREATE ROLE replicator WITH REPLICATION;"
echo "host replication replicator 172.18.0.1/32 trust" >> $PGDATA/pg_hba.conf
# reload configuration
psql -c "select pg_reload_conf()"
```

## Slave

1. Update `MASTER_USER` and `MASTER_HOST` in `slave/main.tf`
1. Expects `slave/id_rsa` and `slave/id_rsa.pub`

```sh
# apply terraform plan
cd master
terraform init && terraform plan -out plan && terraform apply plan && rm plan
```
