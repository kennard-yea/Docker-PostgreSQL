--
-- PostgreSQL database cluster dump
--

-- Started on 2022-05-22 04:18:51 UTC

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

ALTER ROLE grafana WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS;
ALTER ROLE pgbench WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS;
ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS;


--
-- Role memberships
--

GRANT pg_monitor TO grafana GRANTED BY postgres;




--
-- Databases
--

--
-- Database "template1" dump
--

\connect template1

--
-- PostgreSQL database dump
--

-- Dumped from database version 14.3 (Debian 14.3-1.pgdg110+1)
-- Dumped by pg_dump version 14.2

-- Started on 2022-05-22 04:18:51 UTC

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 2 (class 3079 OID 16386)
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA public;


--
-- TOC entry 3320 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


-- Completed on 2022-05-22 04:18:51 UTC

--
-- PostgreSQL database dump complete
--

--
-- Database "grafana" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 14.3 (Debian 14.3-1.pgdg110+1)
-- Dumped by pg_dump version 14.2

-- Started on 2022-05-22 04:18:51 UTC

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 3411 (class 1262 OID 16411)
-- Name: grafana; Type: DATABASE; Schema: -; Owner: grafana
--

CREATE DATABASE grafana WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'en_US.utf8';


ALTER DATABASE grafana OWNER TO grafana;

\connect grafana

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 9 (class 2615 OID 16412)
-- Name: pglogs; Type: SCHEMA; Schema: -; Owner: grafana
--

CREATE SCHEMA pglogs;


ALTER SCHEMA pglogs OWNER TO grafana;

--
-- TOC entry 6 (class 2615 OID 16413)
-- Name: pgmetrics; Type: SCHEMA; Schema: -; Owner: grafana
--

CREATE SCHEMA pgmetrics;


ALTER SCHEMA pgmetrics OWNER TO grafana;

--
-- TOC entry 3 (class 3079 OID 16414)
-- Name: file_fdw; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS file_fdw WITH SCHEMA public;


--
-- TOC entry 3412 (class 0 OID 0)
-- Dependencies: 3
-- Name: EXTENSION file_fdw; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION file_fdw IS 'foreign-data wrapper for flat file access';


--
-- TOC entry 2 (class 3079 OID 16418)
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA public;


--
-- TOC entry 3413 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


--
-- TOC entry 244 (class 1255 OID 16443)
-- Name: locks_metrics_insert_trigger(); Type: FUNCTION; Schema: pgmetrics; Owner: grafana
--

CREATE FUNCTION pgmetrics.locks_metrics_insert_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF ( NEW.db_name IS NULL ) THEN INSERT INTO pgmetrics.locks_metrics_null VALUES (NEW.*);
    ELSIF (NEW.db_name = 'grafana') THEN INSERT INTO pgmetrics.locks_metrics_grafana VALUES (NEW.*);
    ELSIF (new.db_name = 'pgbench') THEN INSERT INTO pgmetrics.locks_metrics_pgbench VALUES (NEW.*);
    ELSIF (new.db_name = 'postgres') then INSERT INTO pgmetrics.locks_metrics_postgres VALUES (NEW.*);
    ELSE INSERT INTO pgmetrics.locks_metrics_default VALUES (NEW.*);
    END IF;
    RETURN NULL;
END;
$$;


ALTER FUNCTION pgmetrics.locks_metrics_insert_trigger() OWNER TO grafana;

--
-- TOC entry 248 (class 1255 OID 17786)
-- Name: refresh_indexes_metrics(); Type: PROCEDURE; Schema: pgmetrics; Owner: grafana
--

CREATE PROCEDURE pgmetrics.refresh_indexes_metrics()
    LANGUAGE sql
    AS $$
INSERT INTO pgmetrics.indexes_metrics(
	collection_at, cluster_name, def, oid, name, size, bloat, amname, db_name, idx_scan, relnatts, table_oid, table_name, schema_name, idx_blks_hit, idx_tup_read, idx_blks_read, idx_tup_fetch, tablespace_name)
	(
WITH jtr AS (
    SELECT
        id
        , jsonb_array_elements(metrics_raw -> 'indexes') AS locks
    FROM
        pgmetrics.raw_metrics rm
	WHERE rm.collection_at > (select max(im.collection_at) from pgmetrics.indexes_metrics im)
	OR rm.cluster_name not in (select DISTINCT im.cluster_name from pgmetrics.indexes_metrics im)
)
SELECT
    rm.collection_at
    , rm.cluster_name
    , locks.*
FROM
    jtr
    LEFT JOIN pgmetrics.raw_metrics rm ON jtr.id = rm.id
    , LATERAL jsonb_to_record(jtr.locks) AS locks (def text,
oid int,
name text,
size int,
bloat int,
amname text,
db_name text,
idx_scan int,
relnatts int,
table_oid int,
table_name text,
schema_name text,
idx_blks_hit int,
idx_tup_read int,
idx_blks_read int,
idx_tup_fetch int,
tablespace_name text)
);
$$;


