FROM dpage/pgadmin4:latest
RUN mkdir -p /var/lib/pgadmin/storage/
COPY --chown=pgadmin:root .pgpass /tmp/
RUN mv /tmp/.pgpass /var/lib/pgadmin/storage/
RUN chmod 0600 /var/lib/pgadmin/storage/.pgpass
COPY --chown=pgadmin:root servers.json /pgadmin4/
