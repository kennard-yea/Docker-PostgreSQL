FROM postgres:13
RUN apt-get update
RUN apt-get install -y wget gnupg gnupg2 gnupg1 locales locales-all vim
RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(grep "VERSION_CODENAME" /etc/os-release | cut -d"=" -f2)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc > /etc/apt/trusted.gpg.d/pgdg.asc
RUN apt-get update
RUN apt-get install -y postgresql-common
RUN sed -i 's/^#create_main_cluster = true/create_main_cluster = false/' /etc/postgresql-common/createcluster.conf
RUN apt-get install -y pgagent
COPY --chown=root:root docker-entrypoint.sh /usr/local/bin/
COPY --chown=postgres:postgres .pgpass /var/lib/postgresql/
RUN chmod 0600 /var/lib/postgresql/.pgpass
USER postgres
