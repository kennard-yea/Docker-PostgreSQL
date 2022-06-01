\connect grafana

CREATE SCHEMA stats_timeline;

ALTER SCHEMA stats_timeline OWNER TO grafana;

CREATE TABLE stats_timeline.tl_stat_activity_default AS
SELECT
    pg_catalog.now() AS collected_at
    , pg_catalog.pg_stat_activity.*
FROM
    pg_catalog.pg_stat_activity
WITH NO DATA;

CREATE TABLE stats_timeline.tl_stat_activity (
    LIKE stats_timeline.tl_stat_activity_default
)
PARTITION BY RANGE (collected_at);

ALTER TABLE stats_timeline.tl_stat_activity ATTACH PARTITION stats_timeline.tl_stat_activity_default DEFAULT;

ALTER TABLE stats_timeline.tl_stat_activity OWNER TO grafana;

ALTER TABLE stats_timeline.tl_stat_activity_default OWNER TO grafana;

ALTER TABLE stats_timeline.tl_stat_activity
    ADD CONSTRAINT tl_stat_activity_pkey PRIMARY KEY (collected_at , pid);
    
CREATE TABLE stats_timeline.tl_stat_replication_default AS
SELECT
    pg_catalog.now() AS collected_at
    , pg_catalog.pg_stat_replication.*
FROM
    pg_catalog.pg_stat_replication 
WITH NO DATA;

CREATE TABLE stats_timeline.tl_stat_replication (
    LIKE stats_timeline.tl_stat_replication_default
)
PARTITION BY RANGE (collected_at);

ALTER TABLE stats_timeline.tl_stat_replication ATTACH PARTITION stats_timeline.tl_stat_replication_default DEFAULT;

ALTER TABLE stats_timeline.tl_stat_replication OWNER TO grafana;

ALTER TABLE stats_timeline.tl_stat_replication_default OWNER TO grafana;

ALTER TABLE stats_timeline.tl_stat_replication
    ADD CONSTRAINT tl_stat_replication_pkey PRIMARY KEY (collected_at , pid);

CREATE TABLE stats_timeline.tl_stat_wal_receiver_default AS
SELECT
    pg_catalog.now() AS collected_at
    , pg_catalog.pg_stat_wal_receiver.*
FROM
    pg_catalog.pg_stat_wal_receiver 
WITH NO DATA;

CREATE TABLE stats_timeline.tl_stat_wal_receiver (
    LIKE stats_timeline.tl_stat_wal_receiver_default
)
PARTITION BY RANGE (collected_at);

ALTER TABLE stats_timeline.tl_stat_wal_receiver ATTACH PARTITION stats_timeline.tl_stat_wal_receiver_default DEFAULT;

ALTER TABLE stats_timeline.tl_stat_wal_receiver OWNER TO grafana;

ALTER TABLE stats_timeline.tl_stat_wal_receiver_default OWNER TO grafana;

ALTER TABLE stats_timeline.tl_stat_wal_receiver
    ADD CONSTRAINT tl_stat_wal_receiver_pkey PRIMARY KEY (collected_at , pid);
    
CREATE TABLE stats_timeline.tl_stat_subscription_default AS
SELECT
    pg_catalog.now() AS collected_at
    , pg_catalog.pg_stat_subscription.*
FROM
    pg_catalog.pg_stat_subscription 
WITH NO DATA;

CREATE TABLE stats_timeline.tl_stat_subscription (
    LIKE stats_timeline.tl_stat_subscription_default
)
PARTITION BY RANGE (collected_at);

ALTER TABLE stats_timeline.tl_stat_subscription ATTACH PARTITION stats_timeline.tl_stat_subscription_default DEFAULT;

ALTER TABLE stats_timeline.tl_stat_subscription OWNER TO grafana;

ALTER TABLE stats_timeline.tl_stat_subscription_default OWNER TO grafana;

ALTER TABLE stats_timeline.tl_stat_subscription
    ADD CONSTRAINT tl_stat_subscription_pkey PRIMARY KEY (collected_at , subid);
    
CREATE TABLE stats_timeline.tl_stat_ssl_default AS
SELECT
    pg_catalog.now() AS collected_at
    , pg_catalog.pg_stat_ssl.*
