FROM alpine:latest
RUN apk update
RUN apk upgrade
RUN apk add curl jq wget tar postgresql14-client
RUN curl -s https://api.github.com/repos/rapidloop/pgmetrics/releases/latest | grep "browser_download_url.*linux_amd64.tar.gz" | cut -d : -f 2,3 | tr -d \" | wget -qi - -O /tmp/pgmetrics_latest_linux_amd64.tar.gz
RUN tar -xzf /tmp/pgmetrics_latest_linux_amd64.tar.gz -C /usr/local/bin/ --strip-components 1 --no-anchored 'pgmetrics'
RUN rm -f /tmp/pgmetrics_latest_linux_amd64.tar.gz
RUN adduser -D pgmetrics
COPY .pgpass /home/pgmetrics/
COPY pgmetrics_collect.sh /usr/local/bin/
RUN chown pgmetrics:pgmetrics /home/pgmetrics/.pgpass
RUN chmod 600 /home/pgmetrics/.pgpass
RUN apk del curl jq wget tar
USER pgmetrics
CMD [ "pgmetrics_collect.sh" ]
