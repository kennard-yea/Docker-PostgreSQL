FROM postgres:13
RUN mkdir --mode=700 --parents /var/lib/postgresql/backup /var/lib/postgresql/lib /var/lib/postgresql/bin
COPY postgres-functions.bash /var/lib/postgresql/lib/
COPY bash-functions.bash /var/lib/postgresql/lib/
COPY pg-basebackup /var/lib/postgresql/bin/
COPY .pgpass /var/lib/postgresql/
RUN chown --recursive postgres:postgres /var/lib/postgresql
RUN chmod 0600 /var/lib/postgresql/.pgpass
USER postgres