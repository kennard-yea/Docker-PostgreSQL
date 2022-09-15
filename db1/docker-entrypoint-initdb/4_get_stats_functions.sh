#!/bin/bash

function Get-PgDatabaseList {
  declare helpText='
  \r\r NAME
  \r    Get-PgDatabaseList
  \r\n DESCRIPTION
  \r    Connects to a database cluster and echos the list of all non-template databases. Cloud service databases like rdsadmin are also not included in the list. Relies on the environment variables PGHOST, PGPORT, PGDATABASE, and PGUSER for connection
  \r\n USAGE
  \r    Get-PgDatabaseList
  \r\n GLOBALS
  \r    Get-PgDatabaseList calls psql to collect its output, so all environment variables supported by psql are supported here.
  \r\n INPUTS
  \r    None
  \r\n OUTPUTS
  \r    Outputs the the list of all non-template databases. Cloud service databases like rdsadmin are also not included in the list.
  \r\n RETURNS
  \r    The return status of the psql command. Returns 0 if it finished normally, 1 if a fatal error of its own occurs (e.g., out of memory, file not found), 2 if the connection to the server went bad and the session was not interactive.
  \r\n'
  [[ ${1} == '--help' ]] && printf "${helpText}" && return 1
  
  psql -qwAXt --command="select datname from pg_database where datname not in ('rdsadmin') and datallowconn order by pg_database_size(datname) desc"
}

for database in $(Get-PgDatabaseList); do
    psql -f /tmp/get_pg_stats_functions.sql ${database}
done
