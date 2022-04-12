FROM dpage/pgadmin4:latest
COPY --chown=pgadmin:root entrypoint.sh /
COPY --chown=pgadmin:root .pgpass /tmp/
COPY --chown=pgadmin:root servers.json /pgadmin4/
