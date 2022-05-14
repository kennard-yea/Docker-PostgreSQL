FROM jobber:latest
USER root
RUN apk update
RUN apk upgrade
RUN apk add --no-cache --virtual .build-deps gzip curl wget tar
RUN apk add postgresql-client
RUN curl -s https://api.github.com/repos/rapidloop/pgmetrics/releases/latest | grep "browser_download_url.*linux_amd64.tar.gz" | cut -d : -f 2,3 | tr -d \" | wget -qi - -O /tmp/pgmetrics_latest_linux_amd64.tar.gz
RUN tar -xzf /tmp/pgmetrics_latest_linux_amd64.tar.gz -C /usr/local/bin/ --strip-components 1 --no-anchored 'pgmetrics'
RUN rm -rf /tmp/pgmetrics_latest_linux_amd64.tar.gz /usr/src/postgresql/
COPY --chown=jobberuser:jobberuser .pgpass /home/jobberuser/
COPY --chown=jobberuser:jobberuser pgmetrics_collect.sh /usr/local/bin/
COPY --chown=jobberuser:jobberuser jobber-jobs.yaml /home/jobberuser/.jobber
RUN chmod 600 /home/jobberuser/.pgpass
RUN chmod 600 /home/jobberuser/.jobber
RUN chmod -R 755 /usr/local/bin/ 
RUN apk del --no-network .build-deps
USER jobberuser
