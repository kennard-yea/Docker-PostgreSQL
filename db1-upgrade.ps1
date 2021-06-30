docker build -f .\db1-12-to-13\db1-12-to-13.dockerfile --tag db1-12-to-13:upgrade .\db1-12-to-13\

docker-compose stop

docker run --rm `
    --name db1-12-to-13-check `
    --env POSTGRES_PASSWORD=riUXVtL4eAwB7Yse8y `
    --env POSTGRES_USER=postgres `
    --env POSTGRES_DB=postgres `
    --env PGDATA=/var/lib/postgresql/data `
    --volumes-from docker-postgresql_db1_1 `
    --mount type=volume,source=docker-postgresql_db1-data-vol-v12,target=/var/lib/postgresql/12/data `
    --mount type=volume,source=docker-postgresql_db1-data-vol-v13,target=/var/lib/postgresql/data `
    --user postgres `
    --workdir /tmp/ `
    db1-12-to-13:upgrade `
    /bin/bash -c "/usr/lib/postgresql/12/bin/pg_ctl -D /var/lib/postgresql/12/data start && /usr/lib/postgresql/13/bin/pg_upgrade \
        -d /var/lib/postgresql/12/data \
        -D /var/lib/postgresql/data \
        -b /usr/lib/postgresql/12/bin/ \
        -B /usr/lib/postgresql/13/bin/ \
        --check"

docker run --rm `
    --name db1-12-to-13-upgrade `
    --env POSTGRES_PASSWORD=riUXVtL4eAwB7Yse8y `
    --env POSTGRES_USER=postgres `
    --env POSTGRES_DB=postgres `
    --env PGDATA=/var/lib/postgresql/data `
    --volumes-from docker-postgresql_db1_1 `
    --mount type=volume,source=docker-postgresql_db1-data-vol-v12,target=/var/lib/postgresql/12/data `
    --mount type=volume,source=docker-postgresql_db1-data-vol-v13,target=/var/lib/postgresql/data `
    --user postgres `
    --workdir /tmp/ `
    db1-12-to-13:upgrade `
    /bin/bash -c "cp /var/lib/postgresql/12/data/*conf* /var/lib/postgresql/data/ \
        && /usr/lib/postgresql/13/bin/pg_upgrade \
        -d /var/lib/postgresql/12/data \
        -D /var/lib/postgresql/data \
        -b /usr/lib/postgresql/12/bin/ \
        -B /usr/lib/postgresql/13/bin/"

docker-compose down
