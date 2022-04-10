FROM debian:stretch
RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get install -y wget
RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(grep "VERSION_CODENAME" /etc/os-release | cut -d"=" -f2)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc > /etc/apt/trusted.gpg.d/pgdg.asc
RUN apt-get update
RUN apt-get install -y postgresql-common
RUN sed -i 's/^#create_main_cluster = true/create_main_cluster = false/' /etc/postgresql-common/createcluster.conf
RUN apt-get install -y pgagent
COPY ".pgpass" "/var/lib/postgresql/"
COPY "docker-entrypoint.sh" "/usr/local/bin"
RUN chown --recursive postgres:postgres /var/lib/postgresql
RUN chmod 0600 /var/lib/postgresql/.pgpass
RUN chmod 0755 /usr/local/bin/docker-entrypoint.sh
RUN apt-get purge -y wget
RUN apt-get autoremove --purge -y
USER postgres
ENV PGHOST=pgdb1
ENV PGDATABASE=postgres
ENV PGUSER=postgres
ENTRYPOINT [ "docker-entrypoint.sh" ]