ALTER PROCEDURE pgmetrics.refresh_indexes_metrics() OWNER TO grafana;

--
-- TOC entry 246 (class 1255 OID 16444)
-- Name: refresh_locks_metrics(); Type: PROCEDURE; Schema: pgmetrics; Owner: grafana
--

CREATE PROCEDURE pgmetrics.refresh_locks_metrics()
    LANGUAGE sql
    AS $$
INSERT INTO pgmetrics.locks_metrics(
	collection_at, cluster_name, pid, mode, db_name, granted, locktype, relation_oid)
	(
WITH jtr AS (
    SELECT
        id
        , jsonb_array_elements(metrics_raw -> 'locks') AS locks
    FROM
        pgmetrics.raw_metrics rm
	WHERE rm.collection_at > (select max(lm.collection_at) from pgmetrics.locks_metrics lm)
	OR rm.cluster_name not in (select DISTINCT lm.cluster_name from pgmetrics.locks_metrics lm)
)
SELECT
    rm.collection_at
    , rm.cluster_name
    , locks.*
FROM
    jtr
    LEFT JOIN pgmetrics.raw_metrics rm ON jtr.id = rm.id
    , LATERAL jsonb_to_record(jtr.locks) AS locks (pid int
                                                  , mode text
                                                  , db_name text
                                                  , granted boolean
                                                  , locktype text
                                                  , relation_oid int)
);
$$;


ALTER PROCEDURE pgmetrics.refresh_locks_metrics() OWNER TO grafana;

--
-- TOC entry 247 (class 1255 OID 16970)
-- Name: refresh_tables_metrics(); Type: PROCEDURE; Schema: pgmetrics; Owner: grafana
--

CREATE PROCEDURE pgmetrics.refresh_tables_metrics()
    LANGUAGE sql
    AS $$
INSERT INTO pgmetrics.tables_metrics(
	collection_at, cluster_name, oid, name, size, bloat, db_name, relkind, idx_scan, relnatts, seq_scan, n_tup_del, n_tup_ins, n_tup_upd, n_dead_tup, n_live_tup, last_vacuum, parent_name, schema_name, idx_blks_hit, last_analyze, partition_cv, seq_tup_read, vacuum_count, analyze_count, heap_blks_hit, idx_blks_read, idx_tup_fetch, n_tup_hot_upd, tidx_blks_hit, heap_blks_read, relispartition, relpersistence, tidx_blks_read, toast_blks_hit, last_autovacuum, tablespace_name, toast_blks_read, age_relfrozenxid, autovacuum_count, last_autoanalyze, autoanalyze_count, n_mod_since_analyze)
	(
WITH jtr AS (
    SELECT
        id
        , jsonb_array_elements(metrics_raw -> 'tables') AS locks
    FROM
        pgmetrics.raw_metrics rm
	WHERE rm.collection_at > (select max(tm.collection_at) from pgmetrics.tables_metrics tm)
	OR rm.cluster_name not in (select DISTINCT tm.cluster_name from pgmetrics.tables_metrics tm)
)
SELECT
    rm.collection_at
    , rm.cluster_name
    , locks.*
FROM
    jtr
    LEFT JOIN pgmetrics.raw_metrics rm ON jtr.id = rm.id
    , LATERAL jsonb_to_record(jtr.locks) AS locks (oid int,
name text,
size int,
bloat int,
db_name text,
relkind text,
idx_scan int,
relnatts int,
seq_scan int,
n_tup_del int,
n_tup_ins int,
n_tup_upd int,
n_dead_tup int,
n_live_tup int,
last_vacuum int,
parent_name text,
schema_name text,
idx_blks_hit int,
last_analyze int,
partition_cv text,
seq_tup_read int,
vacuum_count int,
analyze_count int,
heap_blks_hit int,
idx_blks_read int,
idx_tup_fetch int,
n_tup_hot_upd int,
tidx_blks_hit int,
heap_blks_read int,
relispartition boolean,
relpersistence text,
tidx_blks_read int,
toast_blks_hit int,
last_autovacuum int,
tablespace_name text,
toast_blks_read int,
age_relfrozenxid int,
autovacuum_count int,
last_autoanalyze int,
autoanalyze_count int,
n_mod_since_analyze int)
);
$$;


