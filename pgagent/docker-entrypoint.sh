#!/bin/bash

PGHOST=${PGHOST:-localhost}
PGDATABASE=${PGDATABASE:-postgres}
PGUSER=${PGUSER:-postgres}
PGPORT=${PGPORT:-5432}
LOG_LVL=${LOG_LVL:0}

pgagent -f -l${LOG_LVL} host=${PGHOST} port=${PGPORT} dbname=${PGDATABASE} user=${PGUSER}
