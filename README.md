# Docker-PostgreSQL

Personal playground using Docker, primarily for playing with PostgreSQL scripts to make robust and portable utilities

## HOWTO

### Supply hidden files

Create the below files and populate them with the appropriate contents

```shell
$postgres_pass="********"
$pgbench_pass="********"
$grafana_pass="********"
$pgadmin_email="********"
$pgadmin_pass="********"

echo "POSTGRES_PASSWORD=$postgres_pass
POSTGRES_USER=postgres
POSTGRES_DB=postgres
PGDATA=/var/lib/postgresql/data
PGPORT=5432
PGBENCH_PASSWORD=$pgbench_pass
PGBENCH_USER=pgbench
PGBENCH_DB=pgbench
PGBENCH_SCALE=10
GRAFANA_USER=grafana
GRAFANA_PASSWORD=$grafana_pass
" > ./db1/db1.env

echo "POSTGRES_USER=postgres
POSTGRES_DB=postgres
PGDATA=/var/lib/postgresql/data
PGPORT=5432
POSTGRES_PRIMARY_HOST=pgdb1
" > ./db2/db2.env

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
