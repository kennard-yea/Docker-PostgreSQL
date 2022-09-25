#!/bin/bash
set -xEeo pipefail

docker_temp_server_start() {
	if [ "$1" = 'postgres' ]; then
		shift
	fi

	# internal start of server in order to allow setup using psql client
	# does not listen on external TCP/IP and waits until start finishes
	set -- "$@" -c listen_addresses='' -p "${PGPORT:-5432}"

	PGUSER="${PGUSER:-$POSTGRES_USER}" \
	pg_ctl -D "$PGDATA" \
		-o "$(printf '%q ' "$@")" \
		-w start
}

docker_temp_server_stop() {
	PGUSER="${PGUSER:-postgres}" \
	pg_ctl -D "$PGDATA" -m fast -w stop
}

new_pgpass() {
    host=$(echo ${PRIMARY_DBNAME} | egrep -o "host=([a-z]|[0-9])+" | cut -d"=" -f2)
    port=$(echo ${PRIMARY_DBNAME} | egrep -o "port=([a-z]|[0-9])+" | cut -d"=" -f2)
    dbname=$(echo ${PRIMARY_DBNAME} | egrep -o "dbname=([a-z]|[0-9])+" | cut -d"=" -f2)
    user=$(echo ${PRIMARY_DBNAME} | egrep -o "user=([a-z]|[0-9])+" | cut -d"=" -f2)

    echo "${host:-*}:${port:-*}:${dbname:-*}:${user:-*}:${POSTGRES_PASSWORD}" > $HOME/.pgpass && chmod 600 $HOME/.pgpass
}

check_primary() {
    for (( i=1; i<=12; i++ )); do
        psql -v ON_ERROR_STOP=1 --no-password --no-psqlrc --dbname="${PRIMARY_DBNAME}" -c "select null" >/dev/null && return 0 || \
            echo "Unable to connect with dbname \"${PRIMARY_DBNAME}\" - sleeping for 10 seconds" 1>&2
        sleep 10
    done

    echo "Connection to \"${PRIMARY_DBNAME}\" timed out after 120 seconds!" 1>&2

    return 1
}

if [ -r "$PGDATA/standby.signal" ]; then
    echo
    echo 'PostgreSQL Database directory already appears to be set up for streaming replication; Skipping base backup'
    echo
else
    if [[ -z ${PRIMARY_DBNAME} ]]; then
        echo "ERROR: The PRIMARY_DBNAME variable is not set. In order to build a replica, you will need to set this variable in your environment." 1>&2
        exit 1
    fi

    docker_temp_server_stop
    rm -rf $PGDATA

    if [ ! -r "$HOME/.pgpass" ]; then
        new_pgpass
    fi

    echo "Giving the primary time to initialize..."
    sleep 60
    check_primary || exit 1

   	if [ -n "${POSTGRES_INITDB_WALDIR:-}" ]; then
		PG_BASEBACKUP_ARGS="--waldir=${POSTGRES_INITDB_WALDIR}"
	fi

    eval 'pg_basebackup --pgdata="$PGDATA" --write-recovery-conf --wal-method=stream --checkpoint=fast --verbose --progress --dbname="${PRIMARY_DBNAME}"' "${PG_BASEBACKUP_ARGS}" || exit 1

    docker_temp_server_start
     
fi
