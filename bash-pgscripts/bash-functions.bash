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

function time_command()
{
  function time_command_usage()
  {
    echo "time_command [<command>] [<command parameters>]" 1>&2
    return 0
  }
  return 0
}