ALTER PROCEDURE pgmetrics.refresh_tables_metrics() OWNER TO grafana;

--
-- TOC entry 245 (class 1255 OID 16445)
-- Name: refresh_wal_metrics(); Type: PROCEDURE; Schema: pgmetrics; Owner: grafana
--

CREATE PROCEDURE pgmetrics.refresh_wal_metrics()
    LANGUAGE sql
    AS $$INSERT INTO pgmetrics.wal_metrics (
WITH jtr AS (
    SELECT
        id
        , metrics_raw -> 'wal' AS wal
    FROM
        pgmetrics.raw_metrics rm
	WHERE rm.collection_at > (select max(wm.collection_at) from pgmetrics.wal_metrics wm)
	OR rm.cluster_name not in (select DISTINCT wm.cluster_name from pgmetrics.wal_metrics wm)
)
SELECT
    rm.collection_at
    , rm.cluster_name
    , wal.*
FROM
    jtr
    LEFT JOIN pgmetrics.raw_metrics rm ON jtr.id = rm.id
    , LATERAL jsonb_to_record(jtr.wal) AS wal (fpi int
        , sync int
        , bytes int
        , write int
        , records int
        , sync_time int
        , write_time int
        , stats_reset int
        , buffers_full int)
);
$$;


ALTER PROCEDURE pgmetrics.refresh_wal_metrics() OWNER TO grafana;

--
-- TOC entry 2083 (class 1417 OID 16446)
-- Name: pglog_server; Type: SERVER; Schema: -; Owner: postgres
--

CREATE SERVER pglog_server FOREIGN DATA WRAPPER file_fdw;


ALTER SERVER pglog_server OWNER TO postgres;

SET default_tablespace = '';

--
-- TOC entry 226 (class 1259 OID 17764)
-- Name: indexes_metrics; Type: TABLE; Schema: pgmetrics; Owner: grafana
--

CREATE TABLE pgmetrics.indexes_metrics (
    id integer NOT NULL,
    collection_at integer NOT NULL,
    cluster_name text NOT NULL,
    def text,
    oid integer,
    name text,
    size integer,
    bloat integer,
    amname text,
    db_name text,
    idx_scan integer,
    relnatts integer,
    table_oid integer,
    table_name text,
    schema_name text,
    idx_blks_hit integer,
    idx_tup_read integer,
    idx_blks_read integer,
    idx_tup_fetch integer,
    tablespace_name text
)
PARTITION BY RANGE (collection_at);


ALTER TABLE pgmetrics.indexes_metrics OWNER TO grafana;

--
-- TOC entry 225 (class 1259 OID 17763)
-- Name: indexes_metrics_id_seq; Type: SEQUENCE; Schema: pgmetrics; Owner: grafana
--

CREATE SEQUENCE pgmetrics.indexes_metrics_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pgmetrics.indexes_metrics_id_seq OWNER TO grafana;

--
-- TOC entry 3414 (class 0 OID 0)
-- Dependencies: 225
-- Name: indexes_metrics_id_seq; Type: SEQUENCE OWNED BY; Schema: pgmetrics; Owner: grafana
--

ALTER SEQUENCE pgmetrics.indexes_metrics_id_seq OWNED BY pgmetrics.indexes_metrics.id;


SET default_table_access_method = heap;

--
-- TOC entry 227 (class 1259 OID 17773)
-- Name: indexes_metrics_default; Type: TABLE; Schema: pgmetrics; Owner: grafana
--

CREATE TABLE pgmetrics.indexes_metrics_default (
    id integer DEFAULT nextval('pgmetrics.indexes_metrics_id_seq'::regclass) NOT NULL,
    collection_at integer NOT NULL,
    cluster_name text NOT NULL,
    def text,
    oid integer,
    name text,
    size integer,
    bloat integer,
    amname text,
    db_name text,
    idx_scan integer,
    relnatts integer,
    table_oid integer,
    table_name text,
    schema_name text,
    idx_blks_hit integer,
    idx_tup_read integer,
    idx_blks_read integer,
    idx_tup_fetch integer,
    tablespace_name text
);


ALTER TABLE pgmetrics.indexes_metrics_default OWNER TO grafana;

--
-- TOC entry 220 (class 1259 OID 16863)
-- Name: locks_metrics; Type: TABLE; Schema: pgmetrics; Owner: grafana
--

