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
        [[ $($psql_noalign --command="show cluster_name") == "" ]] && \
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

# Connects to two PostgreSQL instances and determined which one is the standby of the other. Create a bash function for accepting the connection strings of two database clusters and confirming that one is the replica of another. Return one of the below options:
# 1. hostname W, port X is a streaming replica of hostname Y, port Z - exit code 0
# 2. Unable to connect to one (or both) of the given connection strings - exit code 1
# 3. hostname W, port X and hostname Y, port Z are not connected via streaming replication - exit code 2
# Inputs: Two strings, passed to respective "--dbname" flags. Must be valid PostgreSQL connection strings
# Outputs: 1, 2, or 3, respective two the three options described above. 1 means instance #1 is a replica, 2 means instance #2 is the replica, 3 means there is no replication connection
function crosscheck_replica()
{
  function crosscheck_replica_usage()
  {
    echo "crosscheck_replica [<psql_connstring>] [<psql_connstring>] [<psql_connstring>]"
    return 0
  }

  # There will be multiple ways to trigger code 2
  function return_two()
  {
    echo "dbname '${pg1_connstring}' and dbname ${pg2_connstring} are not connected via streaming replication" 1>&2
    return 2
  }

  local dbname_array=()
  for optarg in ${@}; do
    dbname_array=(${dbname_array[@]} "${optarg}")
  done

  local crosscheck_returncode=0
  local pgversion=()
  local pgisinrecovery=()

  for dbname in ${dbname_array[@]}; do
    ${psql_noalign} --dbname="${dbname}" --command="select null" 1>/dev/null || \
        crosscheck_returncode=$(( ${crosscheck_returncode} + 1 ))
  done

  if (( ${crosscheck_returncode} > 0 )); then
    echo "unable to connect to one or both of the given connection strings" 1>&2
    crosscheck_replica_usage
    return 1
  fi

  for dbname in ${dbname_array[@]}; do
    pgversion=(${pgversion[@]} $(get_pgversion "${dbname}"))
    pgisinrecovery=(${pgisinrecovery[@]} $(${psql_noalign} --dbname="${dbname}" --command="select pg_is_in_recovery()" ))
  done

  return 0
}
