# Docker-PostgreSQL

Personal playground using Docker, primarily for playing with PostgreSQL scripts to make robust and portable utilities

## HOWTO

### Supply hidden files

Create the below files and populate them with the appropriate contents

##### Powershell

```powershell
$postgres_pass="********"
$pgbench_pass="********"
$grafana_pass="********"
$pgadmin_email="********"
$pgadmin_pass="********"

echo "POSTGRES_PASSWORD=$postgres_pass
POSTGRES_USER=postgres
POSTGRES_DB=postgres
PGDATA=/var/lib/postgresql/data/14
PGPORT=5432
PGBENCH_PASSWORD=$pgbench_pass
PGBENCH_USER=pgbench
PGBENCH_DB=pgbench
PGBENCH_SCALE=10
GRAFANA_USER=grafana
GRAFANA_PASSWORD=$grafana_pass
" > primary-db-cluster/pgbench-primary.env

echo "PRIMARY_DBNAME=host=pgbench-primary
PGDATA=/var/lib/postgresql/data/14
" > replica-db-cluster/pgbench-replica.env

echo "PGADMIN_DEFAULT_EMAIL=$pgadmin_email
PGADMIN_DEFAULT_PASSWORD=$pgadmin_pass
PGPASSFILE=/var/lib/pgadmin/storage/$($pgadmin_email.Replace('@','_'))/.pgpass" > ./pgadmin/pgadmin.env

echo "pgdb1:5432:*:postgres:$postgres_pass
pgdb2:5432:*:postgres:$postgres_pass
pgdb1:5432:*:pgbench:$pgbench_pass
pgdb2:5432:*:pgbench:$pgbench_pass
pgdb1:5432:*:grafana:$grafana_pass
pgdb2:5432:*:grafana:$grafana_pass" > ./db1/.pgpass
cp ./db1/.pgpass ./db2/.pgpass
cp ./db1/.pgpass ./pgadmin/.pgpass
cp ./db1/.pgpass ./pgagent/.pgpass
cp ./db1/.pgpass ./pgmetrics/.pgpass
```

#### Bash

```bash
postgres_pass="$(cat /proc/sys/kernel/random/uuid)"
pgbench_pass="$(cat /proc/sys/kernel/random/uuid)"
grafana_pass="$(cat /proc/sys/kernel/random/uuid)"
pgadmin_email="********"
pgadmin_pass="$(cat /proc/sys/kernel/random/uuid)"

echo "POSTGRES_PASSWORD=$postgres_pass
POSTGRES_USER=postgres
POSTGRES_DB=postgres
PGDATA=/var/lib/postgresql/data/14
PGPORT=5432
PGBENCH_PASSWORD=$pgbench_pass
PGBENCH_USER=pgbench
PGBENCH_DB=pgbench
PGBENCH_SCALE=10
GRAFANA_USER=grafana
GRAFANA_PASSWORD=$grafana_pass
" > primary-db-cluster/pgbench-primary.env && chmod 0600 primary-db-cluster/pgbench-primary.env

echo "PRIMARY_DBNAME=host=pgbench-primary
PGDATA=/var/lib/postgresql/data/14
POSTGRES_PASSWORD=$postgres_pass
" > replica-db-cluster/pgbench-replica.env && chmod 0600 replica-db-cluster/pgbench-replica.env

echo "PGADMIN_DEFAULT_EMAIL=$pgadmin_email
PGADMIN_DEFAULT_PASSWORD=$pgadmin_pass
PGPASSFILE=/var/lib/pgadmin/storage/${pgadmin_email//\@/\_}/.pgpass" > pgadmin/pgadmin.env && chmod 0600 pgadmin/pgadmin.env

echo "*:*:*:postgres:${postgres_pass}
*:*:*:pgbench:${pgbench_pass}
*:*:*:grafana:${grafana_pass}" > primary-db-cluster/.pgpass && chmod 600 primary-db-cluster/.pgpass
cp primary-db-cluster/.pgpass replica-db-cluster/
cp primary-db-cluster/.pgpass pgadmin/
cp primary-db-cluster/.pgpass pgagent/
cp primary-db-cluster/.pgpass pgmetrics/
```

### Create stack (requires building db1 image then deploying stack)

```sh
docker image build --tag internal/db1 db1
docker image build --tag internal/db2 db2
docker image build --tag internal/pgadmin pgadmin
docker image build --tag internal/pgmetrics pgmetrics
docker image build --tag internal/pgagent pgagent
docker stack deploy --compose-file=docker-compose.yml pgdb-stack
```

### Drop stack

```sh
docker stack rm pgdb-stack
```