CREATE TABLE pgmetrics.locks_metrics (
    id integer NOT NULL,
    collection_at integer NOT NULL,
    cluster_name text NOT NULL,
    pid integer,
    mode text,
    db_name text,
    granted boolean,
    locktype text,
    relation_oid integer
)
PARTITION BY RANGE (collection_at);


ALTER TABLE pgmetrics.locks_metrics OWNER TO grafana;

--
-- TOC entry 219 (class 1259 OID 16862)
-- Name: locks_metrics_id_seq; Type: SEQUENCE; Schema: pgmetrics; Owner: grafana
--

CREATE SEQUENCE pgmetrics.locks_metrics_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pgmetrics.locks_metrics_id_seq OWNER TO grafana;

--
-- TOC entry 3415 (class 0 OID 0)
-- Dependencies: 219
-- Name: locks_metrics_id_seq; Type: SEQUENCE OWNED BY; Schema: pgmetrics; Owner: grafana
--

ALTER SEQUENCE pgmetrics.locks_metrics_id_seq OWNED BY pgmetrics.locks_metrics.id;


--
-- TOC entry 221 (class 1259 OID 16872)
-- Name: locks_metrics_default; Type: TABLE; Schema: pgmetrics; Owner: grafana
--

CREATE TABLE pgmetrics.locks_metrics_default (
    id integer DEFAULT nextval('pgmetrics.locks_metrics_id_seq'::regclass) NOT NULL,
    collection_at integer NOT NULL,
    cluster_name text NOT NULL,
    pid integer,
    mode text,
    db_name text,
    granted boolean,
    locktype text,
    relation_oid integer
);


ALTER TABLE pgmetrics.locks_metrics_default OWNER TO grafana;

--
-- TOC entry 215 (class 1259 OID 16481)
-- Name: raw_metrics_id_seq; Type: SEQUENCE; Schema: pgmetrics; Owner: grafana
--

CREATE SEQUENCE pgmetrics.raw_metrics_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
    CYCLE;


ALTER TABLE pgmetrics.raw_metrics_id_seq OWNER TO grafana;

--
-- TOC entry 216 (class 1259 OID 16482)
-- Name: raw_metrics; Type: TABLE; Schema: pgmetrics; Owner: grafana
--

CREATE TABLE pgmetrics.raw_metrics (
    id integer DEFAULT nextval('pgmetrics.raw_metrics_id_seq'::regclass) NOT NULL,
    collection_at integer NOT NULL,
    metrics_raw jsonb NOT NULL,
    cluster_name text NOT NULL
);


ALTER TABLE pgmetrics.raw_metrics OWNER TO grafana;

--
-- TOC entry 3416 (class 0 OID 0)
-- Dependencies: 216
-- Name: COLUMN raw_metrics.cluster_name; Type: COMMENT; Schema: pgmetrics; Owner: grafana
--

COMMENT ON COLUMN pgmetrics.raw_metrics.cluster_name IS 'Arbitrary name of the host / database cluster where pgmetrics data is sourced from.';


--
-- TOC entry 223 (class 1259 OID 16950)
-- Name: tables_metrics; Type: TABLE; Schema: pgmetrics; Owner: grafana
--

CREATE TABLE pgmetrics.tables_metrics (
    id integer NOT NULL,
    collection_at integer NOT NULL,
    cluster_name text NOT NULL,
    oid integer,
    name text,
    size integer,
    bloat integer,
    db_name text,
    relkind text,
    idx_scan integer,
    relnatts integer,
    seq_scan integer,
    n_tup_del integer,
    n_tup_ins integer,
    n_tup_upd integer,
    n_dead_tup integer,
    n_live_tup integer,
    last_vacuum integer,
    parent_name text,
    schema_name text,
    idx_blks_hit integer,
    last_analyze integer,
    partition_cv text,
    seq_tup_read integer,
    vacuum_count integer,
    analyze_count integer,
    heap_blks_hit integer,
    idx_blks_read integer,
    idx_tup_fetch integer,
    n_tup_hot_upd integer,
    tidx_blks_hit integer,
    heap_blks_read integer,
    relispartition boolean,
    relpersistence text,
    tidx_blks_read integer,
    toast_blks_hit integer,
    last_autovacuum integer,
    tablespace_name text,
    toast_blks_read integer,
    age_relfrozenxid integer,
    autovacuum_count integer,
    last_autoanalyze integer,
    autoanalyze_count integer,
    n_mod_since_analyze integer
)
PARTITION BY RANGE (collection_at);


ALTER TABLE pgmetrics.tables_metrics OWNER TO grafana;