FROM
    pg_catalog.pg_stat_ssl 
WITH NO DATA;

CREATE TABLE stats_timeline.tl_stat_ssl (
    LIKE stats_timeline.tl_stat_ssl_default
)
PARTITION BY RANGE (collected_at);

ALTER TABLE stats_timeline.tl_stat_ssl ATTACH PARTITION stats_timeline.tl_stat_ssl_default DEFAULT;

ALTER TABLE stats_timeline.tl_stat_ssl OWNER TO grafana;

ALTER TABLE stats_timeline.tl_stat_ssl_default OWNER TO grafana;

ALTER TABLE stats_timeline.tl_stat_ssl
    ADD CONSTRAINT tl_stat_ssl_pkey PRIMARY KEY (collected_at , pid);

CREATE TABLE stats_timeline.tl_stat_gssapi_default AS
SELECT
    pg_catalog.now() AS collected_at
    , pg_catalog.pg_stat_gssapi.*
FROM
    pg_catalog.pg_stat_gssapi 
WITH NO DATA;

CREATE TABLE stats_timeline.tl_stat_gssapi (
    LIKE stats_timeline.tl_stat_gssapi_default
)
PARTITION BY RANGE (collected_at);

ALTER TABLE stats_timeline.tl_stat_gssapi ATTACH PARTITION stats_timeline.tl_stat_gssapi_default DEFAULT;

ALTER TABLE stats_timeline.tl_stat_gssapi OWNER TO grafana;

ALTER TABLE stats_timeline.tl_stat_gssapi_default OWNER TO grafana;

ALTER TABLE stats_timeline.tl_stat_gssapi
    ADD CONSTRAINT tl_stat_gssapi_pkey PRIMARY KEY (collected_at , pid);

CREATE TABLE stats_timeline.tl_stat_archiver_default AS
SELECT
    pg_catalog.now() AS collected_at
    , pg_catalog.pg_stat_archiver.*
FROM
    pg_catalog.pg_stat_archiver 
WITH NO DATA;

CREATE TABLE stats_timeline.tl_stat_archiver (
    LIKE stats_timeline.tl_stat_archiver_default
)
PARTITION BY RANGE (collected_at);

ALTER TABLE stats_timeline.tl_stat_archiver ATTACH PARTITION stats_timeline.tl_stat_archiver_default DEFAULT;

ALTER TABLE stats_timeline.tl_stat_archiver OWNER TO grafana;

ALTER TABLE stats_timeline.tl_stat_archiver_default OWNER TO grafana;

ALTER TABLE stats_timeline.tl_stat_archiver
    ADD CONSTRAINT tl_stat_archiver_pkey PRIMARY KEY (collected_at);

CREATE TABLE stats_timeline.tl_stat_bgwriter_default AS
SELECT
    pg_catalog.now() AS collected_at
    , pg_catalog.pg_stat_bgwriter.*
FROM
    pg_catalog.pg_stat_bgwriter 
WITH NO DATA;

CREATE TABLE stats_timeline.tl_stat_bgwriter (
    LIKE stats_timeline.tl_stat_bgwriter_default
)
PARTITION BY RANGE (collected_at);

ALTER TABLE stats_timeline.tl_stat_bgwriter ATTACH PARTITION stats_timeline.tl_stat_bgwriter_default DEFAULT;

ALTER TABLE stats_timeline.tl_stat_bgwriter OWNER TO grafana;

ALTER TABLE stats_timeline.tl_stat_bgwriter_default OWNER TO grafana;

ALTER TABLE stats_timeline.tl_stat_bgwriter
    ADD CONSTRAINT tl_stat_bgwriter_pkey PRIMARY KEY (collected_at);

CREATE TABLE stats_timeline.tl_stat_wal_default AS
SELECT
    pg_catalog.now() AS collected_at
    , pg_catalog.pg_stat_wal.*
FROM
    pg_catalog.pg_stat_wal 
WITH NO DATA;

CREATE TABLE stats_timeline.tl_stat_wal (
    LIKE stats_timeline.tl_stat_wal_default
)
PARTITION BY RANGE (collected_at);

ALTER TABLE stats_timeline.tl_stat_wal ATTACH PARTITION stats_timeline.tl_stat_wal_default DEFAULT;

