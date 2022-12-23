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
    createuser --echo --login "$PGADMIN_USER"
    createuser --echo --login "$BEAVER_USER"
    createuser --echo --login "$ZABBIX_USER"
    psql --command="ALTER USER $PGBENCH_USER PASSWORD '$PGBENCH_PASSWORD'"
    psql --command="ALTER USER $GRAFANA_USER PASSWORD '$GRAFANA_PASSWORD'"
    psql --command="ALTER USER $PGADMIN_USER PASSWORD '$PGADMIN_PASSWORD'"
    psql --command="ALTER USER $BEAVER_USER PASSWORD '$BEAVER_PASSWORD'"
    psql --command="ALTER RUSER $ZABBIX_USER PASSWORD '$ZABBIX_PASSWORD'"
    return 0
}

function main() {
    file_env PGBENCH_PASSWORD
    file_env GRAFANA_PASSWORD
    file_env PGADMIN_PASSWORD
    init_users
    return 0
}

if [[ $0 != "/bin/bash" ]]; then
    main
fi
