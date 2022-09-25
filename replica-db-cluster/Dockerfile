FROM postgres:14
RUN apt-get update
RUN apt-get install -y wget
RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(grep "VERSION_CODENAME" /etc/os-release | cut -d"=" -f2)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc > /etc/apt/trusted.gpg.d/pgdg.asc
RUN apt-get update
RUN apt-get install -y --no-install-recommends pgagent
RUN apt-get purge -y wget
RUN apt-get autoremove --purge -y
COPY --chown=postgres:postgres build-replica.sh /docker-entrypoint-initdb.d/build-replica.sh
COPY --chown=postgres:postgres .pgpass /var/lib/postgresql/
RUN chmod 0600 /var/lib/postgresql/.pgpass
USER postgres