ALTER TABLE stats_timeline.tl_stat_wal OWNER TO grafana;

ALTER TABLE stats_timeline.tl_stat_wal_default OWNER TO grafana;

ALTER TABLE stats_timeline.tl_stat_wal
    ADD CONSTRAINT tl_stat_wal_pkey PRIMARY KEY (collected_at);

CREATE TABLE stats_timeline.tl_stat_database_default AS
SELECT
    pg_catalog.now() AS collected_at
    , pg_catalog.pg_stat_database.*
FROM
    pg_catalog.pg_stat_database 
WITH NO DATA;

CREATE TABLE stats_timeline.tl_stat_database (
    LIKE stats_timeline.tl_stat_database_default
)
PARTITION BY RANGE (collected_at);

ALTER TABLE stats_timeline.tl_stat_database ATTACH PARTITION stats_timeline.tl_stat_database_default DEFAULT;

ALTER TABLE stats_timeline.tl_stat_database OWNER TO grafana;

ALTER TABLE stats_timeline.tl_stat_database_default OWNER TO grafana;

ALTER TABLE stats_timeline.tl_stat_database
    ADD CONSTRAINT tl_stat_database_pkey PRIMARY KEY (collected_at, datid);

CREATE TABLE stats_timeline.tl_stat_database_conflicts_default AS
SELECT
    pg_catalog.now() AS collected_at
    , pg_catalog.pg_stat_database_conflicts.*
FROM
    pg_catalog.pg_stat_database_conflicts
WITH NO DATA;

CREATE TABLE stats_timeline.tl_stat_database_conflicts (
    LIKE stats_timeline.tl_stat_database_conflicts_default
)
PARTITION BY RANGE (collected_at);

ALTER TABLE stats_timeline.tl_stat_database_conflicts ATTACH PARTITION stats_timeline.tl_stat_database_conflicts_default DEFAULT;

ALTER TABLE stats_timeline.tl_stat_database_conflicts OWNER TO grafana;

ALTER TABLE stats_timeline.tl_stat_database_conflicts_default OWNER TO grafana;

ALTER TABLE stats_timeline.tl_stat_database_conflicts
    ADD CONSTRAINT tl_stat_database_conflicts_pkey PRIMARY KEY (collected_at, datid);

CREATE TABLE stats_timeline.tl_stat_all_tables_default AS
SELECT
    pg_catalog.now() AS collected_at
    , pg_catalog.pg_stat_all_tables.*
FROM
    pg_catalog.pg_stat_all_tables 
WITH NO DATA;

CREATE TABLE stats_timeline.tl_stat_all_tables (
    LIKE stats_timeline.tl_stat_all_tables_default
)
PARTITION BY RANGE (collected_at);

ALTER TABLE stats_timeline.tl_stat_all_tables ATTACH PARTITION stats_timeline.tl_stat_all_tables_default DEFAULT;

ALTER TABLE stats_timeline.tl_stat_all_tables OWNER TO grafana;

ALTER TABLE stats_timeline.tl_stat_all_tables_default OWNER TO grafana;

ALTER TABLE stats_timeline.tl_stat_all_tables
    ADD CONSTRAINT tl_stat_all_tables_pkey PRIMARY KEY (collected_at, relid);

CREATE TABLE stats_timeline.tl_stat_all_indexes_default AS
SELECT
    pg_catalog.now() AS collected_at
    , pg_catalog.pg_stat_all_indexes.*
FROM
    pg_catalog.pg_stat_all_indexes 
WITH NO DATA;

CREATE TABLE stats_timeline.tl_stat_all_indexes (
    LIKE stats_timeline.tl_stat_all_indexes_default
)
PARTITION BY RANGE (collected_at);

ALTER TABLE stats_timeline.tl_stat_all_indexes ATTACH PARTITION stats_timeline.tl_stat_all_indexes_default DEFAULT;

ALTER TABLE stats_timeline.tl_stat_all_indexes OWNER TO grafana;

ALTER TABLE stats_timeline.tl_stat_all_indexes_default OWNER TO grafana;

