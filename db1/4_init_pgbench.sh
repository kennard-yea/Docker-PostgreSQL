#!/bin/bash

pgbench --initialize --scale=$PGBENCH_SCALE --username=$PGBENCH_USER $PGBENCH_DB
