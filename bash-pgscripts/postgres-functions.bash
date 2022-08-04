#!/bin/bash
#
# Contains shared functions relating to PostgreSQL databases.
# THIS FILE IS A LIBRARY AND SHOULD ONLY CONTAIN FUNCTIONS
#

function Get-PgVersion {
  declare helpText='
  \r\r NAME
  \r    Get-PgVersion
  \r\n DESCRIPTION
  \r    Connects to a database cluster and echos its major version number. Relies on the environment variables PGHOST, PGPORT, PGDATABASE, and PGUSER for connecting
  \r\n USAGE
  \r    Get-PgVersion
  \r\n GLOBALS
  \r    Get-PgVersion calls psql to collect its output, so all environment variables supported by psql are supported here.
  \r\n INPUTS
  \r    None
  \r\n OUTPUTS
  \r    Outputs the the major release of PostgreSQL stored in the PG_VERSION file of the database cluster
  \r\n RETURNS
  \r    The return status of the psql command. Returns 0 if it finished normally, 1 if a fatal error of its own occurs (e.g., out of memory, file not found), 2 if the connection to the server went bad and the session was not interactive.
  \r\n'
  [[ ${1} == '--help' ]] && printf "${helpText}" && return 1

  psql -qwAXt --command="select pg_read_file('PG_VERSION')"
  return ${?}
}

function Get-PgClusterName {
  declare helpText='
  \r\r NAME
  \r    Get-PgClusterName
  \r\n DESCRIPTION
  \r    Connects to a database cluster and echos the name of the cluster. Relies on the environment variables PGHOST, PGPORT, PGDATABASE, and PGUSER for connection
  \r\n USAGE
  \r    Get-PgClusterName
  \r\n GLOBALS
  \r    Get-PgClusterName calls psql to collect its output, so all environment variables supported by psql are supported here.
  \r\n INPUTS
  \r    None
  \r\n OUTPUTS
  \r    Outputs the the current setting of cluster_name. If cluster_name is not set or if the verson of PostgreSQL being connected to does not support cluster_name, output null.
  \r\n RETURNS
  \r    The return status of the psql command. Returns 0 if it finished normally, 1 if a fatal error of its own occurs (e.g., out of memory, file not found), 2 if the connection to the server went bad and the session was not interactive.
  \r\n'
  [[ ${1} == '--help' ]] && printf "${helpText}" && return 1

  local pgVersion="$(Get-PgVersion ${dbname})" || return $?

  if [[ ${pgVersion} =~ [987]\.[654321] ]]; then
    echo
    return 0
  fi

  psql -qwAXt --command="show cluster_name"
  return ${?}
}

function Get-PgLogLinePrefix {
  declare helpText='
  \r\r NAME
  \r    Get-PgLogLinePrefix
  \r\n DESCRIPTION
  \r    Connects to a database cluster and echos the log line prefix. Relies on the environment variables PGHOST, PGPORT, PGDATABASE, and PGUSER for connection
  \r\n USAGE
  \r    Get-PgLogLinePrefix
  \r\n GLOBALS
  \r    Get-PgLogLinePrefix calls psql to collect its output, so all environment variables supported by psql are supported here.
  \r\n INPUTS
  \r    None
  \r\n OUTPUTS
  \r    Outputs the the current setting of log_line_prefix.
  \r\n RETURNS
  \r    The return status of the psql command. Returns 0 if it finished normally, 1 if a fatal error of its own occurs (e.g., out of memory, file not found), 2 if the connection to the server went bad and the session was not interactive.
  \r\n'
  [[ ${1} == '--help' ]] && printf "${helpText}" && return 1

  psql -qwAXt --command="show log_line_prefix"
  return ${?}
}

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
  
  psql -qwAXt --command="select datname from pg_database where datname not in ('rdsadmin') and not datistemplate order by pg_database_size(datname) desc"
}
