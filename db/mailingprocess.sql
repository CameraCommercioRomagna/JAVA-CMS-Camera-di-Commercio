--
-- PostgreSQL database dump
--

-- Dumped from database version 11.2
-- Dumped by pg_dump version 11.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: mail; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA mail;


--
-- Name: id_mail; Type: SEQUENCE; Schema: mail; Owner: -
--

CREATE SEQUENCE mail.id_mail
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: pending; Type: TABLE; Schema: mail; Owner: -
--

CREATE TABLE mail.pending (
    id_mail numeric(22,0) NOT NULL,
    mailing numeric(1,0) DEFAULT 0 NOT NULL,
    i_from text NOT NULL,
    i_replyto text,
    i_to text,
    i_cc text,
    i_bcc text,
    contenttype character varying(100) DEFAULT 'text/html; charset=iso-8859-1'::character varying NOT NULL,
    subject character varying(500) NOT NULL,
    body text NOT NULL,
    attach text,
    data_ins date NOT NULL,
    page_ins character(10) NOT NULL,
    spedire_dal date NOT NULL,
    data_polling date,
    estratta numeric(1,0) DEFAULT 0 NOT NULL,
    i_ric_ritorno text
);


--
-- Name: COLUMN pending.i_ric_ritorno; Type: COMMENT; Schema: mail; Owner: -
--

COMMENT ON COLUMN mail.pending.i_ric_ritorno IS 'indirizzo a cui viene spedita la ricevuta di ritorno';


--
-- Name: pending_mail_request; Type: TABLE; Schema: mail; Owner: -
--

CREATE TABLE mail.pending_mail_request (
    mail_token character(64),
    tipo_conferma numeric(22,0) NOT NULL,
    id_utente numeric(22,0) NOT NULL,
    ricevuta_conferma boolean NOT NULL,
    data_inserimento date NOT NULL,
    data_conferma date
);


--
-- Name: progetti; Type: TABLE; Schema: mail; Owner: -
--

CREATE TABLE mail.progetti (
    codice character(6) NOT NULL,
    descrizione character varying(4000) NOT NULL
);


--
-- Name: sent; Type: TABLE; Schema: mail; Owner: -
--

CREATE TABLE mail.sent (
    id_mail numeric(22,0) NOT NULL,
    mailing numeric(1,0) DEFAULT 0 NOT NULL,
    i_from text NOT NULL,
    i_replyto text,
    i_to text NOT NULL,
    i_cc text,
    i_bcc text,
    contenttype character varying(100) NOT NULL,
    subject character varying(500) NOT NULL,
    body text NOT NULL,
    attach text,
    data_ins date NOT NULL,
    page_ins character(10) NOT NULL,
    spedire_dal date NOT NULL,
    data_polling date NOT NULL,
    data_sped date NOT NULL,
    i_ric_ritorno text
);


--
-- Name: COLUMN sent.i_ric_ritorno; Type: COMMENT; Schema: mail; Owner: -
--

COMMENT ON COLUMN mail.sent.i_ric_ritorno IS 'indirizzo a cui viene spedita la ricevuta di ritorno';


--
-- Name: services; Type: TABLE; Schema: mail; Owner: -
--

CREATE TABLE mail.services (
    page character(10) NOT NULL,
    descrizione character varying(4000) NOT NULL,
    progetto character(6) NOT NULL
);


--
-- Name: services mail_pending_pkey; Type: CONSTRAINT; Schema: mail; Owner: -
--

ALTER TABLE ONLY mail.services
    ADD CONSTRAINT mail_pending_pkey PRIMARY KEY (page);


--
-- Name: pending_mail_request pending_mail_request_pkey; Type: CONSTRAINT; Schema: mail; Owner: -
--

ALTER TABLE ONLY mail.pending_mail_request
    ADD CONSTRAINT pending_mail_request_pkey PRIMARY KEY (id_utente, tipo_conferma);


--
-- Name: pending pending_pkey; Type: CONSTRAINT; Schema: mail; Owner: -
--

ALTER TABLE ONLY mail.pending
    ADD CONSTRAINT pending_pkey PRIMARY KEY (id_mail);


--
-- Name: progetti progetti_pkey; Type: CONSTRAINT; Schema: mail; Owner: -
--

ALTER TABLE ONLY mail.progetti
    ADD CONSTRAINT progetti_pkey PRIMARY KEY (codice);


--
-- Name: sent sent_pkey; Type: CONSTRAINT; Schema: mail; Owner: -
--

ALTER TABLE ONLY mail.sent
    ADD CONSTRAINT sent_pkey PRIMARY KEY (id_mail);


--
-- Name: idx_mail_token; Type: INDEX; Schema: mail; Owner: -
--

CREATE INDEX idx_mail_token ON mail.pending_mail_request USING btree (mail_token);


--
-- Name: pending pending_page_ins_fkey; Type: FK CONSTRAINT; Schema: mail; Owner: -
--

ALTER TABLE ONLY mail.pending
    ADD CONSTRAINT pending_page_ins_fkey FOREIGN KEY (page_ins) REFERENCES mail.services(page);


--
-- Name: sent sent_page_ins_fkey; Type: FK CONSTRAINT; Schema: mail; Owner: -
--

ALTER TABLE ONLY mail.sent
    ADD CONSTRAINT sent_page_ins_fkey FOREIGN KEY (page_ins) REFERENCES mail.services(page);


--
-- Name: services services_progetto_fkey; Type: FK CONSTRAINT; Schema: mail; Owner: -
--

ALTER TABLE ONLY mail.services
    ADD CONSTRAINT services_progetto_fkey FOREIGN KEY (progetto) REFERENCES mail.progetti(codice);


--
-- PostgreSQL database dump complete
--