ALTER TABLE stats_timeline.tl_stat_all_indexes
    ADD CONSTRAINT tl_stat_all_indexes_pkey PRIMARY KEY (collected_at, indexrelid);

CREATE TABLE stats_timeline.tl_statio_all_tables_default AS
SELECT
    pg_catalog.now() AS collected_at
    , pg_catalog.pg_statio_all_tables.*
FROM
    pg_catalog.pg_statio_all_tables 
WITH NO DATA;

CREATE TABLE stats_timeline.tl_statio_all_tables (
    LIKE stats_timeline.tl_statio_all_tables_default
)
PARTITION BY RANGE (collected_at);

ALTER TABLE stats_timeline.tl_statio_all_tables ATTACH PARTITION stats_timeline.tl_statio_all_tables_default DEFAULT;

ALTER TABLE stats_timeline.tl_statio_all_tables OWNER TO grafana;

ALTER TABLE stats_timeline.tl_statio_all_tables_default OWNER TO grafana;

ALTER TABLE stats_timeline.tl_statio_all_tables
    ADD CONSTRAINT tl_statio_all_tables_pkey PRIMARY KEY (collected_at, relid);

CREATE TABLE stats_timeline.tl_statio_all_indexes_default AS
SELECT
    pg_catalog.now() AS collected_at
    , pg_catalog.pg_statio_all_indexes.*
FROM
    pg_catalog.pg_statio_all_indexes 
WITH NO DATA;

CREATE TABLE stats_timeline.tl_statio_all_indexes (
    LIKE stats_timeline.tl_statio_all_indexes_default
)
PARTITION BY RANGE (collected_at);

ALTER TABLE stats_timeline.tl_statio_all_indexes ATTACH PARTITION stats_timeline.tl_statio_all_indexes_default DEFAULT;

ALTER TABLE stats_timeline.tl_statio_all_indexes OWNER TO grafana;

ALTER TABLE stats_timeline.tl_statio_all_indexes_default OWNER TO grafana;

ALTER TABLE stats_timeline.tl_statio_all_indexes
    ADD CONSTRAINT tl_statio_all_indexes_pkey PRIMARY KEY (collected_at, indexrelid);

CREATE TABLE stats_timeline.tl_statio_all_sequences_default AS
SELECT
    pg_catalog.now() AS collected_at
    , pg_catalog.pg_statio_all_sequences.*
FROM
    pg_catalog.pg_statio_all_sequences 
WITH NO DATA;

CREATE TABLE stats_timeline.tl_statio_all_sequences (
    LIKE stats_timeline.tl_statio_all_sequences_default
)
PARTITION BY RANGE (collected_at);

ALTER TABLE stats_timeline.tl_statio_all_sequences ATTACH PARTITION stats_timeline.tl_statio_all_sequences_default DEFAULT;

ALTER TABLE stats_timeline.tl_statio_all_sequences OWNER TO grafana;

ALTER TABLE stats_timeline.tl_statio_all_sequences_default OWNER TO grafana;

ALTER TABLE stats_timeline.tl_statio_all_sequences
    ADD CONSTRAINT tl_statio_all_sequences_pkey PRIMARY KEY (collected_at, relid);

CREATE TABLE stats_timeline.tl_stat_slru_default AS
SELECT
    pg_catalog.now() AS collected_at
    , pg_catalog.pg_stat_slru.*
FROM
    pg_catalog.pg_stat_slru 
WITH NO DATA;

CREATE TABLE stats_timeline.tl_stat_slru (
    LIKE stats_timeline.tl_stat_slru_default
)
PARTITION BY RANGE (collected_at);

ALTER TABLE stats_timeline.tl_stat_slru ATTACH PARTITION stats_timeline.tl_stat_slru_default DEFAULT;

ALTER TABLE stats_timeline.tl_stat_slru OWNER TO grafana;

ALTER TABLE stats_timeline.tl_stat_slru_default OWNER TO grafana;

ALTER TABLE stats_timeline.tl_stat_slru
    ADD CONSTRAINT tl_stat_slru_pkey PRIMARY KEY (collected_at, name);

GRANT USAGE ON SCHEMA stats_timeline TO pg_monitor;

GRANT SELECT ON ALL TABLES IN SCHEMA stats_timeline TO pg_monitor;
