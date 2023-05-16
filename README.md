# Docker-PostgreSQL

Personal playground using Docker, primarily for playing with PostgreSQL scripts to make robust and portable utilities

## HOWTO

### Supply environment files

Create the below files and populate them with the appropriate contents

##### Powershell

```powershell
[guid]::NewGuid().ToString() > database-primary/.postgres_password

echo "PGDATA=/var/lib/postgresql/data/15
PGPORT=5432
POSTGRES_DB=postgres
POSTGRES_PASSWORD_FILE=/run/secrets/postgres_password
POSTGRES_USER=postgres" > primary-db-cluster/oltp-primary.env

echo "PGDATA=/var/lib/postgresql/data/15
POSTGRES_PASSWORD_FILE=/run/secrets/postgres_password
PRIMARY_DBNAME=host=oltp-primary" > database-replica/oltp-replica.env

Write-Output "oltp-primary:5432:*:postgres:$(Get-Content .\oltp-cluster\.postgres_password)" > oltp-cluster/replica/.replication_pgpass
```

#### Bash

```bash
cat /proc/sys/kernel/random/uuid > primary-db-cluster/.postgres_password && chmod 0400 primary-db-cluster/.postgres_password

echo "PGDATA=/var/lib/postgresql/data/15
PGPORT=5432
POSTGRES_DB=postgres
POSTGRES_PASSWORD_FILE=/run/secrets/postgres_password
POSTGRES_USER=postgres" > primary-db-cluster/pgbench-primary.env

echo "PGDATA=/var/lib/postgresql/data/15
POSTGRES_PASSWORD_FILE=/run/secrets/postgres_password
PRIMARY_DBNAME=host=pgbench-primary" > replica-db-cluster/pgbench-replica.env
```

### Create stack

```sh
docker stack deploy --compose-file=docker-compose.yml postgresql
```

### Drop stack

```sh
docker stack rm postgresql
```
