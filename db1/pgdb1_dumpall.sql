--
-- PostgreSQL database cluster dump
--

-- Started on 2022-02-17 02:16:14 UTC

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE grafana;
ALTER ROLE grafana WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE pgbench;
ALTER ROLE pgbench WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'md56c41c539fab92ea853d5749f10a68353';
ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS PASSWORD 'md515f3d96089c8265531fda2aa459dc427';


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

-- Dumped from database version 14.2 (Debian 14.2-1.pgdg110+1)
-- Dumped by pg_dump version 14.1

-- Started on 2022-02-17 02:16:14 UTC

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

-- Completed on 2022-02-17 02:16:14 UTC

--
-- PostgreSQL database dump complete
--

--
-- Database "grafana" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 14.2 (Debian 14.2-1.pgdg110+1)
-- Dumped by pg_dump version 14.1

-- Started on 2022-02-17 02:16:14 UTC

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
-- TOC entry 3323 (class 1262 OID 16387)
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
-- TOC entry 6 (class 2615 OID 16580)
-- Name: pgstats_history; Type: SCHEMA; Schema: -; Owner: grafana
--

CREATE SCHEMA pgstats_history;


ALTER SCHEMA pgstats_history OWNER TO grafana;

SET default_tablespace = '';

--
-- TOC entry 210 (class 1259 OID 16581)
-- Name: activity_wait_event_type_counts; Type: TABLE; Schema: pgstats_history; Owner: grafana
--

CREATE TABLE pgstats_history.activity_wait_event_type_counts (
    insert_timestamp timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    datid oid NOT NULL,
    activity integer DEFAULT 0,
    bufferpin integer DEFAULT 0,
    client integer DEFAULT 0,
    extension integer DEFAULT 0,
    io integer DEFAULT 0,
    ipc integer DEFAULT 0,
    lock integer DEFAULT 0,
    lwlock integer DEFAULT 0,
    timeout integer DEFAULT 0
)
PARTITION BY RANGE (insert_timestamp);


ALTER TABLE pgstats_history.activity_wait_event_type_counts OWNER TO grafana;

--
-- TOC entry 3178 (class 2606 OID 16595)
-- Name: activity_wait_event_type_counts activity_wait_event_type_counts_pkey; Type: CONSTRAINT; Schema: pgstats_history; Owner: grafana
--

ALTER TABLE ONLY pgstats_history.activity_wait_event_type_counts
    ADD CONSTRAINT activity_wait_event_type_counts_pkey PRIMARY KEY (datid, insert_timestamp);


-- Completed on 2022-02-17 02:16:15 UTC

--
-- PostgreSQL database dump complete
--

--
-- Database "pgbench" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 14.2 (Debian 14.2-1.pgdg110+1)
-- Dumped by pg_dump version 14.1

-- Started on 2022-02-17 02:16:15 UTC

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
-- TOC entry 3328 (class 1262 OID 16388)
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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 209 (class 1259 OID 16389)
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
-- TOC entry 210 (class 1259 OID 16392)
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
-- TOC entry 211 (class 1259 OID 16395)
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
-- TOC entry 212 (class 1259 OID 16398)
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
-- TOC entry 3179 (class 2606 OID 16402)
-- Name: pgbench_accounts pgbench_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: pgbench
--

ALTER TABLE ONLY public.pgbench_accounts
    ADD CONSTRAINT pgbench_accounts_pkey PRIMARY KEY (aid);


--
-- TOC entry 3181 (class 2606 OID 16404)
-- Name: pgbench_branches pgbench_branches_pkey; Type: CONSTRAINT; Schema: public; Owner: pgbench
--

ALTER TABLE ONLY public.pgbench_branches
    ADD CONSTRAINT pgbench_branches_pkey PRIMARY KEY (bid);


--
-- TOC entry 3183 (class 2606 OID 16406)
-- Name: pgbench_tellers pgbench_tellers_pkey; Type: CONSTRAINT; Schema: public; Owner: pgbench
--

ALTER TABLE ONLY public.pgbench_tellers
    ADD CONSTRAINT pgbench_tellers_pkey PRIMARY KEY (tid);


-- Completed on 2022-02-17 02:16:15 UTC

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

-- Dumped from database version 14.2 (Debian 14.2-1.pgdg110+1)
-- Dumped by pg_dump version 14.1

-- Started on 2022-02-17 02:16:15 UTC

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
-- TOC entry 5 (class 2615 OID 16408)
-- Name: pgagent; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA pgagent;


ALTER SCHEMA pgagent OWNER TO postgres;

--
-- TOC entry 3429 (class 0 OID 0)
-- Dependencies: 5
-- Name: SCHEMA pgagent; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA pgagent IS 'pgAgent system tables';


--
-- TOC entry 2 (class 3079 OID 16409)
-- Name: pgagent; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgagent WITH SCHEMA pgagent;


--
-- TOC entry 3430 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION pgagent; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgagent IS 'A PostgreSQL job scheduler';


-- Completed on 2022-02-17 02:16:15 UTC

--
-- PostgreSQL database dump complete
--

-- Completed on 2022-02-17 02:16:15 UTC

--
-- PostgreSQL database cluster dump complete
--

