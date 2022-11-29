# Docker-PostgreSQL

Personal playground using Docker, primarily for playing with PostgreSQL scripts to make robust and portable utilities

## HOWTO

### Supply environment files

Create the below files and populate them with the appropriate contents

##### Powershell

```powershell
$postgres_pass=[guid]::NewGuid().ToString()
$pgbench_pass=[guid]::NewGuid().ToString()
$grafana_pass=[guid]::NewGuid().ToString()
$pgadmin_pgpass=[guid]::NewGuid().ToString()
$pgadmin_email="********"
$pgadmin_pass=[guid]::NewGuid().ToString()

echo "POSTGRES_PASSWORD=$postgres_pass
POSTGRES_USER=postgres
POSTGRES_DB=postgres
PGDATA=/var/lib/postgresql/data/15
PGPORT=5432
PGBENCH_PASSWORD=$pgbench_pass
PGBENCH_USER=pgbench
GRAFANA_USER=grafana
GRAFANA_PASSWORD=$grafana_pass
PGADMIN_USER=pgadmin
PGADMIN_PASSWORD=$pgadmin_pgpass
" > primary-db-cluster/pgbench-primary.env

echo "PRIMARY_DBNAME=host=pgbench-primary
PGDATA=/var/lib/postgresql/data/15
" > replica-db-cluster/pgbench-replica.env

echo "PGADMIN_DEFAULT_EMAIL=$pgadmin_email
PGADMIN_DEFAULT_PASSWORD=$pgadmin_pass
PGADMIN_CONFIG_CONFIG_DATABASE_URI='postgresql://pgadmin:$pgadmin_pgpass@pgbench-primary:5432/pgadmin?options=-csearch_path=pgadmin'" > ./pgadmin/pgadmin.env
```

#### Bash

```bash
postgres_pass="$(cat /proc/sys/kernel/random/uuid)"
pgbench_pass="$(cat /proc/sys/kernel/random/uuid)"
grafana_pass="$(cat /proc/sys/kernel/random/uuid)"
pgadmin_pgpass="$(cat /proc/sys/kernel/random/uuid)"
pgadmin_email="********"
pgadmin_pass="$(cat /proc/sys/kernel/random/uuid)"

echo "POSTGRES_PASSWORD=$postgres_pass
POSTGRES_USER=postgres
POSTGRES_DB=postgres
PGDATA=/var/lib/postgresql/data/15
PGPORT=5432
PGBENCH_PASSWORD=$pgbench_pass
PGBENCH_USER=pgbench
PGBENCH_DB=pgbench
PGBENCH_SCALE=10
GRAFANA_USER=grafana
GRAFANA_PASSWORD=$grafana_pass
PGADMIN_USER=pgadmin
PGADMIN_PASSWORD=$pgadmin_pgpass
" > primary-db-cluster/pgbench-primary.env && chmod 0600 primary-db-cluster/pgbench-primary.env

echo "PRIMARY_DBNAME=host=pgbench-primary
PGDATA=/var/lib/postgresql/data/15
POSTGRES_PASSWORD=$postgres_pass
" > replica-db-cluster/pgbench-replica.env && chmod 0600 replica-db-cluster/pgbench-replica.env

echo "PGADMIN_DEFAULT_EMAIL=$pgadmin_email
PGADMIN_DEFAULT_PASSWORD=$pgadmin_pass
PGADMIN_CONFIG_CONFIG_DATABASE_URI='postgresql://pgadmin:$pgadmin_pgpass@pgbench-primary:5432/pgadmin?options=-csearch_path=pgadmin'" > pgadmin/pgadmin.env && chmod 0600 pgadmin/pgadmin.env
```

### Create stack

```sh
docker stack deploy --compose-file=docker-compose.yml postgresql
```

### Drop stack

```sh
docker stack rm postgresql
```
