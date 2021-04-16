FROM postgres:13
COPY pgdg.list /etc/apt/sources.list.d/
RUN apt update && apt install -y postgresql-12
USER postgres
RUN /usr/lib/postgresql/13/bin/initdb 
