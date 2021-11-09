#!/bin/bash
#
# Contains shared functions relating to PostgreSQL databases.
# THIS FILE IS A LIBRARY AND SHOULD ONLY CONTAIN FUNCTIONS
#

psql_noinput="psql --no-psqlrc --no-password"
psql_noalign="${psql_noinput} --quiet --no-align --tuples-only"

###########################################################
# get_pgversion - echos the major release of PostgreSQL at a connection string
# Globals: None
# Inputs: All arguments are passed to a psql "--dbname" flag
# Outputs: The major release read from PG_VERSION at a connection string
# Returns: 0 on successful output, 1 if unable to connect
###########################################################
function get_pgversion()
{
  function get_pgversion_usage()
  {
    echo "get_pgversion [<psql_connstring>]" 1>&2
    return 0
  }

  local dbname="${@}"
  ${psql_noalign} --dbname="${dbname}" --command="select null" 1>/dev/null

  case ${?} in
    0)
      # Run pg_read_file to read PG_VERSION in the cluster
      local pgversion=$(${psql_noalign} \
        --dbname="${dbname}" \
        --command="select pg_read_file('PG_VERSION')")
      echo ${pgversion}
      return 0
    ;;

    *)
      echo "connection attempt failed to connection string ${dbname}" 1>&2
      get_pgversion_usage 1>&2
      return 1
    ;;
  esac
}

###########################################################
# get_pgclustername - echo the PostgreSQL cluster name at a connection string
# Globals: None
# Inputs: All arguments are passed to a psql "--dbname" flag
# Outputs: The set cluster_name, or 'main' if not set or supported
# Returns: 0 on successful output, 1 if unable to connect
###########################################################
function get_pgclustername()
{
  function get_pgclustername_usage()
  {
    echo "get_pgclustername [<psql_connstring>]" 1>&2
    return 0
  }

  local dbname="${@}"
  ${psql_noalign} --dbname="${dbname}" --command="select null" 1>/dev/null

  case ${?} in
    0)
      local pg_version="$(get_pgversion ${dbname})"
      case ${pg_version} in
      "13" | "12" | "11" | "10" | "9.6" | "9.5")
        # if cluster_name is null, then use main, else use cluster_name
        [[ $($psql_noalign --dbname="${dbname}" --command="show cluster_name") == "" ]] && \
          echo "main" || \
          ${psql_noalign} --dbname="${dbname}" --command="show cluster_name" | \
          sed "s:\/:\-:g"
        return 0
      ;;
        
      *) # send 'main' if not set or supported
        echo "main"
        return 0
      ;;
      esac
    ;;

    *)
      echo "connection attempt failed to connection string ${dbname}" 1>&2
      get_pgclustername_usage 1>&2
      return 1
    ;;
  esac
}
