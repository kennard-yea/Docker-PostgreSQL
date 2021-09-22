# Docker-PostgreSQL

Personal playground using Docker, primarily for playing with PostgreSQL scripts to make robust and portable utilities

## HOWTO

### Supply hidden files

Create the below files and populate them with the appropriate contents

```list
db1/.pgpass - pgpass file for db1 image. Contains password entries for all users across all databases
db1/.postgres_password - password file for generating the db1 postgres user
db1/.pgbench_password - password file for generating the db1 pgbench user
db1/.pgpass - pgpass file for db3 image - identical to db1/.pgpass
db3/.postgres_password - password file for generating the db3 postgres user
```

### Create stack (requires building db1 image then deploying stack)

```sh
docker image build --tag internal/db1 db1
docker image build --tag internal/db3 db3
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
