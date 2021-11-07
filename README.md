# Docker-PostgreSQL

Personal playground using Docker, primarily for playing with PostgreSQL scripts to make robust and portable utilities

## HOWTO

### Supply hidden files

Create the below files and populate them with the appropriate contents

```list
./db1/.pgpass - pgpass file for db1 image. Contains password entries for all users across all databases
./db1/.postgres_password - password file for generating the db1 postgres user
./db1/.pgbench_password - password file for generating the db1 pgbench user
./db2/.pgpass - pgpass file for db2 image. Identical to db1/.pgpass
./db3/.pgpass - pgpass file for db3 image. Identical to db1/.pgpass
./db3/.postgres_password - password file for generating the db3 postgres user
./db3/.pgbench_password - password file for generating the db3 pgbench user
```

```shell
$db1_postgres_pass="****************"
$db1_pgbench_pass="****************"
$db3_pgbench_pass="****************"
$db3_postgres_pass="****************"

echo "$db1_postgres_pass" > ./db1/.postgres_password
echo "$db1_pgbench_pass" > ./db1/.pgbench_password
echo "$db3_postgres_pass" > ./db3/.postgres_password
echo "$db3_pgbench_pass" > ./db3/.pgbench_password

echo "pgdb1:5432:*:postgres:$db1_postgres_pass
    pgdb2:5432:*:postgres:$db1_postgres_pass
    pgdb3:5432:*:postgres:$db3_postgres_pass
    pgdb1:5432:*:pgbench:$db1_pgbench_pass
    pgdb2:5432:*:pgbench:$db1_pgbench_pass
    pgdb3:5432:*:pgbench:$db3_pgbench_pass" > ./db1/.pgpass
echo "PGADMIN_DEFAULT_EMAIL=chrismdollinger@gmail.com" > ./pgadmin/pgadmin.env
echo "PGADMIN_DEFAULT_PASSWORD=****************" >> ./pgadmin/pgadmin.env
echo "PGPASSFILE=/var/lib/pgadmin/storage/chrismdollinger_gmail.com/.pgpass" >> ./pgadmin/pgadmin.env
cp ./db1/.pgpass ./db2/.pgpass
cp ./db1/.pgpass ./db3/.pgpass
cp ./db1/.pgpass ./pgadmin/.pgpass
```

### Create stack (requires building db1 image then deploying stack)

```sh
docker image build --tag internal/db1 db1
docker image build --tag internal/db2 db2
docker image build --tag internal/db3 db3
docker image build --tag internal/pgadmin pgadmin
docker stack deploy --compose-file=docker-compose.yml pgdb-stack
```

### Drop stack

```sh
docker stack rm pgdb-stack
```

## Run bash image

```sh
docker image build --tag internal/bash-pgscripts bash-pgscripts
docker run -it --rm --network pgdb-stack_db-net --network-alias bash-manager internal/bash-pgscripts
```
