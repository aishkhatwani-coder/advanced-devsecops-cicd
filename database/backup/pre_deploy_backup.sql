--
-- PostgreSQL database dump
--

\restrict U9knfTdli305pLXm8AjkRH1ROtplm7ct2fZIt6hP2dgL1b7uykBEn4qpotfJrSm

-- Dumped from database version 15.19
-- Dumped by pg_dump version 15.19

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
-- Name: system_status; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.system_status (
    id integer NOT NULL,
    environment character varying(50) NOT NULL,
    deployed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.system_status OWNER TO postgres;

--
-- Name: system_status_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.system_status_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.system_status_id_seq OWNER TO postgres;

--
-- Name: system_status_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.system_status_id_seq OWNED BY public.system_status.id;


--
-- Name: system_status id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.system_status ALTER COLUMN id SET DEFAULT nextval('public.system_status_id_seq'::regclass);


--
-- Data for Name: system_status; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.system_status (id, environment, deployed_at) FROM stdin;
1	Blue	2026-09-16 09:09:29.53551
\.


--
-- Name: system_status_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.system_status_id_seq', 1, true);


--
-- Name: system_status system_status_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.system_status
    ADD CONSTRAINT system_status_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

\unrestrict U9knfTdli305pLXm8AjkRH1ROtplm7ct2fZIt6hP2dgL1b7uykBEn4qpotfJrSm

