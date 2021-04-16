#!/bin/bash

psql_noinput="psql --no-psqlrc --no-password"
psql_noalign="${psql_noinput} --quiet --no-align --tuples-only"

# Echos the major release of PostgreSQL running at a given connection string
# Inputs: All arguments are passed to a psql "--dbname" flag, and therefore must make up a valid PostgreSQL connection string
# Outputs: The major release of the instance connected to, read from PG_VERSION in the data directory
function get_pgversion()
{
    function get_pgversion_usage()
    {
        echo "get_pgversion [<psql_connstring>]" 1>&2
        return 0
    }

    local pg_connstring="${@}"
    ${psql_noalign} --dbname="${pg_connstring}" --command="select null" 1>/dev/null # run a test psql to very connectivity

    case ${?} in
        0)
            local pgdata=$(${psql_noalign} --dbname="${pg_connstring}" --command="show data_directory")
            cat ${pgdata}/PG_VERSION
            return 0
        ;;

        *)
            echo "connection attempt failed to connection string ${pg_connstring}"
            get_pgversion_usage 1>&2
            return 1
        ;;
    esac
}

# Echo the name of the PostgreSQL cluster running at a given connection string
# Inputs: All arguments are passed to a psql "--dbname" flag, and therefore must make up a valid PostgreSQL connection string
# Outputs: The PostgreSQL cluster_name parameter. If version is less than 9.5 (when cluster_name was released), or a cluster name is not specified, 'main' is used instead
function get_pgclustername()
{
    function get_pgclustername_usage()
    {
        echo "get_pgclustername [<psql_connstring>]" 1>&2
        return 0
    }

    local pg_connstring="${@}"
    ${psql_noalign} --dbname="${pg_connstring}" --command="select null" 1>/dev/null # run a test psql to verify connectivity

    case ${?} in
        0)
            local pg_version="$(get_pgversion ${pg_connstring})"
            case ${pg_version} in
            "13" | "12" | "11" | "10" | "9.6" | "9.5")
                # if cluster_name is null, then use main, else use cluster_name
                [[ $($psql_noalign --command="show cluster_name") == "" ]] && echo "main" || \
                    ${psql_noalign} --dbname="${pg_connstring}" --command="show cluster_name"
                return 0
            ;;
            
            *)
                echo "main"
                return 0
            ;;
            esac
        ;;

        *)
            echo "connection attempt failed to connection string ${pg_connstring}"
            get_pgclustername_usage 1>&2
            return 1
        ;;
    esac
}
