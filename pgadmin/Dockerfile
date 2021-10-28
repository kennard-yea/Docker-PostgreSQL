FROM dpage/pgadmin4:latest
COPY --chown=pgadmin:pgadmin entrypoint.sh /
COPY --chown=pgadmin:pgadmin .pgpass /tmp/
COPY --chown=pgadmin:pgadmin servers.json /pgadmin4/