--
-- TOC entry 222 (class 1259 OID 16949)
-- Name: tables_metrics_id_seq; Type: SEQUENCE; Schema: pgmetrics; Owner: grafana
--

CREATE SEQUENCE pgmetrics.tables_metrics_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pgmetrics.tables_metrics_id_seq OWNER TO grafana;

--
-- TOC entry 3417 (class 0 OID 0)
-- Dependencies: 222
-- Name: tables_metrics_id_seq; Type: SEQUENCE OWNED BY; Schema: pgmetrics; Owner: grafana
--

ALTER SEQUENCE pgmetrics.tables_metrics_id_seq OWNED BY pgmetrics.tables_metrics.id;


--
-- TOC entry 224 (class 1259 OID 16959)
-- Name: tables_metrics_default; Type: TABLE; Schema: pgmetrics; Owner: grafana
--

CREATE TABLE pgmetrics.tables_metrics_default (
    id integer DEFAULT nextval('pgmetrics.tables_metrics_id_seq'::regclass) NOT NULL,
    collection_at integer NOT NULL,
    cluster_name text NOT NULL,
    oid integer,
    name text,
    size integer,
    bloat integer,
    db_name text,
    relkind text,
    idx_scan integer,
    relnatts integer,
    seq_scan integer,
    n_tup_del integer,
    n_tup_ins integer,
    n_tup_upd integer,
    n_dead_tup integer,
    n_live_tup integer,
    last_vacuum integer,
    parent_name text,
    schema_name text,
    idx_blks_hit integer,
    last_analyze integer,
    partition_cv text,
    seq_tup_read integer,
    vacuum_count integer,
    analyze_count integer,
    heap_blks_hit integer,
    idx_blks_read integer,
    idx_tup_fetch integer,
    n_tup_hot_upd integer,
    tidx_blks_hit integer,
    heap_blks_read integer,
    relispartition boolean,
    relpersistence text,
    tidx_blks_read integer,
    toast_blks_hit integer,
    last_autovacuum integer,
    tablespace_name text,
    toast_blks_read integer,
    age_relfrozenxid integer,
    autovacuum_count integer,
    last_autoanalyze integer,
    autoanalyze_count integer,
    n_mod_since_analyze integer
);


ALTER TABLE pgmetrics.tables_metrics_default OWNER TO grafana;

--
-- TOC entry 217 (class 1259 OID 16488)
-- Name: wal_metrics; Type: TABLE; Schema: pgmetrics; Owner: grafana
--

CREATE TABLE pgmetrics.wal_metrics (
    collection_at integer NOT NULL,
    cluster_name text NOT NULL,
    fpi integer,
    sync integer,
    bytes integer,
    write integer,
    records integer,
    sync_time integer,
    write_time integer,
    stats_reset integer,
    buffers_full integer
)
PARTITION BY RANGE (collection_at);


ALTER TABLE pgmetrics.wal_metrics OWNER TO grafana;

--
-- TOC entry 218 (class 1259 OID 16491)
-- Name: wal_metrics_default; Type: TABLE; Schema: pgmetrics; Owner: grafana
--

CREATE TABLE pgmetrics.wal_metrics_default (
    collection_at integer NOT NULL,
    cluster_name text NOT NULL,
    fpi integer,
    sync integer,
    bytes integer,
    write integer,
    records integer,
    sync_time integer,
    write_time integer,
    stats_reset integer,
    buffers_full integer
);


ALTER TABLE pgmetrics.wal_metrics_default OWNER TO grafana;

--
-- TOC entry 3229 (class 0 OID 0)
-- Name: indexes_metrics_default; Type: TABLE ATTACH; Schema: pgmetrics; Owner: grafana
--

ALTER TABLE ONLY pgmetrics.indexes_metrics ATTACH PARTITION pgmetrics.indexes_metrics_default DEFAULT;


--
-- TOC entry 3227 (class 0 OID 0)
-- Name: locks_metrics_default; Type: TABLE ATTACH; Schema: pgmetrics; Owner: grafana
--

ALTER TABLE ONLY pgmetrics.locks_metrics ATTACH PARTITION pgmetrics.locks_metrics_default DEFAULT;


--
-- TOC entry 3228 (class 0 OID 0)
-- Name: tables_metrics_default; Type: TABLE ATTACH; Schema: pgmetrics; Owner: grafana
--

ALTER TABLE ONLY pgmetrics.tables_metrics ATTACH PARTITION pgmetrics.tables_metrics_default DEFAULT;


--
-- TOC entry 3226 (class 0 OID 0)
-- Name: wal_metrics_default; Type: TABLE ATTACH; Schema: pgmetrics; Owner: grafana
--

