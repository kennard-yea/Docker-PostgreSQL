create schema if not exists stats_timeline;

alter schema stats_timeline owner to postgres;

create function stats_timeline.get_pg_stat_activity() returns void
    language sql
    as $$select current_timestamp,
	pg_stat_activity.*
from pg_catalog.pg_stat_activity;$$;

alter function stats_timeline.get_pg_stat_activity() owner to postgres;

create function stats_timeline.get_pg_stat_all_indexes() returns void
    language sql
    as $$select current_timestamp,
	pg_stat_all_indexes.*
from pg_catalog.pg_stat_all_indexes;$$;

alter function stats_timeline.get_pg_stat_all_indexes() owner to postgres;


create function stats_timeline.get_pg_stat_all_tables() returns void
    language sql
    as $$select current_timestamp,
	pg_stat_all_tables.*
from pg_catalog.pg_stat_all_tables;$$;

alter function stats_timeline.get_pg_stat_all_tables() owner to postgres;


create function stats_timeline.get_pg_stat_archiver() returns void
    language sql
    as $$select current_timestamp,
	pg_stat_archiver.*
from pg_catalog.pg_stat_archiver;$$;

alter function stats_timeline.get_pg_stat_archiver() owner to postgres;


create function stats_timeline.get_pg_stat_bgwriter() returns void
    language sql
    as $$select current_timestamp,
	pg_stat_bgwriter.*
from pg_catalog.pg_stat_bgwriter;$$;

alter function stats_timeline.get_pg_stat_bgwriter() owner to postgres;


create function stats_timeline.get_pg_stat_database() returns void
    language sql
    as $$select current_timestamp,
	pg_stat_database.*
from pg_catalog.pg_stat_database;$$;

alter function stats_timeline.get_pg_stat_database() owner to postgres;


create function stats_timeline.get_pg_stat_database_conflicts() returns void
    language sql
    as $$select current_timestamp,
	pg_stat_database_conflicts.*
from pg_catalog.pg_stat_database_conflicts;$$;

alter function stats_timeline.get_pg_stat_database_conflicts() owner to postgres;


create function stats_timeline.get_pg_stat_gssapi() returns void
    language sql
    as $$select current_timestamp,
	pg_stat_gssapi.*
from pg_catalog.pg_stat_gssapi;$$;

alter function stats_timeline.get_pg_stat_gssapi() owner to postgres;


create function stats_timeline.get_pg_stat_replication() returns void
    language sql
    as $$select current_timestamp,
	pg_stat_replication.*
from pg_catalog.pg_stat_replication;$$;

alter function stats_timeline.get_pg_stat_replication() owner to postgres;


create function stats_timeline.get_pg_stat_slru() returns void
    language sql
    as $$select current_timestamp,
	pg_stat_slru.*
from pg_catalog.pg_stat_slru;$$;

alter function stats_timeline.get_pg_stat_slru() owner to postgres;


create function stats_timeline.get_pg_stat_ssl() returns void
    language sql
    as $$select current_timestamp,
	pg_stat_ssl.*
from pg_catalog.pg_stat_ssl;$$;

alter function stats_timeline.get_pg_stat_ssl() owner to postgres;


create function stats_timeline.get_pg_stat_subscription() returns void
    language sql
    as $$select current_timestamp,
	pg_stat_subscription.*
from pg_catalog.pg_stat_subscription;$$;

alter function stats_timeline.get_pg_stat_subscription() owner to postgres;


create function stats_timeline.get_pg_stat_wal() returns void
    language sql
    as $$select current_timestamp,
	pg_stat_wal.*
from pg_catalog.pg_stat_wal;$$;

alter function stats_timeline.get_pg_stat_wal() owner to postgres;


create function stats_timeline.get_pg_stat_wal_receiver() returns void
    language sql
    as $$select current_timestamp,
	pg_stat_wal_receiver.*
from pg_catalog.pg_stat_wal_receiver;$$;

alter function stats_timeline.get_pg_stat_wal_receiver() owner to postgres;


create function stats_timeline.get_pg_statio_all_indexes() returns void
    language sql
    as $$select current_timestamp,
	pg_statio_all_indexes.*
from pg_catalog.pg_statio_all_indexes;$$;

alter function stats_timeline.get_pg_statio_all_indexes() owner to postgres;


create function stats_timeline.get_pg_statio_all_sequences() returns void
    language sql
    as $$select current_timestamp,
	pg_statio_all_sequences.*
from pg_catalog.pg_statio_all_sequences;$$;

alter function stats_timeline.get_pg_statio_all_sequences() owner to postgres;


create function stats_timeline.get_pg_statio_all_tables() returns void
    language sql
    as $$select current_timestamp,
	pg_statio_all_tables.*
from pg_catalog.pg_statio_all_tables;$$;

alter function stats_timeline.get_pg_statio_all_tables() owner to postgres;


grant usage on schema stats_timeline to pg_monitor;
grant execute on all functions in schema stats_timeline to pg_monitor;
alter default privileges in schema stats_timeline grant execute on functions to pg_monitor;

