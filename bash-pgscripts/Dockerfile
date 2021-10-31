FROM ubuntu:20.04
RUN apt update
RUN apt install -y wget gnupg gnupg2 gnupg1
RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(grep "VERSION_CODENAME" /etc/os-release | cut -d"=" -f2)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc > /etc/apt/trusted.gpg.d/pgdg.asc
RUN apt update
RUN apt install -y postgresql-client
RUN groupadd postgres
RUN useradd --create-home --home-dir /var/lib/postgresql --gid postgres --shell /bin/bash postgres
RUN mkdir --mode=700 --parents /var/lib/postgresql/backup /var/lib/postgresql/lib /var/lib/postgresql/bin
COPY "postgres-functions.bash" "/var/lib/postgresql/lib/"
COPY "bash-functions.bash" "/var/lib/postgresql/lib/"
COPY "pg-basebackup" "/var/lib/postgresql/bin/"
COPY ".pgpass" "/var/lib/postgresql/"
RUN chown --recursive postgres:postgres /var/lib/postgresql
RUN chmod 0600 /var/lib/postgresql/.pgpass
USER postgres
WORKDIR /var/lib/postgresql