ALTER TABLE ONLY pgmetrics.wal_metrics ATTACH PARTITION pgmetrics.wal_metrics_default DEFAULT;


--
-- TOC entry 3235 (class 2604 OID 17767)
-- Name: indexes_metrics id; Type: DEFAULT; Schema: pgmetrics; Owner: grafana
--

ALTER TABLE ONLY pgmetrics.indexes_metrics ALTER COLUMN id SET DEFAULT nextval('pgmetrics.indexes_metrics_id_seq'::regclass);


--
-- TOC entry 3231 (class 2604 OID 16866)
-- Name: locks_metrics id; Type: DEFAULT; Schema: pgmetrics; Owner: grafana
--

ALTER TABLE ONLY pgmetrics.locks_metrics ALTER COLUMN id SET DEFAULT nextval('pgmetrics.locks_metrics_id_seq'::regclass);


--
-- TOC entry 3233 (class 2604 OID 16953)
-- Name: tables_metrics id; Type: DEFAULT; Schema: pgmetrics; Owner: grafana
--

ALTER TABLE ONLY pgmetrics.tables_metrics ALTER COLUMN id SET DEFAULT nextval('pgmetrics.tables_metrics_id_seq'::regclass);


--
-- TOC entry 3254 (class 2606 OID 17769)
-- Name: indexes_metrics indexes_metrics_pkey; Type: CONSTRAINT; Schema: pgmetrics; Owner: grafana
--

ALTER TABLE ONLY pgmetrics.indexes_metrics
    ADD CONSTRAINT indexes_metrics_pkey PRIMARY KEY (collection_at, id);


--
-- TOC entry 3256 (class 2606 OID 17778)
-- Name: indexes_metrics_default indexes_metrics_default_pkey; Type: CONSTRAINT; Schema: pgmetrics; Owner: grafana
--

ALTER TABLE ONLY pgmetrics.indexes_metrics_default
    ADD CONSTRAINT indexes_metrics_default_pkey PRIMARY KEY (collection_at, id);


--
-- TOC entry 3246 (class 2606 OID 16868)
-- Name: locks_metrics locks_metrics_pkey; Type: CONSTRAINT; Schema: pgmetrics; Owner: grafana
--

ALTER TABLE ONLY pgmetrics.locks_metrics
    ADD CONSTRAINT locks_metrics_pkey PRIMARY KEY (collection_at, id);


--
-- TOC entry 3248 (class 2606 OID 16877)
-- Name: locks_metrics_default locks_metrics_default_pkey; Type: CONSTRAINT; Schema: pgmetrics; Owner: grafana
--

ALTER TABLE ONLY pgmetrics.locks_metrics_default
    ADD CONSTRAINT locks_metrics_default_pkey PRIMARY KEY (collection_at, id);


--
-- TOC entry 3238 (class 2606 OID 16499)
-- Name: raw_metrics raw_metrics_collection_at_cluster_name_key; Type: CONSTRAINT; Schema: pgmetrics; Owner: grafana
--

ALTER TABLE ONLY pgmetrics.raw_metrics
    ADD CONSTRAINT raw_metrics_collection_at_cluster_name_key UNIQUE (collection_at, cluster_name);


--
-- TOC entry 3240 (class 2606 OID 16501)
-- Name: raw_metrics raw_metrics_pkey; Type: CONSTRAINT; Schema: pgmetrics; Owner: grafana
--

ALTER TABLE ONLY pgmetrics.raw_metrics
    ADD CONSTRAINT raw_metrics_pkey PRIMARY KEY (id);


--
-- TOC entry 3250 (class 2606 OID 16955)
-- Name: tables_metrics tables_metrics_pkey; Type: CONSTRAINT; Schema: pgmetrics; Owner: grafana
--

ALTER TABLE ONLY pgmetrics.tables_metrics
    ADD CONSTRAINT tables_metrics_pkey PRIMARY KEY (collection_at, id);


--
-- TOC entry 3252 (class 2606 OID 16964)
-- Name: tables_metrics_default tables_metrics_default_pkey; Type: CONSTRAINT; Schema: pgmetrics; Owner: grafana
--

ALTER TABLE ONLY pgmetrics.tables_metrics_default
    ADD CONSTRAINT tables_metrics_default_pkey PRIMARY KEY (collection_at, id);


--
-- TOC entry 3242 (class 2606 OID 16503)
-- Name: wal_metrics wal_metrics_pkey; Type: CONSTRAINT; Schema: pgmetrics; Owner: grafana
--

