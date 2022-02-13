#!/bin/bash
# Initializes a database and user for pgbench

# usage: file_env VAR [DEFAULT]
#    ie: file_env 'XYZ_DB_PASSWORD' 'example'
# (will allow for "$XYZ_DB_PASSWORD_FILE" to fill in the value of
#  "$XYZ_DB_PASSWORD" from a file, especially for Docker's secrets feature)
function file_env() {
        local var="$1"
        local fileVar="${var}_FILE"
        local def="${2:-}"
        if [ "${!var:-}" ] && [ "${!fileVar:-}" ]; then
                echo >&2 "error: both $var and $fileVar are set (but are exclusive)"
                exit 1
        fi
        local val="$def"
        if [ "${!var:-}" ]; then
                val="${!var}"
        elif [ "${!fileVar:-}" ]; then
                val="$(< "${!fileVar}")"
        fi
        export "$var"="$val"
        unset "$fileVar"
}

# usage: init_users
# creates user for use in pgbench testing. Requires global environment variables PGBENCH_USER and PGBENCH_PASSWORD
function init_users() {
    createuser --echo --login "$PGBENCH_USER"
    createuser --echo --login "$GRAFANA_USER"
    psql --command="ALTER USER $PGBENCH_USER PASSWORD '$PGBENCH_PASSWORD'"
    psql --command="ALTER USER $GRAFANA_USER PASSWORD '$GRAFANA_PASSWORD'"
    return 0
}

# usage: init_dbs
# creates database for use in pgbench testing. Requires global environment variables PGBENCH_USER and PGBENCH_DB
function init_dbs() {
    createdb --echo --owner="$PGBENCH_USER" $PGBENCH_DB
    createdb --echo --owner="$GRAFANA_USER" grafana
    return 0
}

function init_extensions() {
    psql --command="CREATE EXTENSION pgagent" postgres
}

# usage: pgbench_init
# initializes pgbench to $PGBENCH_SCALE scale. Requires global environment variabbles PGBENCH_USER, PGBENCH_DB, and PGBENCH_SCALE
function pgbench_init() {
    pgbench --initialize --scale=$PGBENCH_SCALE --username=$PGBENCH_USER $PGBENCH_DB
    return 0
}

function main() {
    file_env PGBENCH_PASSWORD
    init_users
    init_dbs
    init_extensions
    pgbench_init
    return 0
}

if [[ $0 != "/bin/bash" ]]; then
    main
fi

exit 0
