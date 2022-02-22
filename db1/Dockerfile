FROM postgres:14
RUN apt-get update
RUN apt-get install -y wget
RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(grep "VERSION_CODENAME" /etc/os-release | cut -d"=" -f2)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc > /etc/apt/trusted.gpg.d/pgdg.asc
RUN apt-get update
RUN apt-get install -y --no-install-recommends pgagent
RUN apt-get purge -y wget
RUN apt-get autoremove --purge -y
USER postgres
COPY --chown=root:root docker-entrypoint.sh /usr/local/bin/
COPY --chown=postgres:postgres 1_init_globals.sh /docker-entrypoint-initdb.d/
COPY --chown=postgres:postgres 2_pg_dumpall.sql /docker-entrypoint-initdb.d/
COPY --chown=postgres:postgres 3_init_pgbench.sh /docker-entrypoint-initdb.d/
COPY --chown=postgres:postgres pg_hba.conf /etc/postgresql/
COPY --chown=postgres:postgres postgresql.conf /etc/postgresql/
