# Docker-PostgreSQL

Personal playground using Docker, primarily for playing with PostgreSQL scripts to make robust and portable utilities

## HOWTO

### Create stack (requires building db1 image then deploying stack)

```sh
docker image build --tag internal/db1 db1
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