ALTER TABLE ONLY pgmetrics.wal_metrics
    ADD CONSTRAINT wal_metrics_pkey PRIMARY KEY (collection_at, cluster_name);


--
-- TOC entry 3244 (class 2606 OID 16505)
-- Name: wal_metrics_default wal_metrics_default_pkey; Type: CONSTRAINT; Schema: pgmetrics; Owner: grafana
--

ALTER TABLE ONLY pgmetrics.wal_metrics_default
    ADD CONSTRAINT wal_metrics_default_pkey PRIMARY KEY (collection_at, cluster_name);


--
-- TOC entry 3260 (class 0 OID 0)
-- Name: indexes_metrics_default_pkey; Type: INDEX ATTACH; Schema: pgmetrics; Owner: grafana
--

ALTER INDEX pgmetrics.indexes_metrics_pkey ATTACH PARTITION pgmetrics.indexes_metrics_default_pkey;


--
-- TOC entry 3258 (class 0 OID 0)
-- Name: locks_metrics_default_pkey; Type: INDEX ATTACH; Schema: pgmetrics; Owner: grafana
--

ALTER INDEX pgmetrics.locks_metrics_pkey ATTACH PARTITION pgmetrics.locks_metrics_default_pkey;


--
-- TOC entry 3259 (class 0 OID 0)
-- Name: tables_metrics_default_pkey; Type: INDEX ATTACH; Schema: pgmetrics; Owner: grafana
--

ALTER INDEX pgmetrics.tables_metrics_pkey ATTACH PARTITION pgmetrics.tables_metrics_default_pkey;


--
-- TOC entry 3257 (class 0 OID 0)
-- Name: wal_metrics_default_pkey; Type: INDEX ATTACH; Schema: pgmetrics; Owner: grafana
--

ALTER INDEX pgmetrics.wal_metrics_pkey ATTACH PARTITION pgmetrics.wal_metrics_default_pkey;


--
-- TOC entry 3264 (class 2606 OID 17770)
-- Name: indexes_metrics indexes_metrics_collection_at_cluster_name_fkey; Type: FK CONSTRAINT; Schema: pgmetrics; Owner: grafana
--

ALTER TABLE pgmetrics.indexes_metrics
    ADD CONSTRAINT indexes_metrics_collection_at_cluster_name_fkey FOREIGN KEY (cluster_name, collection_at) REFERENCES pgmetrics.raw_metrics(cluster_name, collection_at);


--
-- TOC entry 3262 (class 2606 OID 16869)
-- Name: locks_metrics locks_metrics_collection_at_cluster_name_fkey; Type: FK CONSTRAINT; Schema: pgmetrics; Owner: grafana
--

ALTER TABLE pgmetrics.locks_metrics
    ADD CONSTRAINT locks_metrics_collection_at_cluster_name_fkey FOREIGN KEY (cluster_name, collection_at) REFERENCES pgmetrics.raw_metrics(cluster_name, collection_at);


--
-- TOC entry 3263 (class 2606 OID 16956)
-- Name: tables_metrics tables_metrics_collection_at_cluster_name_fkey; Type: FK CONSTRAINT; Schema: pgmetrics; Owner: grafana
--

ALTER TABLE pgmetrics.tables_metrics
    ADD CONSTRAINT tables_metrics_collection_at_cluster_name_fkey FOREIGN KEY (cluster_name, collection_at) REFERENCES pgmetrics.raw_metrics(cluster_name, collection_at);


--
-- TOC entry 3261 (class 2606 OID 16512)
-- Name: wal_metrics wal_metrics_collection_at_cluster_name_fkey; Type: FK CONSTRAINT; Schema: pgmetrics; Owner: grafana
--

ALTER TABLE pgmetrics.wal_metrics
    ADD CONSTRAINT wal_metrics_collection_at_cluster_name_fkey FOREIGN KEY (collection_at, cluster_name) REFERENCES pgmetrics.raw_metrics(collection_at, cluster_name);


-- Completed on 2022-05-22 04:18:51 UTC

--
-- PostgreSQL database dump complete
--

--
-- Database "pgbench" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 14.3 (Debian 14.3-1.pgdg110+1)
-- Dumped by pg_dump version 14.2

-- Started on 2022-05-22 04:18:51 UTC

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 3342 (class 1262 OID 16518)
-- Name: pgbench; Type: DATABASE; Schema: -; Owner: pgbench
--

CREATE DATABASE pgbench WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'en_US.utf8';


ALTER DATABASE pgbench OWNER TO pgbench;

