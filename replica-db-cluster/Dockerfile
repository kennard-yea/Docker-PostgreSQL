FROM postgres:14
COPY --chown=postgres:postgres build-replica.sh /docker-entrypoint-initdb.d/build-replica.sh
COPY --chown=postgres:postgres .pgpass /var/lib/postgresql/
RUN chmod 0600 /var/lib/postgresql/.pgpass
USER postgres
