#!/bin/bash
#
# Contains generic bash functions for use in multiple scripts.
# THIS FILE IS A LIBRARY AND SHOULD ONLY CONTAIN FUNCTIONS
#

###########################################################
# test_libsource - returns 0 to confirm that the library was sourced correctly
# Globals: None
# Arguments: None
# Outputs: None
# Returns: 0
###########################################################
function test_libsource()
{
  return 0
}

###########################################################
# time_command - times execution of command or command list
# Globals: None
# Arguments: Command or command list (command lists do not work yet)
# Outputs: Command or command list output and runtime
# Returns: Return code of command or command list
###########################################################
function time_command()
{
  function time_command_usage()
  {
    echo "time_command [<command>] [<command parameters>]" 1>&2
    return 0
  }

  start_date="$(date +%s)"
  eval $@
  return_code="$?"
  elapsed_seconds="$(( $(date +%s) - ${start_date} ))"
  elapsed_minutes="$(( ${elapsed_seconds} / 60 ))" && elapsed_seconds="$(( ${elapsed_seconds} % 60 ))"
  elapsed_hours="$(( ${elapsed_minutes} / 60 ))" && elapsed_minutes="$(( ${elapsed_minutes} % 60 ))"
  echo "Command completed in ${elapsed_hours} hours, ${elapsed_minutes} minutes, and ${elapsed_seconds} seconds" 1>&2

  return ${return_code}
}
