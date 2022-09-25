#!/bin/bash

for config_file in $(ls /tmp/*.conf); do
    chmod 600 ${config_file}
    mv ${config_file} $PGDATA/
done
