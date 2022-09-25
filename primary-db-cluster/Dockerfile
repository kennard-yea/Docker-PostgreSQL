FROM    postgres:14
RUN     apt-get update
RUN     apt-get install -y wget
RUN     sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(grep "VERSION_CODENAME" /etc/os-release | cut -d"=" -f2)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
RUN     wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc > /etc/apt/trusted.gpg.d/pgdg.asc
RUN     apt-get update
RUN     apt-get install -y --no-install-recommends pgagent
RUN     apt-get purge -y wget
RUN     apt-get autoremove --purge -y
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
