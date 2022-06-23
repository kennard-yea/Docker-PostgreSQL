FROM mcr.microsoft.com/powershell:latest
RUN apt-get update
RUN apt-get install -y wget
RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(grep "VERSION_CODENAME" /etc/os-release | cut -d"=" -f2)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc > /etc/apt/trusted.gpg.d/pgdg.asc
RUN apt-get update
RUN apt-get install -y postgresql-client
RUN groupadd postgres
RUN useradd --create-home --home-dir /var/lib/postgresql --gid postgres --shell /bin/bash postgres
RUN mkdir --mode=700 --parents /var/lib/postgresql/backup /var/lib/postgresql/lib /var/lib/postgresql/bin
COPY ".pgpass" "/var/lib/postgresql/"
RUN chown --recursive postgres:postgres /var/lib/postgresql
RUN chmod 0600 /var/lib/postgresql/.pgpass
RUN apt-get purge -y wget
RUN apt-get autoremove --purge -y
USER postgres
WORKDIR /var/lib/postgresql
