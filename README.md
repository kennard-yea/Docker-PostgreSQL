# Docker-PostgreSQL

Personal playground using Docker, primarily for playing with PostgreSQL scripts to make robust and portable utilities

## HOWTO

### Supply environment files

Create the below files and populate them with the appropriate contents

##### Powershell

```powershell
[guid]::NewGuid().ToString() > primary-db-cluster/.postgres_password
[guid]::NewGuid().ToString() > primary-db-cluster/.pgbench_password
[guid]::NewGuid().ToString() >  primary-db-cluster/.grafana_password
[guid]::NewGuid().ToString() > primary-db-cluster/.pgadmin_password
Write-Output "pgbench-primary:5432:pgadmin:pgadmin:$(Get-Content .\primary-db-cluster\.pgadmin_password)" > pgadmin/.pgadmin_pgpass
$pgadmin_email="********"
[guid]::NewGuid().ToString() > pgadmin/.pgadmin_default_password

echo "GRAFANA_PASSWORD_FILE=/run/secrets/grafana_password
GRAFANA_USER=grafana
PGADMIN_PASSWORD_FILE=/run/secrets/pgadmin_password
PGADMIN_USER=pgadmin
PGBENCH_PASSWORD_FILE=/run/secrets/pgbench_password
PGBENCH_USER=pgbench
PGDATA=/var/lib/postgresql/data/15
PGPORT=5432
POSTGRES_DB=postgres
POSTGRES_PASSWORD_FILE=/run/secrets/postgres_password
POSTGRES_USER=postgres" > primary-db-cluster/pgbench-primary.env

echo "PGDATA=/var/lib/postgresql/data/15
POSTGRES_PASSWORD_FILE=/run/secrets/postgres_password
PRIMARY_DBNAME=host=pgbench-primary" > replica-db-cluster/pgbench-replica.env

echo "PGADMIN_CONFIG_CONFIG_DATABASE_URI='postgresql://pgadmin@pgbench-primary:5432/pgadmin?options=-csearch_path=pgadmin'
PGADMIN_DEFAULT_EMAIL=$pgadmin_email
PGADMIN_DEFAULT_PASSWORD_FILE=/run/secrets/pgadmin_default_password
PGPASSFILE=/run/secrets/pgadmin_pgpass" > ./pgadmin/pgadmin.env
```

#### Bash

```bash
cat /proc/sys/kernel/random/uuid > primary-db-cluster/.postgres_password && chmod 0400 primary-db-cluster/.postgres_password
cat /proc/sys/kernel/random/uuid > primary-db-cluster/.pgbench_password && chmod 0400 primary-db-cluster/.pgbench_password
cat /proc/sys/kernel/random/uuid > primary-db-cluster/.grafana_password && chmod 0400 primary-db-cluster/.grafana_password
cat /proc/sys/kernel/random/uuid > primary-db-cluster/.pgadmin_password && chmod 0400 primary-db-cluster/.pgadmin_password
echo "pgbench-primary:5432:pgadmin:pgadmin:$(cat .\primary-db-cluster\.pgadmin_password)" > pgadmin/.pgadmin_pgpass && chmod 0400 pgadmin/.pgadmin_pgpass
pgadmin_email="********"
cat /proc/sys/kernel/random/uuid > pgadmin/.pgadmin_default_password && chmod 0400 pgadmin/.pgadmin_default_password

echo "GRAFANA_PASSWORD_FILE=/run/secrets/grafana_password
GRAFANA_USER=grafana
PGADMIN_PASSWORD_FILE=/run/secrets/pgadmin_password
PGADMIN_USER=pgadmin
PGBENCH_PASSWORD_FILE=/run/secrets/pgbench_password
PGBENCH_USER=pgbench
PGDATA=/var/lib/postgresql/data/15
PGPORT=5432
POSTGRES_DB=postgres
POSTGRES_PASSWORD_FILE=/run/secrets/postgres_password
POSTGRES_USER=postgres" > primary-db-cluster/pgbench-primary.env

echo "PGDATA=/var/lib/postgresql/data/15
POSTGRES_PASSWORD_FILE=/run/secrets/postgres_password
PRIMARY_DBNAME=host=pgbench-primary" > replica-db-cluster/pgbench-replica.env

echo "PGADMIN_CONFIG_CONFIG_DATABASE_URI='postgresql://pgadmin@pgbench-primary:5432/pgadmin?options=-csearch_path=pgadmin'
PGADMIN_DEFAULT_EMAIL=$pgadmin_email
PGADMIN_DEFAULT_PASSWORD_FILE=/run/secrets/pgadmin_default_password
PGPASSFILE=/run/secrets/pgadmin_pgpass" > ./pgadmin/pgadmin.env
```

### Create stack

```sh
docker stack deploy --compose-file=docker-compose.yml postgresql
```

### Drop stack

```sh
docker stack rm postgresql
```
