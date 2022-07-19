#!/bin/bash
#
# Contains generic bash functions for use in multiple scripts.
# THIS FILE IS A LIBRARY AND SHOULD ONLY CONTAIN FUNCTIONS
#

function Print-LogLinePrefix {
  declare helpText='
  \r\r NAME
  \r    Print-LogLinePrefix
  \r\n DESCRIPTION
  \r    Prints the prefix from input, with the below parameter expansions. Can be used later with sed or awk to prepend to log output
  \r    For compatibility with PostgreSQL, most expansions will match or be similar to the escape sequences for the log_line_prefix parameter.
  \r    Only the first of each parameter will be expanded.
  \r      %%m and %%t - Current date and time as interpereted by the GNU date command
  \r      %%p - Process PID as interpereted by the $$ variable
  \r      %%u - Current user as interpereted by the whoami command
  \r      %%h and %%r - Current hostname as interpereted by the hostname command
  \r      %%a - Current application being run as interpereted by the ${0} variable
  \r      %%d - Current PGDATABASE environment variable, or currentn user as interpereted by the whoami command (represents how postgres utilities will default to the logged in username)
  \r      %%q - In PostgreSQL tells non-session processes to stop, ignored in this function
  \r\n USAGE
  \r    Print-LogLinePrefix [logLinePrefix]
  \r\n GLOBALS
  \r    None
  \r\n INPUTS
  \r    (Required) The log line prefix to be expanded
  \r\n OUTPUTS
  \r    Outputs the modified line prefix
  \r\n RETURNS
  \r    Returns the result of the sed command used for parameter expansion
  \r\n'
  [[ ${1} == '--help' ]] && printf "${helpText}" && return 1

  # PGDATABASE will default to the logged in user's name, %d should too
  # Some escape sequences don't translate well from postgres to bash and should be ignored (%q)
  sed -re "s/%m/$(date +'%F %T')/g" \
    -re "s/%t/$(date) +'%F %T'/g" \
    -re "s/%p/$$/g" \
    -re "s/%u/$(whoami)/g" \
    -re "s/%(h|r)/$(hostname -s)/g" \
    -re "s/%a/${0}/g" \
    -re "s/%d/${PGDATABASE:-$(whoami)}/g" \
    -re "s/%(q)//g" \
    <<< ${@}

  return ${?}
}

# USAGE: Time-Command [command]
# Executes a command, command list, or pipeline and reports the runtime to STDERR once complete
function Time-Command {
  declare helpText='
  \r\r NAME
  \r    Time-Command
  \r\n DESCRIPTION
  \r    Executes a command, command list, or pipeline and reports the runtime to STDERR once complete
  \r\n USAGE
  \r    Time-Command [command]
  \r\n GLOBALS
  \r    None
  \r\n INPUTS
  \r    The arguments are concatenated together into a single command, which is then read and executed by eval
  \r\n OUTPUTS
  \r    Outputs the STDOUT and STDERR of the command to the same channels, plus the runtime of the command in STDERR
  \r\n RETURNS
  \r    The return status of the command is the return status of Time-Command. If there are no arguments or only empty arguments, the return status is zero
  \r\n'
  [[ ${1} == '--help' ]] && printf "${helpText}" && return 1

  start_date="$(date +%s)"
  eval $@
  return_code="$?"
  elapsed_seconds="$(( $(date +%s) - ${start_date} ))"
  elapsed_minutes="$(( ${elapsed_seconds} / 60 ))" && elapsed_seconds="$(( ${elapsed_seconds} % 60 ))"
  elapsed_hours="$(( ${elapsed_minutes} / 60 ))" && elapsed_minutes="$(( ${elapsed_minutes} % 60 ))"
  echo "Command completed in ${elapsed_hours} hours, ${elapsed_minutes} minutes, and ${elapsed_seconds} seconds" 1>&2

  return ${return_code}
}
