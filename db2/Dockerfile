FROM postgres:13
COPY --chown=root:root docker-entrypoint.sh /usr/local/bin/
COPY --chown=postgres:postgres .pgpass /var/lib/postgresql/
RUN chmod 0600 /var/lib/postgresql/.pgpass
USER postgres
