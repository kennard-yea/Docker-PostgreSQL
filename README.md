# Docker-PostgreSQL

Personal playground using Docker, primarily for playing with PostgreSQL scripts to make robust and portable utilities

## HOWTO

### Supply environment files

Create the below files and populate them with the appropriate contents

##### Powershell

```powershell
[guid]::NewGuid().ToString() > oltp-cluster/.postgres_password

echo "PGDATA=/var/lib/postgresql/data/16
PGPORT=5432
POSTGRES_DB=postgres
POSTGRES_PASSWORD_FILE=/run/secrets/postgres_password
POSTGRES_USER=postgres" > oltp-cluster/etc/oltp-primary.env

echo "PGDATA=/var/lib/postgresql/data/16
POSTGRES_PASSWORD_FILE=/run/secrets/postgres_password
PRIMARY_DBNAME=host=oltp-primary" > oltp-cluster/etc/oltp-replica.env

Write-Output "oltp-primary:5432:*:postgres:$(Get-Content .\oltp-cluster\.postgres_password)" > oltp-cluster/replica/.replication_pgpass
```

#### Bash / Zsh

```bash
cat /proc/sys/kernel/random/uuid > oltp-cluster/.postgres_password && chmod 0400 oltp-cluster/.postgres_password

echo "PGDATA=/var/lib/postgresql/data/16
PGPORT=5432
POSTGRES_DB=postgres
POSTGRES_PASSWORD_FILE=/run/secrets/postgres_password
POSTGRES_USER=postgres" > oltp-cluster/etc/oltp-primary.env

echo "PGDATA=/var/lib/postgresql/data/16
POSTGRES_PASSWORD_FILE=/run/secrets/postgres_password
PRIMARY_DBNAME=host=pgbench-primary
PGPASS=/run/secrets/replication_pgpass" > oltp-cluster/etc/oltp-replica.env
```

### Create stack

```sh
docker stack deploy --compose-file=docker-compose.yml postgresql
```

### Drop stack

```sh
docker stack rm postgresql
```