\connect pgbench

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 2 (class 3079 OID 16519)
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA public;


--
-- TOC entry 3343 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 214 (class 1259 OID 16743)
-- Name: pgbench_accounts; Type: TABLE; Schema: public; Owner: pgbench
--

CREATE TABLE public.pgbench_accounts (
    aid integer NOT NULL,
    bid integer,
    abalance integer,
    filler character(84)
)
WITH (fillfactor='100');


ALTER TABLE public.pgbench_accounts OWNER TO pgbench;

--
-- TOC entry 215 (class 1259 OID 16746)
-- Name: pgbench_branches; Type: TABLE; Schema: public; Owner: pgbench
--

CREATE TABLE public.pgbench_branches (
    bid integer NOT NULL,
    bbalance integer,
    filler character(88)
)
WITH (fillfactor='100');


ALTER TABLE public.pgbench_branches OWNER TO pgbench;

--
-- TOC entry 212 (class 1259 OID 16737)
-- Name: pgbench_history; Type: TABLE; Schema: public; Owner: pgbench
--

CREATE TABLE public.pgbench_history (
    tid integer,
    bid integer,
    aid integer,
    delta integer,
    mtime timestamp without time zone,
    filler character(22)
);


ALTER TABLE public.pgbench_history OWNER TO pgbench;

--
-- TOC entry 213 (class 1259 OID 16740)
-- Name: pgbench_tellers; Type: TABLE; Schema: public; Owner: pgbench
--

CREATE TABLE public.pgbench_tellers (
    tid integer NOT NULL,
    bid integer,
    tbalance integer,
    filler character(84)
)
WITH (fillfactor='100');


ALTER TABLE public.pgbench_tellers OWNER TO pgbench;

--
-- TOC entry 3193 (class 2606 OID 16758)
-- Name: pgbench_accounts pgbench_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: pgbench
--

ALTER TABLE ONLY public.pgbench_accounts
    ADD CONSTRAINT pgbench_accounts_pkey PRIMARY KEY (aid);


--
-- TOC entry 3195 (class 2606 OID 16754)
-- Name: pgbench_branches pgbench_branches_pkey; Type: CONSTRAINT; Schema: public; Owner: pgbench
--

ALTER TABLE ONLY public.pgbench_branches
    ADD CONSTRAINT pgbench_branches_pkey PRIMARY KEY (bid);


--
-- TOC entry 3191 (class 2606 OID 16756)
-- Name: pgbench_tellers pgbench_tellers_pkey; Type: CONSTRAINT; Schema: public; Owner: pgbench
--

ALTER TABLE ONLY public.pgbench_tellers
    ADD CONSTRAINT pgbench_tellers_pkey PRIMARY KEY (tid);


-- Completed on 2022-05-22 04:18:52 UTC

--
-- PostgreSQL database dump complete
--

--
-- Database "postgres" dump
--

\connect postgres

--
-- PostgreSQL database dump
--

-- Dumped from database version 14.3 (Debian 14.3-1.pgdg110+1)
-- Dumped by pg_dump version 14.2

-- Started on 2022-05-22 04:18:52 UTC

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 7 (class 2615 OID 16562)
-- Name: pgagent; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA pgagent;


ALTER SCHEMA pgagent OWNER TO postgres;

--
-- TOC entry 3444 (class 0 OID 0)
-- Dependencies: 7
-- Name: SCHEMA pgagent; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA pgagent IS 'pgAgent system tables';


--
-- TOC entry 2 (class 3079 OID 16563)
-- Name: pg_buffercache; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_buffercache WITH SCHEMA public;


--
-- TOC entry 3445 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION pg_buffercache; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_buffercache IS 'examine the shared buffer cache';


--
-- TOC entry 3 (class 3079 OID 16569)
-- Name: pgagent; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgagent WITH SCHEMA pgagent;


--
-- TOC entry 3446 (class 0 OID 0)
-- Dependencies: 3
-- Name: EXTENSION pgagent; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgagent IS 'A PostgreSQL job scheduler';


--
-- TOC entry 4 (class 3079 OID 16727)
-- Name: pgstattuple; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgstattuple WITH SCHEMA public;


--
-- TOC entry 3447 (class 0 OID 0)
-- Dependencies: 4
-- Name: EXTENSION pgstattuple; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgstattuple IS 'show tuple-level statistics';


-- Completed on 2022-05-22 04:18:52 UTC

--
-- PostgreSQL database dump complete
--

-- Completed on 2022-05-22 04:18:52 UTC

--
-- PostgreSQL database cluster dump complete
--

