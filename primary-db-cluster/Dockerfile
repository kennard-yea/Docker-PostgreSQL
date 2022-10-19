FROM    postgres:14
USER    postgres
COPY    --chown=postgres:postgres   tmp/get_pg_stats_functions.sql                       /tmp/
COPY    --chown=postgres:postgres   pg_etc/pg_hba.conf                                   /tmp/
COPY    --chown=postgres:postgres   pg_etc/postgresql.conf                               /tmp/
COPY    --chown=postgres:postgres   docker-entrypoint-initdb/1_init_globals.sh           /docker-entrypoint-initdb.d/
COPY    --chown=postgres:postgres   docker-entrypoint-initdb/2_pg_dumpall.sql            /docker-entrypoint-initdb.d/
COPY    --chown=postgres:postgres   docker-entrypoint-initdb/3_stats_timeline.sql        /docker-entrypoint-initdb.d/
COPY    --chown=postgres:postgres   docker-entrypoint-initdb/4_get_stats_functions.sh    /docker-entrypoint-initdb.d/
COPY    --chown=postgres:postgres   docker-entrypoint-initdb/5_init_pgbench.sh           /docker-entrypoint-initdb.d/
COPY    --chown=postgres:postgres   docker-entrypoint-initdb/6_copy_configs.sh           /docker-entrypoint-initdb.d/
