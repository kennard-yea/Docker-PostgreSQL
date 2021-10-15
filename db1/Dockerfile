FROM postgres:13
USER postgres
COPY --chown=root:root docker-entrypoint.sh /usr/local/bin/
COPY --chown=postgres:postgres init_pgbench.sh /docker-entrypoint-initdb.d/
COPY --chown=postgres:postgres pg_hba.conf /etc/postgresql/
COPY --chown=postgres:postgres postgresql.conf /etc/postgresql/
