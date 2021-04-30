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
-- Name: appuntamenti; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA appuntamenti;


--
-- Name: congiuntura; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA congiuntura;


--
-- Name: congiuntura_rimini; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA congiuntura_rimini;


--
-- Name: geografia; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA geografia;


--
-- Name: portalowner2; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA portalowner2;


--
-- Name: portalowner_old; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA portalowner_old;


--
-- Name: prezzi; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA prezzi;


--
-- Name: ltree; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS ltree WITH SCHEMA public;


--
-- Name: EXTENSION ltree; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION ltree IS 'data type for hierarchical tree-like structures';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: annotazioni; Type: TABLE; Schema: appuntamenti; Owner: -
--

CREATE TABLE appuntamenti.annotazioni (
    id_annotazione numeric(22,0) NOT NULL,
    data date NOT NULL,
    note_riservate character varying(4000),
    chiuso boolean DEFAULT false,
    cod_sportello text NOT NULL
);


--
-- Name: appuntamenti; Type: TABLE; Schema: appuntamenti; Owner: -
--

CREATE TABLE appuntamenti.appuntamenti (
    id_appuntamento numeric(22,0) NOT NULL,
    cod_sportello text NOT NULL,
    id_servizio numeric(22,0) NOT NULL,
    inizio timestamp without time zone NOT NULL,
    fine timestamp without time zone NOT NULL,
    id_intermediario numeric(22,0),
    nome text,
    cognome text,
    email text,
    telefono text,
    note text,
    id_utente numeric(22,0),
    data_inserimento timestamp without time zone DEFAULT now() NOT NULL,
    data_prenotazione timestamp without time zone,
    data_cancellazione timestamp without time zone,
    data_garbage_collection timestamp without time zone,
    codice_fiscale text,
    codice character varying(25)
);


--
-- Name: COLUMN appuntamenti.data_garbage_collection; Type: COMMENT; Schema: appuntamenti; Owner: -
--

COMMENT ON COLUMN appuntamenti.appuntamenti.data_garbage_collection IS 'Viene impostata dall''applicazione quando un appuntamento opzionao non viene prenotato entro il tempo massimo';


--
-- Name: fasce_apertura; Type: TABLE; Schema: appuntamenti; Owner: -
--

CREATE TABLE appuntamenti.fasce_apertura (
    id_fascia_apertura numeric(22,0) NOT NULL,
    cod_sportello text NOT NULL,
    pattern text NOT NULL,
    note text,
    attiva boolean DEFAULT false NOT NULL
);


--
-- Name: id_annotazione; Type: SEQUENCE; Schema: appuntamenti; Owner: -
--

CREATE SEQUENCE appuntamenti.id_annotazione
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: id_appuntamento; Type: SEQUENCE; Schema: appuntamenti; Owner: -
--

CREATE SEQUENCE appuntamenti.id_appuntamento
    START WITH 2
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: id_intermediario; Type: SEQUENCE; Schema: appuntamenti; Owner: -
--

CREATE SEQUENCE appuntamenti.id_intermediario
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: id_pratica; Type: SEQUENCE; Schema: appuntamenti; Owner: -
--

CREATE SEQUENCE appuntamenti.id_pratica
    START WITH 2
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: intermediari; Type: TABLE; Schema: appuntamenti; Owner: -
--

CREATE TABLE appuntamenti.intermediari (
    id_intermediario numeric(22,0) NOT NULL,
    nome character varying(50),
    cognome text NOT NULL,
    codice_fiscale character varying(30) NOT NULL,
    partita_iva character varying(30),
    email character varying(100),
    organizzazione text,
    attivo boolean DEFAULT true NOT NULL,
    telefono character varying(100)
);


--
-- Name: pratiche; Type: TABLE; Schema: appuntamenti; Owner: -
--

CREATE TABLE appuntamenti.pratiche (
    id_pratica numeric(22,0) NOT NULL,
    id_appuntamento numeric(22,0) NOT NULL,
    utenza_privato boolean,
    intestatario_nome text,
    intestatario_cognome text,
    intestatario_ragione_sociale text,
    intestatario_cf text,
    referente_nome text,
    referente_cognome text,
    referente_cf text,
    id_servizio numeric(22,0) NOT NULL,
    tipo_pratica text
);


--
-- Name: rel_sportelli_servizi; Type: TABLE; Schema: appuntamenti; Owner: -
--

CREATE TABLE appuntamenti.rel_sportelli_servizi (
    cod_sportello text NOT NULL,
    id_servizio numeric(22,0) NOT NULL
);


--
-- Name: servizi; Type: TABLE; Schema: appuntamenti; Owner: -
--

CREATE TABLE appuntamenti.servizi (
    id_servizio numeric(22,0) NOT NULL,
    nome text NOT NULL,
    numero_slot numeric(22,0) NOT NULL,
    pubblico boolean,
    attivo boolean,
    gg_anticipo_prenotazione numeric(22,0) NOT NULL
);

--
-- Name: sportelli; Type: TABLE; Schema: appuntamenti; Owner: -
--

CREATE TABLE appuntamenti.sportelli (
    cod_sportello text NOT NULL,
    nome text NOT NULL,
    sede text NOT NULL
);


--
-- Name: autorizzazioni; Type: TABLE; Schema: portalowner2; Owner: -
--

CREATE TABLE portalowner2.autorizzazioni (
    id_autorizzazione numeric(22,0) NOT NULL,
    nome text NOT NULL,
    descrizione text,
    per_documenti_web boolean DEFAULT false NOT NULL
);


--
-- Name: bisogni; Type: TABLE; Schema: portalowner2; Owner: -
--

CREATE TABLE portalowner2.bisogni (
    id_bisogno numeric(22,0) NOT NULL,
    nome text,
    id_bisogno_padre numeric(22,0),
    ordine numeric(3,0),
    attivo boolean DEFAULT false NOT NULL,
    url text
);


--
-- Name: cc_argomenti; Type: TABLE; Schema: portalowner2; Owner: -
--

CREATE TABLE portalowner2.cc_argomenti (
    id_cc_argomento numeric(22,0) NOT NULL,
    descrizione character varying(400),
    id_area_servizio numeric(22,0),
    visibile boolean DEFAULT true
);


--
-- Name: cc_download_quesiti_risposte; Type: TABLE; Schema: portalowner2; Owner: -
--

CREATE TABLE portalowner2.cc_download_quesiti_risposte (
    id_download_cc numeric(22,0) NOT NULL,
    id_quesito numeric(22,0),
    id_risposta numeric(22,0),
    url_file character varying(200),
    nome_file character varying(200)
);


--
-- Name: cc_quesiti; Type: TABLE; Schema: portalowner2; Owner: -
--

CREATE TABLE portalowner2.cc_quesiti (
    id_quesito numeric(22,0) NOT NULL,
    rag_sociale_impresa character varying(200) NOT NULL,
    num_rea character varying(200),
    id_area_servizio numeric(22,0) NOT NULL,
    id_area_interesse numeric(22,0),
    id_utente numeric(22,0) NOT NULL,
    testo_quesito text NOT NULL,
    data_inserimento timestamp without time zone,
    id_stato numeric(22,0) NOT NULL,
    data_chiusura_op timestamp without time zone,
    data_chiusura_admin timestamp without time zone,
    id_operatore numeric(22,0),
    id_amministratore numeric(22,0),
    allegato_f0 character varying(300),
    allegato_f1 character varying(300),
    allegato_f2 character varying(300),
    data_assegnazione timestamp without time zone,
    data_trattazione timestamp without time zone,
    id_user_smistatore numeric(22,0),
    oggetto character varying(250),
    faq numeric(22,0) DEFAULT NULL::numeric,
    id_cc_argomento numeric(22,0),
    note_operatore text,
    testo_quesito_1 text,
    testo_quesito_2 text,
    id_quesito_upload numeric,
    da_validare boolean DEFAULT false
);


--
-- Name: cc_risposte; Type: TABLE; Schema: portalowner2; Owner: -
--

CREATE TABLE portalowner2.cc_risposte (
    id_risposta numeric(22,0) NOT NULL,
    id_quesito numeric(22,0) NOT NULL,
    testo_risposta text,
    data_inserimento timestamp without time zone NOT NULL,
    data_invio timestamp without time zone,
    allegato_f0 character varying(300),
    allegato_f1 character varying(300),
    allegato_f2 character varying(300),
    data_validazione timestamp without time zone,
    data_chiusura_op timestamp without time zone,
    id_operatore numeric(22,0),
    testo_risposta_1 text,
    ultima boolean
);


--
-- Name: cc_stati_quesito; Type: TABLE; Schema: portalowner2; Owner: -
--

CREATE TABLE portalowner2.cc_stati_quesito (
    id_stato numeric(22,0) NOT NULL,
    nome character varying(200)
);


--
-- Name: documenti_web; Type: TABLE; Schema: portalowner2; Owner: -
--

CREATE TABLE portalowner2.documenti_web (
    id_documento_web numeric(22,0) NOT NULL,
    id_tipo_sistema numeric(22,0) NOT NULL,
    id_tipo_documento_web numeric(22,0) NOT NULL,
    titolo text,
    abstract_txt text,
    icona text,
    url text,
    id_autorizzazione numeric(22,0),
    dal date,
    al date,
    note_periodo text,
    id_luogo numeric(22,0),
    note_luogo text,
    id_proprietario numeric(22,0) DEFAULT 3419 NOT NULL,
    parole_chiave text,
    data_inserimento timestamp without time zone DEFAULT ('now'::text)::date,
    data_pubblicazione date,
    data_scadenza date,
    validato boolean,
    data_validazione timestamp without time zone,
    data_modifica timestamp without time zone,
    punteggio numeric(22,0) DEFAULT 0,
    priorita numeric(1,0) DEFAULT 2,
    ref_nome character varying(100),
    ref_email character varying(500),
    ref_tel character varying(500),
    ref_info text,
    a_pagamento boolean,
    da_confermare boolean,
    confermato boolean,
    iscrizione_online boolean DEFAULT false,
    data_scadenza_iscr date,
    incontro_relatore boolean DEFAULT false,
    disponibilita_atti boolean DEFAULT false,
    paperless boolean DEFAULT false,
    data_ultimo_aggiornamento timestamp without time zone,
    anno_pertinenza numeric(4,0),
    url_amministrazione text,
    visualizza_indice boolean DEFAULT false NOT NULL,
    id_ainteresse_old numeric(22,0),
    indice_ritardo_aggiornamento numeric(22,10),
    indice_ritardo_aggiornamento_sezione numeric(22,10),
    alias text,
    indicazione_orario text,
    conf_iscr_note text,
    conf_iscr_privacy text,
    abilita_modalita_mista boolean,
    iscrizione_online_url_ext text
);


--
-- Name: COLUMN documenti_web.url_amministrazione; Type: COMMENT; Schema: portalowner2; Owner: -
--

COMMENT ON COLUMN portalowner2.documenti_web.url_amministrazione IS 'Utilizzzato dai documenti di tipo "servizio online" per identificare l''URL di accesso all''area di ammnistrazione';


--
-- Name: email_punti; Type: TABLE; Schema: portalowner2; Owner: -
--

CREATE TABLE portalowner2.email_punti (
    id_email_punto numeric(22,0) NOT NULL,
    id_email_web numeric(22,0) NOT NULL,
    info_data text,
    info_ora_inizio text,
    info_ora_fine text,
    titolo text,
    testo text,
    img_path text,
    img_url text,
    ordine numeric(3,0) DEFAULT 1
);


--
-- Name: email_web; Type: TABLE; Schema: portalowner2; Owner: -
--

CREATE TABLE portalowner2.email_web (
    id_email_web numeric(22,0) NOT NULL,
    id_documento_web numeric(22,0) NOT NULL,
    titolo text,
    abstract_txt text,
    icona text,
    dal date,
    al date,
    note_periodo text,
    indicazione_orario text,
    id_luogo numeric(22,0),
    note_luogo text,
    id_proprietario numeric(22,0) DEFAULT 3419 NOT NULL,
    data_inserimento timestamp without time zone DEFAULT ('now'::text)::date
);


--
-- Name: enti; Type: TABLE; Schema: portalowner2; Owner: -
--

CREATE TABLE portalowner2.enti (
    id_ente numeric(22,0) NOT NULL,
    nome text NOT NULL,
    indirizzo text,
    provincia character varying(5),
    tel character varying(500),
    email character varying(500),
    url text,
    img_path text,
    note text,
    nazione text
);


--
-- Name: id_documento_web; Type: SEQUENCE; Schema: portalowner2; Owner: -
--

CREATE SEQUENCE portalowner2.id_documento_web
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: id_download_cc; Type: SEQUENCE; Schema: portalowner2; Owner: -
--

CREATE SEQUENCE portalowner2.id_download_cc
    START WITH 50
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: id_email_punto; Type: SEQUENCE; Schema: portalowner2; Owner: -
--

CREATE SEQUENCE portalowner2.id_email_punto
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: id_email_web; Type: SEQUENCE; Schema: portalowner2; Owner: -
--

CREATE SEQUENCE portalowner2.id_email_web
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: id_ente; Type: SEQUENCE; Schema: portalowner2; Owner: -
--

CREATE SEQUENCE portalowner2.id_ente
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: id_iscrizione; Type: SEQUENCE; Schema: portalowner2; Owner: -
--

CREATE SEQUENCE portalowner2.id_iscrizione
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: id_luogo; Type: SEQUENCE; Schema: portalowner2; Owner: -
--

CREATE SEQUENCE portalowner2.id_luogo
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: id_nl_numero; Type: SEQUENCE; Schema: portalowner2; Owner: -
--

CREATE SEQUENCE portalowner2.id_nl_numero
    START WITH 50
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: id_nl_pubblicazione; Type: SEQUENCE; Schema: portalowner2; Owner: -
--

CREATE SEQUENCE portalowner2.id_nl_pubblicazione
    START WITH 5000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: id_paragrafo; Type: SEQUENCE; Schema: portalowner2; Owner: -
--

CREATE SEQUENCE portalowner2.id_paragrafo
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: id_punto; Type: SEQUENCE; Schema: portalowner2; Owner: -
--

CREATE SEQUENCE portalowner2.id_punto
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: id_quesito; Type: SEQUENCE; Schema: portalowner2; Owner: -
--

CREATE SEQUENCE portalowner2.id_quesito
    START WITH 20000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: id_quesito_upload; Type: SEQUENCE; Schema: portalowner2; Owner: -
--

CREATE SEQUENCE portalowner2.id_quesito_upload
    START WITH 35000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: id_risposta; Type: SEQUENCE; Schema: portalowner2; Owner: -
--

CREATE SEQUENCE portalowner2.id_risposta
    START WITH 20000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: id_utentenl; Type: SEQUENCE; Schema: portalowner2; Owner: -
--

CREATE SEQUENCE portalowner2.id_utentenl
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: immagini; Type: TABLE; Schema: portalowner2; Owner: -
--

CREATE TABLE portalowner2.immagini (
    id_immagine numeric(22,0) NOT NULL,
    id_documento_web numeric(22,0) NOT NULL,
    titolo text,
    img_path text,
    img_url text,
    testo text,
    ordine numeric(3,0) DEFAULT 1
);


--
-- Name: luoghi; Type: TABLE; Schema: portalowner2; Owner: -
--

CREATE TABLE portalowner2.luoghi (
    id_luogo numeric(22,0) NOT NULL,
    nome text NOT NULL,
    indirizzo text,
    provincia character varying(5),
    note text,
    citta text,
    no_gmaps boolean DEFAULT false
);


--
-- Name: nl_numeri; Type: TABLE; Schema: portalowner2; Owner: -
--

CREATE TABLE portalowner2.nl_numeri (
    id_nl_numero numeric(22,0) NOT NULL,
    id_nl_tipo numeric(22,0) NOT NULL,
    data date NOT NULL,
    data_pubblicazione date,
    numero numeric(22,0)
);


--
-- Name: nl_pubblicazioni; Type: TABLE; Schema: portalowner2; Owner: -
--

CREATE TABLE portalowner2.nl_pubblicazioni (
    id_nl_pubblicazione numeric(22,0) NOT NULL,
    id_nl_numero numeric(22,0) NOT NULL,
    id_nl_tipo numeric(22,0) NOT NULL,
    data date NOT NULL,
    sezione character varying(150) NOT NULL,
    id_documento_web numeric(22,0) NOT NULL,
    ordine numeric(22,0),
    data_validazione date,
    data_richiesta date NOT NULL
);


--
-- Name: nl_sezioni; Type: TABLE; Schema: portalowner2; Owner: -
--

CREATE TABLE portalowner2.nl_sezioni (
    id_nl_tipo numeric(22,0) NOT NULL,
    nome character varying(150) NOT NULL,
    ordine numeric(22,0) NOT NULL,
    icona character varying(150) NOT NULL,
    valida boolean
);


--
-- Name: nl_tipi; Type: TABLE; Schema: portalowner2; Owner: -
--

CREATE TABLE portalowner2.nl_tipi (
    id_nl_tipo numeric(22,0) NOT NULL,
    nome character varying(100) NOT NULL,
    num_max_numeri numeric(22,0) NOT NULL,
    descrizione text NOT NULL,
    gg_associa_entro numeric(22,0) NOT NULL,
    id_tipo_documento_web numeric(22,0),
    url_pubblico character varying(100)
);


--
-- Name: pagamenti_online; Type: TABLE; Schema: portalowner2; Owner: -
--

CREATE TABLE portalowner2.pagamenti_online (
    merchantorderid character varying NOT NULL,
    data date NOT NULL,
    richiedente_nome character varying NOT NULL,
    richiedente_tel character varying NOT NULL,
    richiedente_email character varying NOT NULL,
    intestatario_nome character varying NOT NULL,
    intestatario_indirizzo character varying NOT NULL,
    intestatario_cfis character varying NOT NULL,
    intestatario_piva character varying NOT NULL,
    pagamento_email character varying NOT NULL,
    pagamento_servizio character varying NOT NULL,
    pagamento_descrizione character varying NOT NULL,
    pagamento_importo character varying NOT NULL,
    pagamento_valuta character varying DEFAULT '978'::character varying NOT NULL,
    pagamento_stf_descr character varying NOT NULL,
    pagamento_back character varying NOT NULL,
    stf_initresp_securitytoken character varying,
    stf_initresp_paymentid character varying,
    stf_initresp_hostedpageurl character varying,
    stf_initresp_data date,
    stf_notify_paymentid character varying,
    stf_notify_result character varying,
    stf_notify_responsecode character varying,
    stf_notify_authorizationcode character varying,
    stf_notify_merchantorderid character varying,
    stf_notify_threedsecure character varying,
    stf_notify_rrn character varying,
    stf_notify_maskedpan character varying,
    stf_notify_cardcountry character varying,
    stf_notify_customfield character varying,
    stf_notify_securitytoken character varying,
    stf_notify_data date
);


--
-- Name: paragrafi; Type: TABLE; Schema: portalowner2; Owner: -
--

CREATE TABLE portalowner2.paragrafi (
    id_paragrafo numeric(22,0) NOT NULL,
    id_documento_web numeric(22,0) NOT NULL,
    titolo text,
    testo text,
    img_path text,
    img_url text,
    ordine numeric(3,0) DEFAULT 1
);


--
-- Name: punti_programma; Type: TABLE; Schema: portalowner2; Owner: -
--

CREATE TABLE portalowner2.punti_programma (
    id_punto numeric(22,0) NOT NULL,
    id_documento_web numeric(22,0) NOT NULL,
    info_data text,
    info_ora_inizio text,
    info_ora_fine text,
    titolo text,
    testo text,
    img_path text,
    img_url text,
    ordine numeric(3,0) DEFAULT 1
);


--
-- Name: rel_documenti_web_bisogni; Type: TABLE; Schema: portalowner2; Owner: -
--

CREATE TABLE portalowner2.rel_documenti_web_bisogni (
    id_documento_web numeric(22,0) NOT NULL,
    id_bisogno numeric(22,0) NOT NULL,
    ordine numeric(3,0) DEFAULT 1
);


--
-- Name: rel_documenti_web_documenti; Type: TABLE; Schema: portalowner2; Owner: -
--

CREATE TABLE portalowner2.rel_documenti_web_documenti (
    id_documento_web_padre numeric(22,0) NOT NULL,
    id_documento_web_figlio numeric(22,0) NOT NULL,
    padre_principale boolean DEFAULT false,
    ordine numeric(7,0) DEFAULT 1
);


--
-- Name: rel_documenti_web_enti; Type: TABLE; Schema: portalowner2; Owner: -
--

CREATE TABLE portalowner2.rel_documenti_web_enti (
    id_documento_web numeric(22,0) NOT NULL,
    id_ente numeric(22,0) NOT NULL,
    id_tipo_collaborazione numeric(22,0) DEFAULT 1 NOT NULL,
    ordine numeric(3,0) DEFAULT 1
);


--
-- Name: rel_documenti_web_iscrizioni; Type: TABLE; Schema: portalowner2; Owner: -
--

CREATE TABLE portalowner2.rel_documenti_web_iscrizioni (
    id_iscrizione numeric(22,0) NOT NULL,
    id_documento_web numeric(22,0) NOT NULL,
    data_iscrizione timestamp without time zone DEFAULT now(),
    nome character varying(100),
    cognome character varying(100),
    indirizzo text,
    cap character varying(5),
    comune character varying(100),
    provincia character varying(100),
    stato character varying(100),
    telefono character varying(500),
    email character varying(500) NOT NULL,
    num_civ character varying(10),
    rag_sociale text,
    ruolo character varying(100),
    attivita_azienda text,
    p_iva character varying(50),
    c_fiscale character varying(50),
    email_fatturazione character varying(500),
    note text,
    incontro_relatori boolean DEFAULT false,
    info_relatori text,
    interesse_atti boolean DEFAULT false,
    pagamento_online boolean DEFAULT false,
    scontistica text,
    corsi_condizioni numeric(22,0) DEFAULT 1,
    privacy_dati boolean DEFAULT false,
    privacy_mail boolean DEFAULT false,
    modalita_di_presenza text
);


--
-- Name: rel_tipi_documento_web; Type: TABLE; Schema: portalowner2; Owner: -
--

CREATE TABLE portalowner2.rel_tipi_documento_web (
    id_tipo_documento_web_padre numeric(22,0) NOT NULL,
    id_tipo_documento_web_figlio numeric(22,0) NOT NULL
);


--
-- Name: rel_utenti_autorizzazioni; Type: TABLE; Schema: portalowner2; Owner: -
--

CREATE TABLE portalowner2.rel_utenti_autorizzazioni (
    id_utente numeric(22,0) NOT NULL,
    id_autorizzazione numeric(22,0) NOT NULL
);


--
-- Name: rel_utenti_tematiche_nl; Type: TABLE; Schema: portalowner2; Owner: -
--

CREATE TABLE portalowner2.rel_utenti_tematiche_nl (
    id_utente numeric(22,0) NOT NULL,
    id_tematica numeric(22,0) NOT NULL
);


--
-- Name: tematiche_nl; Type: TABLE; Schema: portalowner2; Owner: -
--

CREATE TABLE portalowner2.tematiche_nl (
    id_tematica numeric(22,0) NOT NULL,
    nome text NOT NULL,
    id_plp character varying(36) NOT NULL
);


--
-- Name: tipi_collaborazione; Type: TABLE; Schema: portalowner2; Owner: -
--

CREATE TABLE portalowner2.tipi_collaborazione (
    id_tipo_collaborazione numeric(22,0) NOT NULL,
    nome text NOT NULL
);


--
-- Name: tipi_documento_web; Type: TABLE; Schema: portalowner2; Owner: -
--

CREATE TABLE portalowner2.tipi_documento_web (
    id_tipo_documento_web numeric(22,0) NOT NULL,
    nome text,
    id_gruppo_admin numeric(22,0),
    with_dweb boolean
);


--
-- Name: tipi_sistema; Type: TABLE; Schema: portalowner2; Owner: -
--

CREATE TABLE portalowner2.tipi_sistema (
    id_tipo_sistema numeric(22,0) NOT NULL,
    nome text
);


--
-- Name: utenti; Type: TABLE; Schema: portalowner2; Owner: -
--

CREATE TABLE portalowner2.utenti (
    id_utente numeric(22,0) NOT NULL,
    username character varying(30),
    password character varying(30),
    nome character varying(50),
    cognome character varying(50),
    indirizzo character varying(100),
    id_nazione numeric(22,0),
    cod_fiscale character varying(50),
    telefono character varying(50),
    cellulare character varying(50),
    email character varying(500),
    sesso character varying(10),
    data_nascita date,
    note text,
    privacy_dati boolean DEFAULT false,
    privacy_mail boolean DEFAULT false,
    valido boolean DEFAULT true NOT NULL,
    data_register timestamp without time zone DEFAULT now(),
    data_change_pwd timestamp without time zone
);


--
-- Name: utenti_nl; Type: TABLE; Schema: portalowner2; Owner: -
--

CREATE TABLE portalowner2.utenti_nl (
    id_utente numeric(22,0) NOT NULL,
    email character varying(500),
    password character varying(100),
    nome character varying(50),
    cognome character varying(50),
    organizzazione character varying(1000),
    telefono character varying(100),
    data_inserimento date DEFAULT ('now'::text)::date,
    data_attivazione date,
    privacy_dati boolean DEFAULT false,
    privacy_mail boolean DEFAULT false,
    valido boolean DEFAULT true NOT NULL,
    key character varying(100)
);


--
-- Name: documenti_web; Type: TABLE; Schema: portalowner_old; Owner: -
--

CREATE TABLE portalowner_old.documenti_web (
    id_documento_web numeric(22,0) NOT NULL,
    id_tipo_sistema numeric(22,0) NOT NULL,
    id_tipo_documento_web numeric(22,0) NOT NULL,
    titolo text,
    abstract_txt text,
    icona text,
    url text,
    id_autorizzazione numeric(22,0),
    dal date,
    al date,
    note_periodo text,
    id_luogo numeric(22,0),
    note_luogo text,
    id_proprietario numeric(22,0) DEFAULT 3419 NOT NULL,
    parole_chiave text,
    data_inserimento timestamp without time zone DEFAULT ('now'::text)::date,
    data_pubblicazione date,
    data_scadenza date,
    validato boolean,
    data_validazione timestamp without time zone,
    data_modifica timestamp without time zone,
    punteggio numeric(22,0) DEFAULT 0,
    priorita numeric(1,0) DEFAULT 2,
    ref_nome character varying(100),
    ref_email character varying(500),
    ref_tel character varying(500),
    ref_info text,
    a_pagamento boolean,
    da_confermare boolean,
    confermato boolean,
    iscrizione_online boolean DEFAULT false,
    data_scadenza_iscr date,
    incontro_relatore boolean DEFAULT false,
    disponibilita_atti boolean DEFAULT false,
    paperless boolean DEFAULT false,
    data_ultimo_aggiornamento timestamp without time zone,
    anno_pertinenza numeric(4,0),
    url_amministrazione text,
    visualizza_indice boolean DEFAULT false NOT NULL,
    id_ainteresse_old numeric(22,0),
    indice_ritardo_aggiornamento numeric(22,10),
    indice_ritardo_aggiornamento_sezione numeric(22,10),
    alias text
);


--
-- Name: id_documento_web; Type: SEQUENCE; Schema: portalowner_old; Owner: -
--

CREATE SEQUENCE portalowner_old.id_documento_web
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: id_paragrafo; Type: SEQUENCE; Schema: portalowner_old; Owner: -
--

CREATE SEQUENCE portalowner_old.id_paragrafo
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: paragrafi; Type: TABLE; Schema: portalowner_old; Owner: -
--

CREATE TABLE portalowner_old.paragrafi (
    id_paragrafo numeric(22,0) NOT NULL,
    id_documento_web numeric(22,0) NOT NULL,
    titolo text,
    testo text,
    img_path text,
    img_url text,
    ordine numeric(3,0) DEFAULT 1
);


--
-- Name: rel_documenti_web_documenti; Type: TABLE; Schema: portalowner_old; Owner: -
--

CREATE TABLE portalowner_old.rel_documenti_web_documenti (
    id_documento_web_padre numeric(22,0) NOT NULL,
    id_documento_web_figlio numeric(22,0) NOT NULL,
    padre_principale boolean DEFAULT false,
    ordine numeric(7,0) DEFAULT 1
);


--
-- Name: categorie; Type: TABLE; Schema: prezzi; Owner: -
--

CREATE TABLE prezzi.categorie (
    id_categoria numeric(22,0) NOT NULL,
    nome text NOT NULL,
    descrizione text,
    note text,
    path public.ltree,
    ordine numeric(22,0),
    id_tipo_listino numeric(22,0) NOT NULL,
    visualizzabile boolean DEFAULT false,
    validita_init date,
    validita_fine date,
    path_appoggio text,
    ordine_assoluto numeric(22,0)
);


--
-- Name: id_categoria; Type: SEQUENCE; Schema: prezzi; Owner: -
--

CREATE SEQUENCE prezzi.id_categoria
    START WITH 416
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: id_informatore; Type: SEQUENCE; Schema: prezzi; Owner: -
--

CREATE SEQUENCE prezzi.id_informatore
    START WITH 55
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: id_listino; Type: SEQUENCE; Schema: prezzi; Owner: -
--

CREATE SEQUENCE prezzi.id_listino
    START WITH 2435
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: id_prodotto; Type: SEQUENCE; Schema: prezzi; Owner: -
--

CREATE SEQUENCE prezzi.id_prodotto
    START WITH 2716
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: informatori; Type: TABLE; Schema: prezzi; Owner: -
--

CREATE TABLE prezzi.informatori (
    id_informatore numeric(22,0) NOT NULL,
    identita text NOT NULL,
    codice_fiscale text,
    note text,
    id_commissione numeric(22,0),
    valido boolean DEFAULT true
);


--
-- Name: listini; Type: TABLE; Schema: prezzi; Owner: -
--

CREATE TABLE prezzi.listini (
    id_listino numeric(22,0) NOT NULL,
    nome text,
    descrizione text,
    note text,
    data_pubbl date,
    id_tipo_listino numeric(22,0) NOT NULL,
    id_documento_web numeric(22,0),
    data_inserimento timestamp without time zone,
    num numeric(22,0),
    data_validazione date,
    validato boolean,
    pubblicato boolean
);


--
-- Name: listini_annuali; Type: VIEW; Schema: prezzi; Owner: -
--

CREATE VIEW prezzi.listini_annuali AS
 SELECT DISTINCT (('Listino annuale dei prezzi all''ingrosso e alla produzione anno '::text || (date_part('year'::text, l.data_pubbl))::text) || ' - Forlì-Cesena'::text) AS nome,
    (date_part('year'::text, l.data_pubbl))::integer AS anno
   FROM prezzi.listini l
  WHERE (((date_part('year'::text, l.data_pubbl))::text < (date_part('year'::text, CURRENT_DATE))::text) AND (l.id_tipo_listino = (1)::numeric))
  ORDER BY ((date_part('year'::text, l.data_pubbl))::integer), (('Listino annuale dei prezzi all''ingrosso e alla produzione anno '::text || (date_part('year'::text, l.data_pubbl))::text) || ' - Forlì-Cesena'::text);


--
-- Name: listini_mensili; Type: VIEW; Schema: prezzi; Owner: -
--

CREATE VIEW prezzi.listini_mensili AS
 SELECT DISTINCT ((((('Listino Mensile dei prezzi n°'::text || (date_part('month'::text, l.data_pubbl))::text) || ' - '::text) ||
        CASE
            WHEN (btrim(to_char((l.data_pubbl)::timestamp with time zone, 'Month'::text)) = 'January'::text) THEN 'gennaio'::text
            WHEN (btrim(to_char((l.data_pubbl)::timestamp with time zone, 'Month'::text)) = 'February'::text) THEN 'febbraio'::text
            WHEN (btrim(to_char((l.data_pubbl)::timestamp with time zone, 'Month'::text)) = 'March'::text) THEN 'marzo'::text
            WHEN (btrim(to_char((l.data_pubbl)::timestamp with time zone, 'Month'::text)) = 'April'::text) THEN 'aprile'::text
            WHEN (btrim(to_char((l.data_pubbl)::timestamp with time zone, 'Month'::text)) = 'May'::text) THEN 'maggio'::text
            WHEN (btrim(to_char((l.data_pubbl)::timestamp with time zone, 'Month'::text)) = 'June'::text) THEN 'giugno'::text
            WHEN (btrim(to_char((l.data_pubbl)::timestamp with time zone, 'Month'::text)) = 'July'::text) THEN 'luglio'::text
            WHEN (btrim(to_char((l.data_pubbl)::timestamp with time zone, 'Month'::text)) = 'August'::text) THEN 'agosto'::text
            WHEN (btrim(to_char((l.data_pubbl)::timestamp with time zone, 'Month'::text)) = 'September'::text) THEN 'settembre'::text
            WHEN (btrim(to_char((l.data_pubbl)::timestamp with time zone, 'Month'::text)) = 'October'::text) THEN 'ottobre'::text
            WHEN (btrim(to_char((l.data_pubbl)::timestamp with time zone, 'Month'::text)) = 'November'::text) THEN 'novembre'::text
            WHEN (btrim(to_char((l.data_pubbl)::timestamp with time zone, 'Month'::text)) = 'December'::text) THEN 'dicembre'::text
            ELSE NULL::text
        END) || ' '::text) || (date_part('year'::text, l.data_pubbl))::text) AS nome,
    date_part('month'::text, l.data_pubbl) AS mese,
    date_part('year'::text, l.data_pubbl) AS anno
   FROM prezzi.listini l
  WHERE ((((date_part('year'::text, l.data_pubbl))::text || (date_part('month'::text, l.data_pubbl))::text) < ((date_part('year'::text, CURRENT_DATE))::text || (date_part('month'::text, CURRENT_DATE))::text)) AND (l.id_tipo_listino = (1)::numeric))
  ORDER BY (date_part('year'::text, l.data_pubbl)), (date_part('month'::text, l.data_pubbl));


--
-- Name: listini_precedenti; Type: VIEW; Schema: prezzi; Owner: -
--

CREATE VIEW prezzi.listini_precedenti AS
SELECT
    NULL::numeric(22,0) AS id_listino,
    NULL::text AS nome,
    NULL::text AS descrizione,
    NULL::text AS note,
    NULL::date AS data_pubbl,
    NULL::numeric(22,0) AS id_tipo_listino,
    NULL::numeric(22,0) AS id_documento_web,
    NULL::timestamp without time zone AS data_inserimento,
    NULL::numeric(22,0) AS num,
    NULL::date AS data_validazione,
    NULL::boolean AS validato,
    NULL::boolean AS pubblicato,
    NULL::numeric AS id_listino_precedente;


--
-- Name: VIEW listini_precedenti; Type: COMMENT; Schema: prezzi; Owner: -
--

COMMENT ON VIEW prezzi.listini_precedenti IS 'determina per ogni listino il listino precedente dello stesso tipo';


--
-- Name: prodotti; Type: TABLE; Schema: prezzi; Owner: -
--

CREATE TABLE prezzi.prodotti (
    id_prodotto numeric(22,0) NOT NULL,
    nome text NOT NULL,
    descrizione text,
    note text,
    unita_misura text,
    ordine numeric(22,0),
    id_categoria numeric(22,0) NOT NULL,
    id_prodotto_padre numeric(22,0),
    id_prodotto_calcprezzo numeric(22,0),
    visualizzabile boolean DEFAULT false,
    validita_init date,
    validita_fine date
);


--
-- Name: quotazioni; Type: TABLE; Schema: prezzi; Owner: -
--

CREATE TABLE prezzi.quotazioni (
    id_listino numeric(22,0) NOT NULL,
    id_informatore numeric(22,0) NOT NULL,
    id_prodotto numeric(22,0) NOT NULL,
    quot_min_bt_ numeric(22,4),
    quot_max_bt_ numeric(22,4),
    media_bt_ numeric(22,4),
    variazione_perc_bt_ numeric(22,4),
    validata boolean DEFAULT false,
    commento text,
    data_inserimento timestamp without time zone,
    data_validazione timestamp without time zone,
    id_utente_ins numeric(22,0),
    data_modifica timestamp without time zone
);


--
-- Name: rel_informatori_categorie; Type: TABLE; Schema: prezzi; Owner: -
--

CREATE TABLE prezzi.rel_informatori_categorie (
    id_informatore numeric(22,0) NOT NULL,
    id_categoria numeric(22,0) NOT NULL
);


--
-- Name: tendenze; Type: TABLE; Schema: prezzi; Owner: -
--

CREATE TABLE prezzi.tendenze (
    id_listino numeric(22,0) NOT NULL,
    id_categoria numeric(22,0) NOT NULL,
    commento text
);


--
-- Name: tipi_listino; Type: TABLE; Schema: prezzi; Owner: -
--

CREATE TABLE prezzi.tipi_listino (
    id_tipo_listino numeric(22,0) NOT NULL,
    nome text NOT NULL,
    descrizione text,
    config_prezzo_unico boolean,
    locale text
);


--
-- Name: z_quotazioni; Type: MATERIALIZED VIEW; Schema: prezzi; Owner: -
--

CREATE MATERIALIZED VIEW prezzi.z_quotazioni AS
 SELECT qz.id_listino,
    qz.id_prodotto,
    qz.quot_min_bt_,
    qz.quot_max_bt_,
    qz.media_bt_,
    (
        CASE
            WHEN ((qp.media_bt_ IS NOT NULL) AND (qp.media_bt_ <> (0)::numeric) AND (qp.media_bt_ IS NOT NULL)) THEN ((((qz.media_bt_ - qp.media_bt_) / qp.media_bt_) * (100)::numeric(10,3)))::numeric(10,3)
            ELSE NULL::numeric
        END)::numeric(10,3) AS variazione_perc_bt_
   FROM ((( SELECT q.id_listino,
            q.id_prodotto,
            (min(q.quot_min_bt_))::numeric(10,3) AS quot_min_bt_,
            (max(q.quot_max_bt_))::numeric(10,3) AS quot_max_bt_,
            (avg(q.media_bt_))::numeric(10,3) AS media_bt_
           FROM prezzi.quotazioni q
          WHERE q.validata
          GROUP BY q.id_listino, q.id_prodotto) qz
     JOIN prezzi.listini_precedenti l ON ((qz.id_listino = l.id_listino)))
     LEFT JOIN ( SELECT q.id_listino,
            q.id_prodotto,
            (min(q.quot_min_bt_))::numeric(10,3) AS quot_min_bt_,
            (max(q.quot_max_bt_))::numeric(10,3) AS quot_max_bt_,
            (avg(q.media_bt_))::numeric(10,3) AS media_bt_
           FROM prezzi.quotazioni q
          WHERE q.validata
          GROUP BY q.id_listino, q.id_prodotto) qp ON (((l.id_listino_precedente = qp.id_listino) AND (qz.id_prodotto = qp.id_prodotto))))
  WITH NO DATA;


--
-- Name: z_quotazioni_mensili; Type: MATERIALIZED VIEW; Schema: prezzi; Owner: -
--

CREATE MATERIALIZED VIEW prezzi.z_quotazioni_mensili AS
 SELECT qz.id_tipo_listino,
    (qz.mese)::integer AS mese,
    (qz.anno)::integer AS anno,
    qz.id_prodotto,
    qz.quot_min_bt_,
    qz.quot_max_bt_,
    qz.media_bt_,
    (
        CASE
            WHEN ((qp.media_bt_ IS NOT NULL) AND (qp.media_bt_ <> (0)::numeric) AND (qp.media_bt_ IS NOT NULL)) THEN ((((qz.media_bt_ - qp.media_bt_) / qp.media_bt_) * (100)::numeric(10,3)))::numeric(10,3)
            ELSE NULL::numeric
        END)::numeric(10,3) AS variazione_perc_bt_
   FROM (( SELECT l.id_tipo_listino,
            date_part('month'::text, l.data_pubbl) AS mese,
            date_part('year'::text, l.data_pubbl) AS anno,
            q.id_prodotto,
            (min(q.quot_min_bt_))::numeric(10,3) AS quot_min_bt_,
            (max(q.quot_max_bt_))::numeric(10,3) AS quot_max_bt_,
            (avg(q.media_bt_))::numeric(10,3) AS media_bt_,
            NULL::text AS variazione_perc_bt_as
           FROM (prezzi.z_quotazioni q
             JOIN prezzi.listini l ON ((q.id_listino = l.id_listino)))
          WHERE (l.id_tipo_listino = (1)::numeric)
          GROUP BY l.id_tipo_listino, (date_part('year'::text, l.data_pubbl)), (date_part('month'::text, l.data_pubbl)), q.id_prodotto) qz
     LEFT JOIN ( SELECT l.id_tipo_listino,
            date_part('month'::text, l.data_pubbl) AS mese,
            date_part('year'::text, l.data_pubbl) AS anno,
            q.id_prodotto,
            (min(q.quot_min_bt_))::numeric(10,3) AS quot_min_bt_,
            (max(q.quot_max_bt_))::numeric(10,3) AS quot_max_bt_,
            (avg(q.media_bt_))::numeric(10,3) AS media_bt_,
            NULL::text AS variazione_perc_bt_as
           FROM (prezzi.z_quotazioni q
             JOIN prezzi.listini l ON ((q.id_listino = l.id_listino)))
          WHERE (l.id_tipo_listino = (1)::numeric)
          GROUP BY l.id_tipo_listino, (date_part('year'::text, l.data_pubbl)), (date_part('month'::text, l.data_pubbl)), q.id_prodotto) qp ON (((qz.id_prodotto = qp.id_prodotto) AND (date_part('month'::text, (to_date((((qz.anno || '-'::text) || qz.mese) || '-01'::text), 'yyyy-MM-dd'::text) - '1 day'::interval)) = qp.mese) AND (date_part('year'::text, (to_date((((qz.anno || '-'::text) || qz.mese) || '-01'::text), 'yyyy-MM-dd'::text) - '1 day'::interval)) = qp.anno))))
  WITH NO DATA;


--
-- Name: z_quotazioni_annuali; Type: MATERIALIZED VIEW; Schema: prezzi; Owner: -
--

CREATE MATERIALIZED VIEW prezzi.z_quotazioni_annuali AS
 SELECT z_quotazioni_mensili.id_tipo_listino,
    z_quotazioni_mensili.anno,
    z_quotazioni_mensili.id_prodotto,
    (min(z_quotazioni_mensili.quot_min_bt_))::numeric(10,3) AS quot_min_bt_,
    (max(z_quotazioni_mensili.quot_max_bt_))::numeric(10,3) AS quot_max_bt_,
    (avg(z_quotazioni_mensili.media_bt_))::numeric(10,3) AS media_bt_,
    NULL::numeric(10,3) AS variazione_perc_bt_
   FROM prezzi.z_quotazioni_mensili
  WHERE (z_quotazioni_mensili.id_tipo_listino = (1)::numeric)
  GROUP BY z_quotazioni_mensili.id_tipo_listino, z_quotazioni_mensili.anno, z_quotazioni_mensili.id_prodotto
  WITH NO DATA;


--
-- Name: annotazioni annotazioni_pkey; Type: CONSTRAINT; Schema: appuntamenti; Owner: -
--

ALTER TABLE ONLY appuntamenti.annotazioni
    ADD CONSTRAINT annotazioni_pkey PRIMARY KEY (id_annotazione);


--
-- Name: appuntamenti appuntamenti_pkey; Type: CONSTRAINT; Schema: appuntamenti; Owner: -
--

ALTER TABLE ONLY appuntamenti.appuntamenti
    ADD CONSTRAINT appuntamenti_pkey PRIMARY KEY (id_appuntamento);


--
-- Name: fasce_apertura fasce_apertura_pkey; Type: CONSTRAINT; Schema: appuntamenti; Owner: -
--

ALTER TABLE ONLY appuntamenti.fasce_apertura
    ADD CONSTRAINT fasce_apertura_pkey PRIMARY KEY (id_fascia_apertura);


--
-- Name: intermediari intermediari_pkey; Type: CONSTRAINT; Schema: appuntamenti; Owner: -
--

ALTER TABLE ONLY appuntamenti.intermediari
    ADD CONSTRAINT intermediari_pkey PRIMARY KEY (id_intermediario);


--
-- Name: pratiche pratica_pkey; Type: CONSTRAINT; Schema: appuntamenti; Owner: -
--

ALTER TABLE ONLY appuntamenti.pratiche
    ADD CONSTRAINT pratica_pkey PRIMARY KEY (id_pratica);


--
-- Name: rel_sportelli_servizi rel_sportelli_servizi_pkey; Type: CONSTRAINT; Schema: appuntamenti; Owner: -
--

ALTER TABLE ONLY appuntamenti.rel_sportelli_servizi
    ADD CONSTRAINT rel_sportelli_servizi_pkey PRIMARY KEY (cod_sportello, id_servizio);


--
-- Name: servizi servizi_pkey; Type: CONSTRAINT; Schema: appuntamenti; Owner: -
--

ALTER TABLE ONLY appuntamenti.servizi
    ADD CONSTRAINT servizi_pkey PRIMARY KEY (id_servizio);


--
-- Name: sportelli sportelli_pkey; Type: CONSTRAINT; Schema: appuntamenti; Owner: -
--

ALTER TABLE ONLY appuntamenti.sportelli
    ADD CONSTRAINT sportelli_pkey PRIMARY KEY (cod_sportello);


--
-- Name: argomenti argomenti_pkey; Type: CONSTRAINT; Schema: congiuntura; Owner: -
--

ALTER TABLE ONLY congiuntura.argomenti
    ADD CONSTRAINT argomenti_pkey PRIMARY KEY (id_argomento);


--
-- Name: ateco07 ateco07_pkey; Type: CONSTRAINT; Schema: congiuntura; Owner: -
--

ALTER TABLE ONLY congiuntura.ateco07
    ADD CONSTRAINT ateco07_pkey PRIMARY KEY (codice_esteso);


--
-- Name: aziende_cong aziende_cong_pkey; Type: CONSTRAINT; Schema: congiuntura; Owner: -
--

ALTER TABLE ONLY congiuntura.aziende_cong
    ADD CONSTRAINT aziende_cong_pkey PRIMARY KEY (id_azienda);


--
-- Name: cl_addetti_cong cl_addetti_cong_pkey; Type: CONSTRAINT; Schema: congiuntura; Owner: -
--

ALTER TABLE ONLY congiuntura.cl_addetti_cong
    ADD CONSTRAINT cl_addetti_cong_pkey PRIMARY KEY (id_cl_addetti);


--
-- Name: contatti contatti_pkey; Type: CONSTRAINT; Schema: congiuntura; Owner: -
--

ALTER TABLE ONLY congiuntura.contatti
    ADD CONSTRAINT contatti_pkey PRIMARY KEY (id_utente);


--
-- Name: dim_universo dim_universo_pkey; Type: CONSTRAINT; Schema: congiuntura; Owner: -
--

ALTER TABLE ONLY congiuntura.dim_universo
    ADD CONSTRAINT dim_universo_pkey PRIMARY KEY (id_comprensorio, id_cl_addetti, cod_se, data_init);


--
-- Name: fatturato fatturato_pkey; Type: CONSTRAINT; Schema: congiuntura; Owner: -
--

ALTER TABLE ONLY congiuntura.fatturato
    ADD CONSTRAINT fatturato_pkey PRIMARY KEY (id_azienda, data);


--
-- Name: g_lavorative g_lavorative_pkey; Type: CONSTRAINT; Schema: congiuntura; Owner: -
--

ALTER TABLE ONLY congiuntura.g_lavorative
    ADD CONSTRAINT g_lavorative_pkey PRIMARY KEY (data);


--
-- Name: h_dim_universo h_dim_universo_pkey; Type: CONSTRAINT; Schema: congiuntura; Owner: -
--

ALTER TABLE ONLY congiuntura.h_dim_universo
    ADD CONSTRAINT h_dim_universo_pkey PRIMARY KEY (id_comprensorio, id_cl_addetti, cod_se, data_init);


--
-- Name: indicatori_ic indicatori_ic_pkey; Type: CONSTRAINT; Schema: congiuntura; Owner: -
--

ALTER TABLE ONLY congiuntura.indicatori_ic
    ADD CONSTRAINT indicatori_ic_pkey PRIMARY KEY (ind_composto);


--
-- Name: indicatori_ins indicatori_ins_pkey; Type: CONSTRAINT; Schema: congiuntura; Owner: -
--

ALTER TABLE ONLY congiuntura.indicatori_ins
    ADD CONSTRAINT indicatori_ins_pkey PRIMARY KEY (id_indicatore);


--
-- Name: questionari questionari_pkey; Type: CONSTRAINT; Schema: congiuntura; Owner: -
--

ALTER TABLE ONLY congiuntura.questionari
    ADD CONSTRAINT questionari_pkey PRIMARY KEY (id_azienda, data);


--
-- Name: rel_ateco07_settori_cong rel_ateco07_settori_cong_pkey; Type: CONSTRAINT; Schema: congiuntura; Owner: -
--

ALTER TABLE ONLY congiuntura.rel_ateco07_settori_cong
    ADD CONSTRAINT rel_ateco07_settori_cong_pkey PRIMARY KEY (cod_se, codice_esteso);


--
-- Name: rel_indicatori_ins_u_misura rel_indicatori_ins_u_misura_pkey; Type: CONSTRAINT; Schema: congiuntura; Owner: -
--

ALTER TABLE ONLY congiuntura.rel_indicatori_ins_u_misura
    ADD CONSTRAINT rel_indicatori_ins_u_misura_pkey PRIMARY KEY (id_indicatore, id_u_misura);


--
-- Name: risposte risposte_pkey; Type: CONSTRAINT; Schema: congiuntura; Owner: -
--

ALTER TABLE ONLY congiuntura.risposte
    ADD CONSTRAINT risposte_pkey PRIMARY KEY (id_azienda, data, id_indicatore);


--
-- Name: settori_cong settori_cong_pkey; Type: CONSTRAINT; Schema: congiuntura; Owner: -
--

ALTER TABLE ONLY congiuntura.settori_cong
    ADD CONSTRAINT settori_cong_pkey PRIMARY KEY (cod_se);


--
-- Name: settori_di_analisi settori_di_analisi_pkey; Type: CONSTRAINT; Schema: congiuntura; Owner: -
--

ALTER TABLE ONLY congiuntura.settori_di_analisi
    ADD CONSTRAINT settori_di_analisi_pkey PRIMARY KEY (id_azienda, codice_esteso, data_init);


--
-- Name: tipi_dato tipi_dato_pkey; Type: CONSTRAINT; Schema: congiuntura; Owner: -
--

ALTER TABLE ONLY congiuntura.tipi_dato
    ADD CONSTRAINT tipi_dato_pkey PRIMARY KEY (sigla);


--
-- Name: tipi_num tipi_num_pkey; Type: CONSTRAINT; Schema: congiuntura; Owner: -
--

ALTER TABLE ONLY congiuntura.tipi_num
    ADD CONSTRAINT tipi_num_pkey PRIMARY KEY (id_tipo_num);


--
-- Name: u_misura u_misura_pkey; Type: CONSTRAINT; Schema: congiuntura; Owner: -
--

ALTER TABLE ONLY congiuntura.u_misura
    ADD CONSTRAINT u_misura_pkey PRIMARY KEY (id_u_misura);


--
-- Name: z_add_trim_clad_sett_compr z_add_trim_clad_sett_compr_pkey; Type: CONSTRAINT; Schema: congiuntura; Owner: -
--

ALTER TABLE ONLY congiuntura.z_add_trim_clad_sett_compr
    ADD CONSTRAINT z_add_trim_clad_sett_compr_pkey PRIMARY KEY (trimestre, anno, id_comprensorio, id_cl_addetti, cod_se);


--
-- Name: z_aziende_trim z_aziende_trim_pkey; Type: CONSTRAINT; Schema: congiuntura; Owner: -
--

ALTER TABLE ONLY congiuntura.z_aziende_trim
    ADD CONSTRAINT z_aziende_trim_pkey PRIMARY KEY (id_azienda, trimestre, anno);


--
-- Name: z_dim_universo_trim_ic z_dim_universo_trim_ic_pkey; Type: CONSTRAINT; Schema: congiuntura; Owner: -
--

ALTER TABLE ONLY congiuntura.z_dim_universo_trim_ic
    ADD CONSTRAINT z_dim_universo_trim_ic_pkey PRIMARY KEY (ind_composto, trimestre, anno, id_comprensorio, id_cl_addetti, cod_se);


--
-- Name: z_dim_universo_trim z_dim_universo_trim_pkey; Type: CONSTRAINT; Schema: congiuntura; Owner: -
--

ALTER TABLE ONLY congiuntura.z_dim_universo_trim
    ADD CONSTRAINT z_dim_universo_trim_pkey PRIMARY KEY (id_indicatore, trimestre, anno, id_comprensorio, id_cl_addetti, cod_se);


--
-- Name: z_ind_trim_clad z_ind_trim_clad_pkey; Type: CONSTRAINT; Schema: congiuntura; Owner: -
--

ALTER TABLE ONLY congiuntura.z_ind_trim_clad
    ADD CONSTRAINT z_ind_trim_clad_pkey PRIMARY KEY (trimestre, anno, id_cl_addetti);


--
-- Name: z_ind_trim_clad_sett_compr z_ind_trim_clad_sett_compr_pkey; Type: CONSTRAINT; Schema: congiuntura; Owner: -
--

ALTER TABLE ONLY congiuntura.z_ind_trim_clad_sett_compr
    ADD CONSTRAINT z_ind_trim_clad_sett_compr_pkey PRIMARY KEY (trimestre, anno, id_comprensorio, id_cl_addetti, cod_se);


--
-- Name: z_ind_trim_clad_sett z_ind_trim_clad_sett_pkey; Type: CONSTRAINT; Schema: congiuntura; Owner: -
--

ALTER TABLE ONLY congiuntura.z_ind_trim_clad_sett
    ADD CONSTRAINT z_ind_trim_clad_sett_pkey PRIMARY KEY (trimestre, anno, id_cl_addetti, cod_se);


--
-- Name: z_ind_trim_compr z_ind_trim_compr_pkey; Type: CONSTRAINT; Schema: congiuntura; Owner: -
--

ALTER TABLE ONLY congiuntura.z_ind_trim_compr
    ADD CONSTRAINT z_ind_trim_compr_pkey PRIMARY KEY (trimestre, anno, id_comprensorio);


--
-- Name: z_ind_trim z_ind_trim_pkey; Type: CONSTRAINT; Schema: congiuntura; Owner: -
--

ALTER TABLE ONLY congiuntura.z_ind_trim
    ADD CONSTRAINT z_ind_trim_pkey PRIMARY KEY (trimestre, anno);


--
-- Name: z_ind_trim_sett_compr z_ind_trim_sett_compr_pkey; Type: CONSTRAINT; Schema: congiuntura; Owner: -
--

ALTER TABLE ONLY congiuntura.z_ind_trim_sett_compr
    ADD CONSTRAINT z_ind_trim_sett_compr_pkey PRIMARY KEY (trimestre, anno, id_comprensorio, cod_se);


--
-- Name: z_ind_trim_sett z_ind_trim_sett_pkey; Type: CONSTRAINT; Schema: congiuntura; Owner: -
--

ALTER TABLE ONLY congiuntura.z_ind_trim_sett
    ADD CONSTRAINT z_ind_trim_sett_pkey PRIMARY KEY (trimestre, anno, cod_se);


--
-- Name: z_ore_trim_clad_sett_compr z_ore_trim_clad_sett_compr_pkey; Type: CONSTRAINT; Schema: congiuntura; Owner: -
--

ALTER TABLE ONLY congiuntura.z_ore_trim_clad_sett_compr
    ADD CONSTRAINT z_ore_trim_clad_sett_compr_pkey PRIMARY KEY (trimestre, anno, id_comprensorio, id_cl_addetti, cod_se);


--
-- Name: z_quest_azienda_trim z_quest_azienda_trim_pkey; Type: CONSTRAINT; Schema: congiuntura; Owner: -
--

ALTER TABLE ONLY congiuntura.z_quest_azienda_trim
    ADD CONSTRAINT z_quest_azienda_trim_pkey PRIMARY KEY (id_azienda, trimestre, anno);


--
-- Name: z_sel_universo_temp_ic z_sel_universo_temp_ic_pkey; Type: CONSTRAINT; Schema: congiuntura; Owner: -
--

ALTER TABLE ONLY congiuntura.z_sel_universo_temp_ic
    ADD CONSTRAINT z_sel_universo_temp_ic_pkey PRIMARY KEY (ind_composto, trimestre, anno, id_comprensorio, id_cl_addetti, cod_se);


--
-- Name: z_sel_universo_temp z_sel_universo_temp_pkey; Type: CONSTRAINT; Schema: congiuntura; Owner: -
--

ALTER TABLE ONLY congiuntura.z_sel_universo_temp
    ADD CONSTRAINT z_sel_universo_temp_pkey PRIMARY KEY (id_indicatore, trimestre, anno, id_comprensorio, id_cl_addetti, cod_se);


--
-- Name: zh_add_trim_clad_sett_compr zh_add_trim_clad_sett_compr_pkey; Type: CONSTRAINT; Schema: congiuntura; Owner: -
--

ALTER TABLE ONLY congiuntura.zh_add_trim_clad_sett_compr
    ADD CONSTRAINT zh_add_trim_clad_sett_compr_pkey PRIMARY KEY (trimestre, anno, id_comprensorio, id_cl_addetti, cod_se);


--
-- Name: zh_aziende_trim zh_aziende_trim_pkey; Type: CONSTRAINT; Schema: congiuntura; Owner: -
--

ALTER TABLE ONLY congiuntura.zh_aziende_trim
    ADD CONSTRAINT zh_aziende_trim_pkey PRIMARY KEY (id_azienda, trimestre, anno);


--
-- Name: zh_dim_universo_trim_ic zh_dim_universo_trim_ic_pkey; Type: CONSTRAINT; Schema: congiuntura; Owner: -
--

ALTER TABLE ONLY congiuntura.zh_dim_universo_trim_ic
    ADD CONSTRAINT zh_dim_universo_trim_ic_pkey PRIMARY KEY (ind_composto, trimestre, anno, id_comprensorio, id_cl_addetti, cod_se);


--
-- Name: zh_dim_universo_trim zh_dim_universo_trim_pkey; Type: CONSTRAINT; Schema: congiuntura; Owner: -
--

ALTER TABLE ONLY congiuntura.zh_dim_universo_trim
    ADD CONSTRAINT zh_dim_universo_trim_pkey PRIMARY KEY (id_indicatore, trimestre, anno, id_comprensorio, id_cl_addetti, cod_se);


--
-- Name: zh_ind_trim_clad zh_ind_trim_clad_pkey; Type: CONSTRAINT; Schema: congiuntura; Owner: -
--

ALTER TABLE ONLY congiuntura.zh_ind_trim_clad
    ADD CONSTRAINT zh_ind_trim_clad_pkey PRIMARY KEY (trimestre, anno, id_cl_addetti);


--
-- Name: zh_ind_trim_clad_sett_compr zh_ind_trim_clad_sett_compr_pkey; Type: CONSTRAINT; Schema: congiuntura; Owner: -
--

ALTER TABLE ONLY congiuntura.zh_ind_trim_clad_sett_compr
    ADD CONSTRAINT zh_ind_trim_clad_sett_compr_pkey PRIMARY KEY (trimestre, anno, id_comprensorio, id_cl_addetti, cod_se);


--
-- Name: zh_ind_trim_clad_sett zh_ind_trim_clad_sett_pkey; Type: CONSTRAINT; Schema: congiuntura; Owner: -
--

ALTER TABLE ONLY congiuntura.zh_ind_trim_clad_sett
    ADD CONSTRAINT zh_ind_trim_clad_sett_pkey PRIMARY KEY (trimestre, anno, id_cl_addetti, cod_se);


--
-- Name: zh_ind_trim_compr zh_ind_trim_compr_pkey; Type: CONSTRAINT; Schema: congiuntura; Owner: -
--

ALTER TABLE ONLY congiuntura.zh_ind_trim_compr
    ADD CONSTRAINT zh_ind_trim_compr_pkey PRIMARY KEY (trimestre, anno, id_comprensorio);


--
-- Name: zh_ind_trim zh_ind_trim_pkey; Type: CONSTRAINT; Schema: congiuntura; Owner: -
--

ALTER TABLE ONLY congiuntura.zh_ind_trim
    ADD CONSTRAINT zh_ind_trim_pkey PRIMARY KEY (trimestre, anno);


--
-- Name: zh_ind_trim_sett_compr zh_ind_trim_sett_compr_pkey; Type: CONSTRAINT; Schema: congiuntura; Owner: -
--

ALTER TABLE ONLY congiuntura.zh_ind_trim_sett_compr
    ADD CONSTRAINT zh_ind_trim_sett_compr_pkey PRIMARY KEY (trimestre, anno, id_comprensorio, cod_se);


--
-- Name: zh_ind_trim_sett zh_ind_trim_sett_pkey; Type: CONSTRAINT; Schema: congiuntura; Owner: -
--

ALTER TABLE ONLY congiuntura.zh_ind_trim_sett
    ADD CONSTRAINT zh_ind_trim_sett_pkey PRIMARY KEY (trimestre, anno, cod_se);


--
-- Name: zh_ore_trim_clad_sett_compr zh_ore_trim_clad_sett_compr_pkey; Type: CONSTRAINT; Schema: congiuntura; Owner: -
--

ALTER TABLE ONLY congiuntura.zh_ore_trim_clad_sett_compr
    ADD CONSTRAINT zh_ore_trim_clad_sett_compr_pkey PRIMARY KEY (trimestre, anno, id_comprensorio, id_cl_addetti, cod_se);


--
-- Name: zh_quest_azienda_trim zh_quest_azienda_trim_pkey; Type: CONSTRAINT; Schema: congiuntura; Owner: -
--

ALTER TABLE ONLY congiuntura.zh_quest_azienda_trim
    ADD CONSTRAINT zh_quest_azienda_trim_pkey PRIMARY KEY (id_azienda, trimestre, anno);


--
-- Name: dim_universo dim_universo_pkey; Type: CONSTRAINT; Schema: congiuntura_rimini; Owner: -
--

ALTER TABLE ONLY congiuntura_rimini.dim_universo
    ADD CONSTRAINT dim_universo_pkey PRIMARY KEY (id_comprensorio, id_cl_addetti, cod_se, data_init);


--
-- Name: h_dim_universo h_dim_universo_pkey; Type: CONSTRAINT; Schema: congiuntura_rimini; Owner: -
--

ALTER TABLE ONLY congiuntura_rimini.h_dim_universo
    ADD CONSTRAINT h_dim_universo_pkey PRIMARY KEY (id_comprensorio, id_cl_addetti, cod_se, data_init);


--
-- Name: rel_ateco07_settori_cong rel_ateco07_settori_cong_pkey; Type: CONSTRAINT; Schema: congiuntura_rimini; Owner: -
--

ALTER TABLE ONLY congiuntura_rimini.rel_ateco07_settori_cong
    ADD CONSTRAINT rel_ateco07_settori_cong_pkey PRIMARY KEY (cod_se, codice_esteso);


--
-- Name: settori_cong settori_cong_pkey; Type: CONSTRAINT; Schema: congiuntura_rimini; Owner: -
--

ALTER TABLE ONLY congiuntura_rimini.settori_cong
    ADD CONSTRAINT settori_cong_pkey PRIMARY KEY (cod_se);


--
-- Name: z_add_trim_clad_sett_compr z_add_trim_clad_sett_compr_pkey; Type: CONSTRAINT; Schema: congiuntura_rimini; Owner: -
--

ALTER TABLE ONLY congiuntura_rimini.z_add_trim_clad_sett_compr
    ADD CONSTRAINT z_add_trim_clad_sett_compr_pkey PRIMARY KEY (trimestre, anno, id_comprensorio, id_cl_addetti, cod_se);


--
-- Name: z_aziende_trim z_aziende_trim_pkey; Type: CONSTRAINT; Schema: congiuntura_rimini; Owner: -
--

ALTER TABLE ONLY congiuntura_rimini.z_aziende_trim
    ADD CONSTRAINT z_aziende_trim_pkey PRIMARY KEY (id_azienda, trimestre, anno);


--
-- Name: z_dim_universo_trim_ic z_dim_universo_trim_ic_pkey; Type: CONSTRAINT; Schema: congiuntura_rimini; Owner: -
--

ALTER TABLE ONLY congiuntura_rimini.z_dim_universo_trim_ic
    ADD CONSTRAINT z_dim_universo_trim_ic_pkey PRIMARY KEY (ind_composto, trimestre, anno, id_comprensorio, id_cl_addetti, cod_se);


--
-- Name: z_dim_universo_trim z_dim_universo_trim_pkey; Type: CONSTRAINT; Schema: congiuntura_rimini; Owner: -
--

ALTER TABLE ONLY congiuntura_rimini.z_dim_universo_trim
    ADD CONSTRAINT z_dim_universo_trim_pkey PRIMARY KEY (id_indicatore, trimestre, anno, id_comprensorio, id_cl_addetti, cod_se);


--
-- Name: z_ind_trim_clad z_ind_trim_clad_pkey; Type: CONSTRAINT; Schema: congiuntura_rimini; Owner: -
--

ALTER TABLE ONLY congiuntura_rimini.z_ind_trim_clad
    ADD CONSTRAINT z_ind_trim_clad_pkey PRIMARY KEY (trimestre, anno, id_cl_addetti);


--
-- Name: z_ind_trim_clad_sett_compr z_ind_trim_clad_sett_compr_pkey; Type: CONSTRAINT; Schema: congiuntura_rimini; Owner: -
--

ALTER TABLE ONLY congiuntura_rimini.z_ind_trim_clad_sett_compr
    ADD CONSTRAINT z_ind_trim_clad_sett_compr_pkey PRIMARY KEY (trimestre, anno, id_comprensorio, id_cl_addetti, cod_se);


--
-- Name: z_ind_trim_clad_sett z_ind_trim_clad_sett_pkey; Type: CONSTRAINT; Schema: congiuntura_rimini; Owner: -
--

ALTER TABLE ONLY congiuntura_rimini.z_ind_trim_clad_sett
    ADD CONSTRAINT z_ind_trim_clad_sett_pkey PRIMARY KEY (trimestre, anno, id_cl_addetti, cod_se);


--
-- Name: z_ind_trim_compr z_ind_trim_compr_pkey; Type: CONSTRAINT; Schema: congiuntura_rimini; Owner: -
--

ALTER TABLE ONLY congiuntura_rimini.z_ind_trim_compr
    ADD CONSTRAINT z_ind_trim_compr_pkey PRIMARY KEY (trimestre, anno, id_comprensorio);


--
-- Name: z_ind_trim z_ind_trim_pkey; Type: CONSTRAINT; Schema: congiuntura_rimini; Owner: -
--

ALTER TABLE ONLY congiuntura_rimini.z_ind_trim
    ADD CONSTRAINT z_ind_trim_pkey PRIMARY KEY (trimestre, anno);


--
-- Name: z_ind_trim_sett_compr z_ind_trim_sett_compr_pkey; Type: CONSTRAINT; Schema: congiuntura_rimini; Owner: -
--

ALTER TABLE ONLY congiuntura_rimini.z_ind_trim_sett_compr
    ADD CONSTRAINT z_ind_trim_sett_compr_pkey PRIMARY KEY (trimestre, anno, id_comprensorio, cod_se);


--
-- Name: z_ind_trim_sett z_ind_trim_sett_pkey; Type: CONSTRAINT; Schema: congiuntura_rimini; Owner: -
--

ALTER TABLE ONLY congiuntura_rimini.z_ind_trim_sett
    ADD CONSTRAINT z_ind_trim_sett_pkey PRIMARY KEY (trimestre, anno, cod_se);


--
-- Name: z_ore_trim_clad_sett_compr z_ore_trim_clad_sett_compr_pkey; Type: CONSTRAINT; Schema: congiuntura_rimini; Owner: -
--

ALTER TABLE ONLY congiuntura_rimini.z_ore_trim_clad_sett_compr
    ADD CONSTRAINT z_ore_trim_clad_sett_compr_pkey PRIMARY KEY (trimestre, anno, id_comprensorio, id_cl_addetti, cod_se);


--
-- Name: z_quest_azienda_trim z_quest_azienda_trim_pkey; Type: CONSTRAINT; Schema: congiuntura_rimini; Owner: -
--

ALTER TABLE ONLY congiuntura_rimini.z_quest_azienda_trim
    ADD CONSTRAINT z_quest_azienda_trim_pkey PRIMARY KEY (id_azienda, trimestre, anno);


--
-- Name: z_sel_universo_temp_ic z_sel_universo_temp_ic_pkey; Type: CONSTRAINT; Schema: congiuntura_rimini; Owner: -
--

ALTER TABLE ONLY congiuntura_rimini.z_sel_universo_temp_ic
    ADD CONSTRAINT z_sel_universo_temp_ic_pkey PRIMARY KEY (ind_composto, trimestre, anno, id_comprensorio, id_cl_addetti, cod_se);


--
-- Name: z_sel_universo_temp z_sel_universo_temp_pkey; Type: CONSTRAINT; Schema: congiuntura_rimini; Owner: -
--

ALTER TABLE ONLY congiuntura_rimini.z_sel_universo_temp
    ADD CONSTRAINT z_sel_universo_temp_pkey PRIMARY KEY (id_indicatore, trimestre, anno, id_comprensorio, id_cl_addetti, cod_se);


--
-- Name: zh_add_trim_clad_sett_compr zh_add_trim_clad_sett_compr_pkey; Type: CONSTRAINT; Schema: congiuntura_rimini; Owner: -
--

ALTER TABLE ONLY congiuntura_rimini.zh_add_trim_clad_sett_compr
    ADD CONSTRAINT zh_add_trim_clad_sett_compr_pkey PRIMARY KEY (trimestre, anno, id_comprensorio, id_cl_addetti, cod_se);


--
-- Name: zh_aziende_trim zh_aziende_trim_pkey; Type: CONSTRAINT; Schema: congiuntura_rimini; Owner: -
--

ALTER TABLE ONLY congiuntura_rimini.zh_aziende_trim
    ADD CONSTRAINT zh_aziende_trim_pkey PRIMARY KEY (id_azienda, trimestre, anno);


--
-- Name: zh_dim_universo_trim_ic zh_dim_universo_trim_ic_pkey; Type: CONSTRAINT; Schema: congiuntura_rimini; Owner: -
--

ALTER TABLE ONLY congiuntura_rimini.zh_dim_universo_trim_ic
    ADD CONSTRAINT zh_dim_universo_trim_ic_pkey PRIMARY KEY (ind_composto, trimestre, anno, id_comprensorio, id_cl_addetti, cod_se);


--
-- Name: zh_dim_universo_trim zh_dim_universo_trim_pkey; Type: CONSTRAINT; Schema: congiuntura_rimini; Owner: -
--

ALTER TABLE ONLY congiuntura_rimini.zh_dim_universo_trim
    ADD CONSTRAINT zh_dim_universo_trim_pkey PRIMARY KEY (id_indicatore, trimestre, anno, id_comprensorio, id_cl_addetti, cod_se);


--
-- Name: zh_ind_trim_clad zh_ind_trim_clad_pkey; Type: CONSTRAINT; Schema: congiuntura_rimini; Owner: -
--

ALTER TABLE ONLY congiuntura_rimini.zh_ind_trim_clad
    ADD CONSTRAINT zh_ind_trim_clad_pkey PRIMARY KEY (trimestre, anno, id_cl_addetti);


--
-- Name: zh_ind_trim_clad_sett_compr zh_ind_trim_clad_sett_compr_pkey; Type: CONSTRAINT; Schema: congiuntura_rimini; Owner: -
--

ALTER TABLE ONLY congiuntura_rimini.zh_ind_trim_clad_sett_compr
    ADD CONSTRAINT zh_ind_trim_clad_sett_compr_pkey PRIMARY KEY (trimestre, anno, id_comprensorio, id_cl_addetti, cod_se);


--
-- Name: zh_ind_trim_clad_sett zh_ind_trim_clad_sett_pkey; Type: CONSTRAINT; Schema: congiuntura_rimini; Owner: -
--

ALTER TABLE ONLY congiuntura_rimini.zh_ind_trim_clad_sett
    ADD CONSTRAINT zh_ind_trim_clad_sett_pkey PRIMARY KEY (trimestre, anno, id_cl_addetti, cod_se);


--
-- Name: zh_ind_trim_compr zh_ind_trim_compr_pkey; Type: CONSTRAINT; Schema: congiuntura_rimini; Owner: -
--

ALTER TABLE ONLY congiuntura_rimini.zh_ind_trim_compr
    ADD CONSTRAINT zh_ind_trim_compr_pkey PRIMARY KEY (trimestre, anno, id_comprensorio);


--
-- Name: zh_ind_trim zh_ind_trim_pkey; Type: CONSTRAINT; Schema: congiuntura_rimini; Owner: -
--

ALTER TABLE ONLY congiuntura_rimini.zh_ind_trim
    ADD CONSTRAINT zh_ind_trim_pkey PRIMARY KEY (trimestre, anno);


--
-- Name: zh_ind_trim_sett_compr zh_ind_trim_sett_compr_pkey; Type: CONSTRAINT; Schema: congiuntura_rimini; Owner: -
--

ALTER TABLE ONLY congiuntura_rimini.zh_ind_trim_sett_compr
    ADD CONSTRAINT zh_ind_trim_sett_compr_pkey PRIMARY KEY (trimestre, anno, id_comprensorio, cod_se);


--
-- Name: zh_ind_trim_sett zh_ind_trim_sett_pkey; Type: CONSTRAINT; Schema: congiuntura_rimini; Owner: -
--

ALTER TABLE ONLY congiuntura_rimini.zh_ind_trim_sett
    ADD CONSTRAINT zh_ind_trim_sett_pkey PRIMARY KEY (trimestre, anno, cod_se);


--
-- Name: zh_ore_trim_clad_sett_compr zh_ore_trim_clad_sett_compr_pkey; Type: CONSTRAINT; Schema: congiuntura_rimini; Owner: -
--

ALTER TABLE ONLY congiuntura_rimini.zh_ore_trim_clad_sett_compr
    ADD CONSTRAINT zh_ore_trim_clad_sett_compr_pkey PRIMARY KEY (trimestre, anno, id_comprensorio, id_cl_addetti, cod_se);


--
-- Name: zh_quest_azienda_trim zh_quest_azienda_trim_pkey; Type: CONSTRAINT; Schema: congiuntura_rimini; Owner: -
--

ALTER TABLE ONLY congiuntura_rimini.zh_quest_azienda_trim
    ADD CONSTRAINT zh_quest_azienda_trim_pkey PRIMARY KEY (id_azienda, trimestre, anno);


--
-- Name: alt_compr alt_compr_pkey; Type: CONSTRAINT; Schema: geografia; Owner: -
--

ALTER TABLE ONLY geografia.alt_compr
    ADD CONSTRAINT alt_compr_pkey PRIMARY KEY (id_alt_compr);


--
-- Name: altimetrie altimetrie_pkey; Type: CONSTRAINT; Schema: geografia; Owner: -
--

ALTER TABLE ONLY geografia.altimetrie
    ADD CONSTRAINT altimetrie_pkey PRIMARY KEY (id_altimetria);


--
-- Name: comprensori comprensori_pkey; Type: CONSTRAINT; Schema: geografia; Owner: -
--

ALTER TABLE ONLY geografia.comprensori
    ADD CONSTRAINT comprensori_pkey PRIMARY KEY (id_comprensorio);


--
-- Name: comuni comuni_pkey; Type: CONSTRAINT; Schema: geografia; Owner: -
--

ALTER TABLE ONLY geografia.comuni
    ADD CONSTRAINT comuni_pkey PRIMARY KEY (id_comune);


--
-- Name: comunita comunita_pkey; Type: CONSTRAINT; Schema: geografia; Owner: -
--

ALTER TABLE ONLY geografia.comunita
    ADD CONSTRAINT comunita_pkey PRIMARY KEY (id_comunita);


--
-- Name: continenti continenti_pkey; Type: CONSTRAINT; Schema: geografia; Owner: -
--

ALTER TABLE ONLY geografia.continenti
    ADD CONSTRAINT continenti_pkey PRIMARY KEY (id_continente);


--
-- Name: nazioni nazioni_pkey; Type: CONSTRAINT; Schema: geografia; Owner: -
--

ALTER TABLE ONLY geografia.nazioni
    ADD CONSTRAINT nazioni_pkey PRIMARY KEY (id_nazione);


--
-- Name: province province_pkey; Type: CONSTRAINT; Schema: geografia; Owner: -
--

ALTER TABLE ONLY geografia.province
    ADD CONSTRAINT province_pkey PRIMARY KEY (id_provincia);


--
-- Name: regioni regioni_pkey; Type: CONSTRAINT; Schema: geografia; Owner: -
--

ALTER TABLE ONLY geografia.regioni
    ADD CONSTRAINT regioni_pkey PRIMARY KEY (id_regione);


--
-- Name: unioni unioni_pkey; Type: CONSTRAINT; Schema: geografia; Owner: -
--

ALTER TABLE ONLY geografia.unioni
    ADD CONSTRAINT unioni_pkey PRIMARY KEY (id_unione);


--
-- Name: vallate vallate_pkey; Type: CONSTRAINT; Schema: geografia; Owner: -
--

ALTER TABLE ONLY geografia.vallate
    ADD CONSTRAINT vallate_pkey PRIMARY KEY (id_vallata);


--
-- Name: autorizzazioni autorizzazioni_pkey; Type: CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.autorizzazioni
    ADD CONSTRAINT autorizzazioni_pkey PRIMARY KEY (id_autorizzazione);


--
-- Name: bisogni bisogni_pkey; Type: CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.bisogni
    ADD CONSTRAINT bisogni_pkey PRIMARY KEY (id_bisogno);


--
-- Name: cc_argomenti cc_argomenti_pkey; Type: CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.cc_argomenti
    ADD CONSTRAINT cc_argomenti_pkey PRIMARY KEY (id_cc_argomento);


--
-- Name: cc_download_quesiti_risposte cc_download_quesiti_risposte_pkey; Type: CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.cc_download_quesiti_risposte
    ADD CONSTRAINT cc_download_quesiti_risposte_pkey PRIMARY KEY (id_download_cc);


--
-- Name: cc_quesiti cc_quesiti_pkey; Type: CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.cc_quesiti
    ADD CONSTRAINT cc_quesiti_pkey PRIMARY KEY (id_quesito);


--
-- Name: cc_risposte cc_risposte_pkey; Type: CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.cc_risposte
    ADD CONSTRAINT cc_risposte_pkey PRIMARY KEY (id_risposta);


--
-- Name: cc_stati_quesito cc_stati_quesito_pkey; Type: CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.cc_stati_quesito
    ADD CONSTRAINT cc_stati_quesito_pkey PRIMARY KEY (id_stato);


--
-- Name: documenti_web documenti_web_pkey; Type: CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.documenti_web
    ADD CONSTRAINT documenti_web_pkey PRIMARY KEY (id_documento_web);


--
-- Name: email_punti email_punti_pkey; Type: CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.email_punti
    ADD CONSTRAINT email_punti_pkey PRIMARY KEY (id_email_punto);


--
-- Name: email_web email_web_pkey; Type: CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.email_web
    ADD CONSTRAINT email_web_pkey PRIMARY KEY (id_email_web);


--
-- Name: enti enti_pkey; Type: CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.enti
    ADD CONSTRAINT enti_pkey PRIMARY KEY (id_ente);


--
-- Name: immagini immagini_pkey; Type: CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.immagini
    ADD CONSTRAINT immagini_pkey PRIMARY KEY (id_immagine);


--
-- Name: luoghi luoghi_pkey; Type: CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.luoghi
    ADD CONSTRAINT luoghi_pkey PRIMARY KEY (id_luogo);


--
-- Name: nl_numeri nl_numeri_id_nl_tipo_data_unique; Type: CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.nl_numeri
    ADD CONSTRAINT nl_numeri_id_nl_tipo_data_unique UNIQUE (id_nl_tipo, data);


--
-- Name: nl_numeri nl_numeri_pkey; Type: CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.nl_numeri
    ADD CONSTRAINT nl_numeri_pkey PRIMARY KEY (id_nl_numero);


--
-- Name: nl_pubblicazioni nl_pubblicazioni_pkey; Type: CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.nl_pubblicazioni
    ADD CONSTRAINT nl_pubblicazioni_pkey PRIMARY KEY (id_nl_pubblicazione);


--
-- Name: nl_sezioni nl_sezioni_pkey; Type: CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.nl_sezioni
    ADD CONSTRAINT nl_sezioni_pkey PRIMARY KEY (id_nl_tipo, nome);


--
-- Name: nl_tipi nl_tipi_pkey; Type: CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.nl_tipi
    ADD CONSTRAINT nl_tipi_pkey PRIMARY KEY (id_nl_tipo);


--
-- Name: pagamenti_online pagamenti_online_pkey; Type: CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.pagamenti_online
    ADD CONSTRAINT pagamenti_online_pkey PRIMARY KEY (merchantorderid);


--
-- Name: paragrafi paragrafi_pkey; Type: CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.paragrafi
    ADD CONSTRAINT paragrafi_pkey PRIMARY KEY (id_paragrafo);


--
-- Name: punti_programma punti_programma_pkey; Type: CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.punti_programma
    ADD CONSTRAINT punti_programma_pkey PRIMARY KEY (id_punto);


--
-- Name: rel_documenti_web_bisogni rel_documenti_web_bisogni_pkey; Type: CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.rel_documenti_web_bisogni
    ADD CONSTRAINT rel_documenti_web_bisogni_pkey PRIMARY KEY (id_documento_web, id_bisogno);


--
-- Name: rel_documenti_web_documenti rel_documenti_web_documenti_pkey; Type: CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.rel_documenti_web_documenti
    ADD CONSTRAINT rel_documenti_web_documenti_pkey PRIMARY KEY (id_documento_web_padre, id_documento_web_figlio);


--
-- Name: rel_documenti_web_enti rel_documenti_web_enti_pkey; Type: CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.rel_documenti_web_enti
    ADD CONSTRAINT rel_documenti_web_enti_pkey PRIMARY KEY (id_documento_web, id_ente);


--
-- Name: rel_documenti_web_iscrizioni rel_documenti_web_iscrizioni_pkey; Type: CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.rel_documenti_web_iscrizioni
    ADD CONSTRAINT rel_documenti_web_iscrizioni_pkey PRIMARY KEY (id_iscrizione);


--
-- Name: rel_tipi_documento_web rel_tipi_documento_web_pkey; Type: CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.rel_tipi_documento_web
    ADD CONSTRAINT rel_tipi_documento_web_pkey PRIMARY KEY (id_tipo_documento_web_padre, id_tipo_documento_web_figlio);


--
-- Name: rel_utenti_autorizzazioni rel_utenti_autorizzazioni_pkey; Type: CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.rel_utenti_autorizzazioni
    ADD CONSTRAINT rel_utenti_autorizzazioni_pkey PRIMARY KEY (id_utente, id_autorizzazione);


--
-- Name: rel_utenti_tematiche_nl rel_utenti_tematiche_nl_pkey; Type: CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.rel_utenti_tematiche_nl
    ADD CONSTRAINT rel_utenti_tematiche_nl_pkey PRIMARY KEY (id_utente, id_tematica);


--
-- Name: tematiche_nl tematiche_nl_pkey; Type: CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.tematiche_nl
    ADD CONSTRAINT tematiche_nl_pkey PRIMARY KEY (id_tematica);


--
-- Name: tipi_collaborazione tipi_collaborazione_pkey; Type: CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.tipi_collaborazione
    ADD CONSTRAINT tipi_collaborazione_pkey PRIMARY KEY (id_tipo_collaborazione);


--
-- Name: tipi_documento_web tipi_documento_web_pkey; Type: CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.tipi_documento_web
    ADD CONSTRAINT tipi_documento_web_pkey PRIMARY KEY (id_tipo_documento_web);


--
-- Name: tipi_sistema tipi_sistema_pkey; Type: CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.tipi_sistema
    ADD CONSTRAINT tipi_sistema_pkey PRIMARY KEY (id_tipo_sistema);


--
-- Name: utenti_nl utenti_nl_email_unique; Type: CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.utenti_nl
    ADD CONSTRAINT utenti_nl_email_unique UNIQUE (email);


--
-- Name: utenti_nl utenti_nl_pkey; Type: CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.utenti_nl
    ADD CONSTRAINT utenti_nl_pkey PRIMARY KEY (id_utente);


--
-- Name: utenti utenti_pkey; Type: CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.utenti
    ADD CONSTRAINT utenti_pkey PRIMARY KEY (id_utente);


--
-- Name: utenti utenti_username_unique; Type: CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.utenti
    ADD CONSTRAINT utenti_username_unique UNIQUE (username);


--
-- Name: documenti_web documenti_web_pkey; Type: CONSTRAINT; Schema: portalowner_old; Owner: -
--

ALTER TABLE ONLY portalowner_old.documenti_web
    ADD CONSTRAINT documenti_web_pkey PRIMARY KEY (id_documento_web);


--
-- Name: paragrafi paragrafi_pkey; Type: CONSTRAINT; Schema: portalowner_old; Owner: -
--

ALTER TABLE ONLY portalowner_old.paragrafi
    ADD CONSTRAINT paragrafi_pkey PRIMARY KEY (id_paragrafo);


--
-- Name: rel_documenti_web_documenti rel_documenti_web_documenti_pkey; Type: CONSTRAINT; Schema: portalowner_old; Owner: -
--

ALTER TABLE ONLY portalowner_old.rel_documenti_web_documenti
    ADD CONSTRAINT rel_documenti_web_documenti_pkey PRIMARY KEY (id_documento_web_padre, id_documento_web_figlio);


--
-- Name: categorie categorie_pkey; Type: CONSTRAINT; Schema: prezzi; Owner: -
--

ALTER TABLE ONLY prezzi.categorie
    ADD CONSTRAINT categorie_pkey PRIMARY KEY (id_categoria);


--
-- Name: informatori informatori_pkey; Type: CONSTRAINT; Schema: prezzi; Owner: -
--

ALTER TABLE ONLY prezzi.informatori
    ADD CONSTRAINT informatori_pkey PRIMARY KEY (id_informatore);


--
-- Name: listini listini_pkey; Type: CONSTRAINT; Schema: prezzi; Owner: -
--

ALTER TABLE ONLY prezzi.listini
    ADD CONSTRAINT listini_pkey PRIMARY KEY (id_listino);


--
-- Name: prodotti prodotti_pkey; Type: CONSTRAINT; Schema: prezzi; Owner: -
--

ALTER TABLE ONLY prezzi.prodotti
    ADD CONSTRAINT prodotti_pkey PRIMARY KEY (id_prodotto);


--
-- Name: quotazioni quotazioni_pkey; Type: CONSTRAINT; Schema: prezzi; Owner: -
--

ALTER TABLE ONLY prezzi.quotazioni
    ADD CONSTRAINT quotazioni_pkey PRIMARY KEY (id_listino, id_informatore, id_prodotto);


--
-- Name: rel_informatori_categorie rel_informatori_categorie_pkey; Type: CONSTRAINT; Schema: prezzi; Owner: -
--

ALTER TABLE ONLY prezzi.rel_informatori_categorie
    ADD CONSTRAINT rel_informatori_categorie_pkey PRIMARY KEY (id_informatore, id_categoria);


--
-- Name: tendenze tendenze_pkey; Type: CONSTRAINT; Schema: prezzi; Owner: -
--

ALTER TABLE ONLY prezzi.tendenze
    ADD CONSTRAINT tendenze_pkey PRIMARY KEY (id_listino, id_categoria);


--
-- Name: tipi_listino tipi_listino_pkey; Type: CONSTRAINT; Schema: prezzi; Owner: -
--

ALTER TABLE ONLY prezzi.tipi_listino
    ADD CONSTRAINT tipi_listino_pkey PRIMARY KEY (id_tipo_listino);


--
-- Name: fki_indicatori_ic_tipo_dato_fkey; Type: INDEX; Schema: congiuntura; Owner: -
--

CREATE INDEX fki_indicatori_ic_tipo_dato_fkey ON congiuntura.indicatori_ic USING btree (tipo_dato);


--
-- Name: fki_indicatori_ins_tipo_dato_fkey; Type: INDEX; Schema: congiuntura; Owner: -
--

CREATE INDEX fki_indicatori_ins_tipo_dato_fkey ON congiuntura.indicatori_ins USING btree (tipo_dato);


--
-- Name: listini_precedenti _RETURN; Type: RULE; Schema: prezzi; Owner: -
--

CREATE OR REPLACE VIEW prezzi.listini_precedenti AS
 SELECT l.id_listino,
    l.nome,
    l.descrizione,
    l.note,
    l.data_pubbl,
    l.id_tipo_listino,
    l.id_documento_web,
    l.data_inserimento,
    l.num,
    l.data_validazione,
    l.validato,
    l.pubblicato,
    max(l2.id_listino) AS id_listino_precedente
   FROM (prezzi.listini l
     LEFT JOIN prezzi.listini l2 ON (((l.id_tipo_listino = l2.id_tipo_listino) AND (l2.data_pubbl < l.data_pubbl))))
  GROUP BY l.id_listino;


--
-- Name: annotazioni annotazioni_cod_sportello_fkey; Type: FK CONSTRAINT; Schema: appuntamenti; Owner: -
--

ALTER TABLE ONLY appuntamenti.annotazioni
    ADD CONSTRAINT annotazioni_cod_sportello_fkey FOREIGN KEY (cod_sportello) REFERENCES appuntamenti.sportelli(cod_sportello);


--
-- Name: appuntamenti appuntamenti_cod_sportello_fkey; Type: FK CONSTRAINT; Schema: appuntamenti; Owner: -
--

ALTER TABLE ONLY appuntamenti.appuntamenti
    ADD CONSTRAINT appuntamenti_cod_sportello_fkey FOREIGN KEY (cod_sportello) REFERENCES appuntamenti.sportelli(cod_sportello);


--
-- Name: appuntamenti appuntamenti_id_intermediario_fkey; Type: FK CONSTRAINT; Schema: appuntamenti; Owner: -
--

ALTER TABLE ONLY appuntamenti.appuntamenti
    ADD CONSTRAINT appuntamenti_id_intermediario_fkey FOREIGN KEY (id_intermediario) REFERENCES appuntamenti.intermediari(id_intermediario);


--
-- Name: appuntamenti appuntamenti_id_servizio_fkey; Type: FK CONSTRAINT; Schema: appuntamenti; Owner: -
--

ALTER TABLE ONLY appuntamenti.appuntamenti
    ADD CONSTRAINT appuntamenti_id_servizio_fkey FOREIGN KEY (id_servizio) REFERENCES appuntamenti.servizi(id_servizio);


--
-- Name: appuntamenti appuntamenti_id_utente_fkey; Type: FK CONSTRAINT; Schema: appuntamenti; Owner: -
--

ALTER TABLE ONLY appuntamenti.appuntamenti
    ADD CONSTRAINT appuntamenti_id_utente_fkey FOREIGN KEY (id_utente) REFERENCES portalowner2.utenti(id_utente);


--
-- Name: fasce_apertura fasce_apertura_cod_sportello_fkey; Type: FK CONSTRAINT; Schema: appuntamenti; Owner: -
--

ALTER TABLE ONLY appuntamenti.fasce_apertura
    ADD CONSTRAINT fasce_apertura_cod_sportello_fkey FOREIGN KEY (cod_sportello) REFERENCES appuntamenti.sportelli(cod_sportello);


--
-- Name: pratiche pratica_id_appuntamento_fkey; Type: FK CONSTRAINT; Schema: appuntamenti; Owner: -
--

ALTER TABLE ONLY appuntamenti.pratiche
    ADD CONSTRAINT pratica_id_appuntamento_fkey FOREIGN KEY (id_appuntamento) REFERENCES appuntamenti.appuntamenti(id_appuntamento) ON DELETE CASCADE;


--
-- Name: pratiche pratiche_id_servizio_fkey; Type: FK CONSTRAINT; Schema: appuntamenti; Owner: -
--

ALTER TABLE ONLY appuntamenti.pratiche
    ADD CONSTRAINT pratiche_id_servizio_fkey FOREIGN KEY (id_servizio) REFERENCES appuntamenti.servizi(id_servizio);


--
-- Name: rel_sportelli_servizi rel_sportelli_servizi_cod_sportello_fkey; Type: FK CONSTRAINT; Schema: appuntamenti; Owner: -
--

ALTER TABLE ONLY appuntamenti.rel_sportelli_servizi
    ADD CONSTRAINT rel_sportelli_servizi_cod_sportello_fkey FOREIGN KEY (cod_sportello) REFERENCES appuntamenti.sportelli(cod_sportello);


--
-- Name: rel_sportelli_servizi rel_sportelli_servizi_id_servizio_fkey; Type: FK CONSTRAINT; Schema: appuntamenti; Owner: -
--

ALTER TABLE ONLY appuntamenti.rel_sportelli_servizi
    ADD CONSTRAINT rel_sportelli_servizi_id_servizio_fkey FOREIGN KEY (id_servizio) REFERENCES appuntamenti.servizi(id_servizio);


--
-- Name: aziende_cong aziende_cong_id_comune_fkey; Type: FK CONSTRAINT; Schema: congiuntura; Owner: -
--

ALTER TABLE ONLY congiuntura.aziende_cong
    ADD CONSTRAINT aziende_cong_id_comune_fkey FOREIGN KEY (id_comune) REFERENCES geografia.comuni(id_comune);


--
-- Name: aziende_cong aziende_cong_id_padre_fkey; Type: FK CONSTRAINT; Schema: congiuntura; Owner: -
--

ALTER TABLE ONLY congiuntura.aziende_cong
    ADD CONSTRAINT aziende_cong_id_padre_fkey FOREIGN KEY (id_padre) REFERENCES congiuntura.aziende_cong(id_azienda);


--
-- Name: aziende_cong aziende_cong_id_provincia_fkey; Type: FK CONSTRAINT; Schema: congiuntura; Owner: -
--

ALTER TABLE ONLY congiuntura.aziende_cong
    ADD CONSTRAINT aziende_cong_id_provincia_fkey FOREIGN KEY (id_provincia) REFERENCES geografia.province(id_provincia);


--
-- Name: contatti contatti_id_azienda_fkey; Type: FK CONSTRAINT; Schema: congiuntura; Owner: -
--

ALTER TABLE ONLY congiuntura.contatti
    ADD CONSTRAINT contatti_id_azienda_fkey FOREIGN KEY (id_azienda) REFERENCES congiuntura.aziende_cong(id_azienda);


--
-- Name: dim_universo dim_universo_cod_se_fkey; Type: FK CONSTRAINT; Schema: congiuntura; Owner: -
--

ALTER TABLE ONLY congiuntura.dim_universo
    ADD CONSTRAINT dim_universo_cod_se_fkey FOREIGN KEY (cod_se) REFERENCES congiuntura.settori_cong(cod_se);


--
-- Name: dim_universo dim_universo_id_cl_addetti_fkey; Type: FK CONSTRAINT; Schema: congiuntura; Owner: -
--

ALTER TABLE ONLY congiuntura.dim_universo
    ADD CONSTRAINT dim_universo_id_cl_addetti_fkey FOREIGN KEY (id_cl_addetti) REFERENCES congiuntura.cl_addetti_cong(id_cl_addetti);


--
-- Name: dim_universo dim_universo_id_comprensorio_fkey; Type: FK CONSTRAINT; Schema: congiuntura; Owner: -
--

ALTER TABLE ONLY congiuntura.dim_universo
    ADD CONSTRAINT dim_universo_id_comprensorio_fkey FOREIGN KEY (id_comprensorio) REFERENCES geografia.comprensori(id_comprensorio);


--
-- Name: fatturato fatturato_id_azienda_fkey; Type: FK CONSTRAINT; Schema: congiuntura; Owner: -
--

ALTER TABLE ONLY congiuntura.fatturato
    ADD CONSTRAINT fatturato_id_azienda_fkey FOREIGN KEY (id_azienda) REFERENCES congiuntura.aziende_cong(id_azienda);


--
-- Name: h_dim_universo h_dim_universo_cod_se_fkey; Type: FK CONSTRAINT; Schema: congiuntura; Owner: -
--

ALTER TABLE ONLY congiuntura.h_dim_universo
    ADD CONSTRAINT h_dim_universo_cod_se_fkey FOREIGN KEY (cod_se) REFERENCES congiuntura.settori_cong(cod_se);


--
-- Name: h_dim_universo h_dim_universo_id_cl_addetti_fkey; Type: FK CONSTRAINT; Schema: congiuntura; Owner: -
--

ALTER TABLE ONLY congiuntura.h_dim_universo
    ADD CONSTRAINT h_dim_universo_id_cl_addetti_fkey FOREIGN KEY (id_cl_addetti) REFERENCES congiuntura.cl_addetti_cong(id_cl_addetti);


--
-- Name: h_dim_universo h_dim_universo_id_comprensorio_fkey; Type: FK CONSTRAINT; Schema: congiuntura; Owner: -
--

ALTER TABLE ONLY congiuntura.h_dim_universo
    ADD CONSTRAINT h_dim_universo_id_comprensorio_fkey FOREIGN KEY (id_comprensorio) REFERENCES geografia.comprensori(id_comprensorio);


--
-- Name: indicatori_ic indicatori_ic_tipo_dato_fkey; Type: FK CONSTRAINT; Schema: congiuntura; Owner: -
--

ALTER TABLE ONLY congiuntura.indicatori_ic
    ADD CONSTRAINT indicatori_ic_tipo_dato_fkey FOREIGN KEY (tipo_dato) REFERENCES congiuntura.tipi_dato(sigla);


--
-- Name: indicatori_ins indicatori_ins_id_argomento_fkey; Type: FK CONSTRAINT; Schema: congiuntura; Owner: -
--

ALTER TABLE ONLY congiuntura.indicatori_ins
    ADD CONSTRAINT indicatori_ins_id_argomento_fkey FOREIGN KEY (id_argomento) REFERENCES congiuntura.argomenti(id_argomento);


--
-- Name: indicatori_ins indicatori_ins_tipo_dato_fkey; Type: FK CONSTRAINT; Schema: congiuntura; Owner: -
--

ALTER TABLE ONLY congiuntura.indicatori_ins
    ADD CONSTRAINT indicatori_ins_tipo_dato_fkey FOREIGN KEY (tipo_dato) REFERENCES congiuntura.tipi_dato(sigla);


--
-- Name: rel_indicatori_ins_u_misura rel_indicatori_ins_u_misura_id_indicatore_fkey; Type: FK CONSTRAINT; Schema: congiuntura; Owner: -
--

ALTER TABLE ONLY congiuntura.rel_indicatori_ins_u_misura
    ADD CONSTRAINT rel_indicatori_ins_u_misura_id_indicatore_fkey FOREIGN KEY (id_indicatore) REFERENCES congiuntura.indicatori_ins(id_indicatore);


--
-- Name: rel_indicatori_ins_u_misura rel_indicatori_ins_u_misura_id_u_misura_fkey; Type: FK CONSTRAINT; Schema: congiuntura; Owner: -
--

ALTER TABLE ONLY congiuntura.rel_indicatori_ins_u_misura
    ADD CONSTRAINT rel_indicatori_ins_u_misura_id_u_misura_fkey FOREIGN KEY (id_u_misura) REFERENCES congiuntura.u_misura(id_u_misura);


--
-- Name: risposte risposte_id_azienda_data_fkey; Type: FK CONSTRAINT; Schema: congiuntura; Owner: -
--

ALTER TABLE ONLY congiuntura.risposte
    ADD CONSTRAINT risposte_id_azienda_data_fkey FOREIGN KEY (id_azienda, data) REFERENCES congiuntura.questionari(id_azienda, data);


--
-- Name: risposte risposte_id_indicatore_fkey; Type: FK CONSTRAINT; Schema: congiuntura; Owner: -
--

ALTER TABLE ONLY congiuntura.risposte
    ADD CONSTRAINT risposte_id_indicatore_fkey FOREIGN KEY (id_indicatore) REFERENCES congiuntura.indicatori_ins(id_indicatore);


--
-- Name: settori_di_analisi settori_di_analisi_id_azienda_fkey; Type: FK CONSTRAINT; Schema: congiuntura; Owner: -
--

ALTER TABLE ONLY congiuntura.settori_di_analisi
    ADD CONSTRAINT settori_di_analisi_id_azienda_fkey FOREIGN KEY (id_azienda) REFERENCES congiuntura.aziende_cong(id_azienda);


--
-- Name: u_misura u_misura_id_tipo_num_fkey; Type: FK CONSTRAINT; Schema: congiuntura; Owner: -
--

ALTER TABLE ONLY congiuntura.u_misura
    ADD CONSTRAINT u_misura_id_tipo_num_fkey FOREIGN KEY (id_tipo_num) REFERENCES congiuntura.tipi_num(id_tipo_num);


--
-- Name: dim_universo dim_universo_cod_se_fkey; Type: FK CONSTRAINT; Schema: congiuntura_rimini; Owner: -
--

ALTER TABLE ONLY congiuntura_rimini.dim_universo
    ADD CONSTRAINT dim_universo_cod_se_fkey FOREIGN KEY (cod_se) REFERENCES congiuntura_rimini.settori_cong(cod_se);


--
-- Name: dim_universo dim_universo_id_cl_addetti_fkey; Type: FK CONSTRAINT; Schema: congiuntura_rimini; Owner: -
--

ALTER TABLE ONLY congiuntura_rimini.dim_universo
    ADD CONSTRAINT dim_universo_id_cl_addetti_fkey FOREIGN KEY (id_cl_addetti) REFERENCES congiuntura.cl_addetti_cong(id_cl_addetti);


--
-- Name: dim_universo dim_universo_id_comprensorio_fkey; Type: FK CONSTRAINT; Schema: congiuntura_rimini; Owner: -
--

ALTER TABLE ONLY congiuntura_rimini.dim_universo
    ADD CONSTRAINT dim_universo_id_comprensorio_fkey FOREIGN KEY (id_comprensorio) REFERENCES geografia.comprensori(id_comprensorio);


--
-- Name: h_dim_universo h_dim_universo_cod_se_fkey; Type: FK CONSTRAINT; Schema: congiuntura_rimini; Owner: -
--

ALTER TABLE ONLY congiuntura_rimini.h_dim_universo
    ADD CONSTRAINT h_dim_universo_cod_se_fkey FOREIGN KEY (cod_se) REFERENCES congiuntura_rimini.settori_cong(cod_se);


--
-- Name: h_dim_universo h_dim_universo_id_cl_addetti_fkey; Type: FK CONSTRAINT; Schema: congiuntura_rimini; Owner: -
--

ALTER TABLE ONLY congiuntura_rimini.h_dim_universo
    ADD CONSTRAINT h_dim_universo_id_cl_addetti_fkey FOREIGN KEY (id_cl_addetti) REFERENCES congiuntura.cl_addetti_cong(id_cl_addetti);


--
-- Name: h_dim_universo h_dim_universo_id_comprensorio_fkey; Type: FK CONSTRAINT; Schema: congiuntura_rimini; Owner: -
--

ALTER TABLE ONLY congiuntura_rimini.h_dim_universo
    ADD CONSTRAINT h_dim_universo_id_comprensorio_fkey FOREIGN KEY (id_comprensorio) REFERENCES geografia.comprensori(id_comprensorio);


--
-- Name: alt_compr alt_compr_id_altimetria_fkey; Type: FK CONSTRAINT; Schema: geografia; Owner: -
--

ALTER TABLE ONLY geografia.alt_compr
    ADD CONSTRAINT alt_compr_id_altimetria_fkey FOREIGN KEY (id_altimetria) REFERENCES geografia.altimetrie(id_altimetria);


--
-- Name: alt_compr alt_compr_id_comprensorio_fkey; Type: FK CONSTRAINT; Schema: geografia; Owner: -
--

ALTER TABLE ONLY geografia.alt_compr
    ADD CONSTRAINT alt_compr_id_comprensorio_fkey FOREIGN KEY (id_comprensorio) REFERENCES geografia.comprensori(id_comprensorio);


--
-- Name: comuni comuni_id_alt_compr_fkey; Type: FK CONSTRAINT; Schema: geografia; Owner: -
--

ALTER TABLE ONLY geografia.comuni
    ADD CONSTRAINT comuni_id_alt_compr_fkey FOREIGN KEY (id_alt_compr) REFERENCES geografia.alt_compr(id_alt_compr);


--
-- Name: comuni comuni_id_comunita_fkey; Type: FK CONSTRAINT; Schema: geografia; Owner: -
--

ALTER TABLE ONLY geografia.comuni
    ADD CONSTRAINT comuni_id_comunita_fkey FOREIGN KEY (id_comunita) REFERENCES geografia.comunita(id_comunita);


--
-- Name: comuni comuni_id_provincia_fkey; Type: FK CONSTRAINT; Schema: geografia; Owner: -
--

ALTER TABLE ONLY geografia.comuni
    ADD CONSTRAINT comuni_id_provincia_fkey FOREIGN KEY (id_provincia) REFERENCES geografia.province(id_provincia);


--
-- Name: comuni comuni_id_vallata_fkey; Type: FK CONSTRAINT; Schema: geografia; Owner: -
--

ALTER TABLE ONLY geografia.comuni
    ADD CONSTRAINT comuni_id_vallata_fkey FOREIGN KEY (id_vallata) REFERENCES geografia.vallate(id_vallata);


--
-- Name: nazioni nazioni_id_continente_fkey; Type: FK CONSTRAINT; Schema: geografia; Owner: -
--

ALTER TABLE ONLY geografia.nazioni
    ADD CONSTRAINT nazioni_id_continente_fkey FOREIGN KEY (id_continente) REFERENCES geografia.continenti(id_continente);


--
-- Name: province province_id_regione_fkey; Type: FK CONSTRAINT; Schema: geografia; Owner: -
--

ALTER TABLE ONLY geografia.province
    ADD CONSTRAINT province_id_regione_fkey FOREIGN KEY (id_regione) REFERENCES geografia.regioni(id_regione);


--
-- Name: regioni regioni_id_nazione_fkey; Type: FK CONSTRAINT; Schema: geografia; Owner: -
--

ALTER TABLE ONLY geografia.regioni
    ADD CONSTRAINT regioni_id_nazione_fkey FOREIGN KEY (id_nazione) REFERENCES geografia.nazioni(id_nazione);


--
-- Name: bisogni bisogni_id_bisogno_padre_fkey; Type: FK CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.bisogni
    ADD CONSTRAINT bisogni_id_bisogno_padre_fkey FOREIGN KEY (id_bisogno_padre) REFERENCES portalowner2.bisogni(id_bisogno);


--
-- Name: cc_download_quesiti_risposte cc_download_quesiti_risposte_id_quesito_fkey; Type: FK CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.cc_download_quesiti_risposte
    ADD CONSTRAINT cc_download_quesiti_risposte_id_quesito_fkey FOREIGN KEY (id_quesito) REFERENCES portalowner2.cc_quesiti(id_quesito);


--
-- Name: cc_download_quesiti_risposte cc_download_quesiti_risposte_id_risposta_fkey; Type: FK CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.cc_download_quesiti_risposte
    ADD CONSTRAINT cc_download_quesiti_risposte_id_risposta_fkey FOREIGN KEY (id_risposta) REFERENCES portalowner2.cc_risposte(id_risposta);


--
-- Name: cc_quesiti cc_quesiti_id_amministratore_fkey; Type: FK CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.cc_quesiti
    ADD CONSTRAINT cc_quesiti_id_amministratore_fkey FOREIGN KEY (id_amministratore) REFERENCES portalowner2.utenti(id_utente);


--
-- Name: cc_quesiti cc_quesiti_id_cc_argomento_fkey; Type: FK CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.cc_quesiti
    ADD CONSTRAINT cc_quesiti_id_cc_argomento_fkey FOREIGN KEY (id_cc_argomento) REFERENCES portalowner2.cc_argomenti(id_cc_argomento);


--
-- Name: cc_quesiti cc_quesiti_id_operatore_fkey; Type: FK CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.cc_quesiti
    ADD CONSTRAINT cc_quesiti_id_operatore_fkey FOREIGN KEY (id_operatore) REFERENCES portalowner2.utenti(id_utente);


--
-- Name: cc_quesiti cc_quesiti_id_stato_fkey; Type: FK CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.cc_quesiti
    ADD CONSTRAINT cc_quesiti_id_stato_fkey FOREIGN KEY (id_stato) REFERENCES portalowner2.cc_stati_quesito(id_stato);


--
-- Name: cc_quesiti cc_quesiti_id_user_smistatore_fkey; Type: FK CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.cc_quesiti
    ADD CONSTRAINT cc_quesiti_id_user_smistatore_fkey FOREIGN KEY (id_user_smistatore) REFERENCES portalowner2.utenti(id_utente);


--
-- Name: cc_quesiti cc_quesiti_id_utente_fkey; Type: FK CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.cc_quesiti
    ADD CONSTRAINT cc_quesiti_id_utente_fkey FOREIGN KEY (id_utente) REFERENCES portalowner2.utenti_nl(id_utente);


--
-- Name: cc_risposte cc_risposte_id_quesito_fkey; Type: FK CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.cc_risposte
    ADD CONSTRAINT cc_risposte_id_quesito_fkey FOREIGN KEY (id_quesito) REFERENCES portalowner2.cc_quesiti(id_quesito);


--
-- Name: documenti_web documenti_web_id_luogo; Type: FK CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.documenti_web
    ADD CONSTRAINT documenti_web_id_luogo FOREIGN KEY (id_luogo) REFERENCES portalowner2.luoghi(id_luogo);


--
-- Name: documenti_web documenti_web_id_proprietario; Type: FK CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.documenti_web
    ADD CONSTRAINT documenti_web_id_proprietario FOREIGN KEY (id_proprietario) REFERENCES portalowner2.utenti(id_utente);


--
-- Name: documenti_web documenti_web_id_tipo_documento_web_fkey; Type: FK CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.documenti_web
    ADD CONSTRAINT documenti_web_id_tipo_documento_web_fkey FOREIGN KEY (id_tipo_documento_web) REFERENCES portalowner2.tipi_documento_web(id_tipo_documento_web);


--
-- Name: documenti_web documenti_web_id_tipo_sistema_fkey; Type: FK CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.documenti_web
    ADD CONSTRAINT documenti_web_id_tipo_sistema_fkey FOREIGN KEY (id_tipo_sistema) REFERENCES portalowner2.tipi_sistema(id_tipo_sistema);


--
-- Name: email_punti email_punti_id_email_web_fkey; Type: FK CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.email_punti
    ADD CONSTRAINT email_punti_id_email_web_fkey FOREIGN KEY (id_email_web) REFERENCES portalowner2.email_web(id_email_web);


--
-- Name: email_web email_web_id_documento_web_fkey; Type: FK CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.email_web
    ADD CONSTRAINT email_web_id_documento_web_fkey FOREIGN KEY (id_documento_web) REFERENCES portalowner2.documenti_web(id_documento_web);


--
-- Name: email_web email_web_id_proprietario; Type: FK CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.email_web
    ADD CONSTRAINT email_web_id_proprietario FOREIGN KEY (id_proprietario) REFERENCES portalowner2.utenti(id_utente);


--
-- Name: immagini immagini_id_documento_web_fkey; Type: FK CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.immagini
    ADD CONSTRAINT immagini_id_documento_web_fkey FOREIGN KEY (id_documento_web) REFERENCES portalowner2.documenti_web(id_documento_web);


--
-- Name: nl_numeri nl_numeri_id_nl_tipo_fkey; Type: FK CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.nl_numeri
    ADD CONSTRAINT nl_numeri_id_nl_tipo_fkey FOREIGN KEY (id_nl_tipo) REFERENCES portalowner2.nl_tipi(id_nl_tipo);


--
-- Name: nl_pubblicazioni nl_pubblicazioni_id_documento_web_fkey; Type: FK CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.nl_pubblicazioni
    ADD CONSTRAINT nl_pubblicazioni_id_documento_web_fkey FOREIGN KEY (id_documento_web) REFERENCES portalowner2.documenti_web(id_documento_web);


--
-- Name: nl_pubblicazioni nl_pubblicazioni_id_nl_numero_fkey; Type: FK CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.nl_pubblicazioni
    ADD CONSTRAINT nl_pubblicazioni_id_nl_numero_fkey FOREIGN KEY (id_nl_numero) REFERENCES portalowner2.nl_numeri(id_nl_numero);


--
-- Name: nl_pubblicazioni nl_pubblicazioni_id_nl_tipo_data_fkey; Type: FK CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.nl_pubblicazioni
    ADD CONSTRAINT nl_pubblicazioni_id_nl_tipo_data_fkey FOREIGN KEY (id_nl_tipo, data) REFERENCES portalowner2.nl_numeri(id_nl_tipo, data);


--
-- Name: nl_pubblicazioni nl_pubblicazioni_id_nl_tipo_fkey; Type: FK CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.nl_pubblicazioni
    ADD CONSTRAINT nl_pubblicazioni_id_nl_tipo_fkey FOREIGN KEY (id_nl_tipo) REFERENCES portalowner2.nl_tipi(id_nl_tipo);


--
-- Name: nl_sezioni nl_sezioni_id_nl_tipo_fkey; Type: FK CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.nl_sezioni
    ADD CONSTRAINT nl_sezioni_id_nl_tipo_fkey FOREIGN KEY (id_nl_tipo) REFERENCES portalowner2.nl_tipi(id_nl_tipo);


--
-- Name: nl_tipi nl_tipi_id_id_tipo_documento_web_fkey; Type: FK CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.nl_tipi
    ADD CONSTRAINT nl_tipi_id_id_tipo_documento_web_fkey FOREIGN KEY (id_tipo_documento_web) REFERENCES portalowner2.tipi_documento_web(id_tipo_documento_web);


--
-- Name: paragrafi paragrafi_id_documento_web_fkey; Type: FK CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.paragrafi
    ADD CONSTRAINT paragrafi_id_documento_web_fkey FOREIGN KEY (id_documento_web) REFERENCES portalowner2.documenti_web(id_documento_web);


--
-- Name: punti_programma punti_programma_id_documento_web_fkey; Type: FK CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.punti_programma
    ADD CONSTRAINT punti_programma_id_documento_web_fkey FOREIGN KEY (id_documento_web) REFERENCES portalowner2.documenti_web(id_documento_web);


--
-- Name: rel_documenti_web_bisogni rel_documenti_web_bisogni_id_bisogno_fkey; Type: FK CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.rel_documenti_web_bisogni
    ADD CONSTRAINT rel_documenti_web_bisogni_id_bisogno_fkey FOREIGN KEY (id_bisogno) REFERENCES portalowner2.bisogni(id_bisogno);


--
-- Name: rel_documenti_web_bisogni rel_documenti_web_bisogni_id_documento_web_fkey; Type: FK CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.rel_documenti_web_bisogni
    ADD CONSTRAINT rel_documenti_web_bisogni_id_documento_web_fkey FOREIGN KEY (id_documento_web) REFERENCES portalowner2.documenti_web(id_documento_web);


--
-- Name: rel_documenti_web_documenti rel_documenti_web_documenti_id_documento_web_figlio_fkey; Type: FK CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.rel_documenti_web_documenti
    ADD CONSTRAINT rel_documenti_web_documenti_id_documento_web_figlio_fkey FOREIGN KEY (id_documento_web_figlio) REFERENCES portalowner2.documenti_web(id_documento_web);


--
-- Name: rel_documenti_web_documenti rel_documenti_web_documenti_id_documento_web_padre_fkey; Type: FK CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.rel_documenti_web_documenti
    ADD CONSTRAINT rel_documenti_web_documenti_id_documento_web_padre_fkey FOREIGN KEY (id_documento_web_padre) REFERENCES portalowner2.documenti_web(id_documento_web);


--
-- Name: rel_documenti_web_enti rel_documenti_web_enti_id_documento_web_fkey; Type: FK CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.rel_documenti_web_enti
    ADD CONSTRAINT rel_documenti_web_enti_id_documento_web_fkey FOREIGN KEY (id_documento_web) REFERENCES portalowner2.documenti_web(id_documento_web);


--
-- Name: rel_documenti_web_enti rel_documenti_web_enti_id_ente_fkey; Type: FK CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.rel_documenti_web_enti
    ADD CONSTRAINT rel_documenti_web_enti_id_ente_fkey FOREIGN KEY (id_ente) REFERENCES portalowner2.enti(id_ente);


--
-- Name: rel_documenti_web_enti rel_documenti_web_enti_id_tipo_collaborazione_fkey; Type: FK CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.rel_documenti_web_enti
    ADD CONSTRAINT rel_documenti_web_enti_id_tipo_collaborazione_fkey FOREIGN KEY (id_tipo_collaborazione) REFERENCES portalowner2.tipi_collaborazione(id_tipo_collaborazione);


--
-- Name: rel_documenti_web_iscrizioni rel_documenti_web_iscrizioni_id_documento_web_fkey; Type: FK CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.rel_documenti_web_iscrizioni
    ADD CONSTRAINT rel_documenti_web_iscrizioni_id_documento_web_fkey FOREIGN KEY (id_documento_web) REFERENCES portalowner2.documenti_web(id_documento_web);


--
-- Name: rel_tipi_documento_web rel_tipi_documento_web_id_tipo_documento_web_figlio_fkey; Type: FK CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.rel_tipi_documento_web
    ADD CONSTRAINT rel_tipi_documento_web_id_tipo_documento_web_figlio_fkey FOREIGN KEY (id_tipo_documento_web_figlio) REFERENCES portalowner2.tipi_documento_web(id_tipo_documento_web);


--
-- Name: rel_tipi_documento_web rel_tipi_documento_web_id_tipo_documento_web_padre_fkey; Type: FK CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.rel_tipi_documento_web
    ADD CONSTRAINT rel_tipi_documento_web_id_tipo_documento_web_padre_fkey FOREIGN KEY (id_tipo_documento_web_padre) REFERENCES portalowner2.tipi_documento_web(id_tipo_documento_web);


--
-- Name: rel_utenti_autorizzazioni rel_utenti_autorizzazioni_id_utente; Type: FK CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.rel_utenti_autorizzazioni
    ADD CONSTRAINT rel_utenti_autorizzazioni_id_utente FOREIGN KEY (id_utente) REFERENCES portalowner2.utenti(id_utente);


--
-- Name: rel_utenti_tematiche_nl rel_utenti_tematiche_nl_id_tematica; Type: FK CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.rel_utenti_tematiche_nl
    ADD CONSTRAINT rel_utenti_tematiche_nl_id_tematica FOREIGN KEY (id_tematica) REFERENCES portalowner2.tematiche_nl(id_tematica);


--
-- Name: rel_utenti_tematiche_nl rel_utenti_tematiche_nl_id_utente; Type: FK CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.rel_utenti_tematiche_nl
    ADD CONSTRAINT rel_utenti_tematiche_nl_id_utente FOREIGN KEY (id_utente) REFERENCES portalowner2.utenti_nl(id_utente);


--
-- Name: tipi_documento_web tipi_documento_web_id_tipo_documento_web_gruppo_fkey; Type: FK CONSTRAINT; Schema: portalowner2; Owner: -
--

ALTER TABLE ONLY portalowner2.tipi_documento_web
    ADD CONSTRAINT tipi_documento_web_id_tipo_documento_web_gruppo_fkey FOREIGN KEY (id_gruppo_admin) REFERENCES portalowner2.tipi_documento_web(id_tipo_documento_web);


--
-- Name: documenti_web documenti_web_id_luogo; Type: FK CONSTRAINT; Schema: portalowner_old; Owner: -
--

ALTER TABLE ONLY portalowner_old.documenti_web
    ADD CONSTRAINT documenti_web_id_luogo FOREIGN KEY (id_luogo) REFERENCES portalowner2.luoghi(id_luogo);


--
-- Name: documenti_web documenti_web_id_proprietario; Type: FK CONSTRAINT; Schema: portalowner_old; Owner: -
--

ALTER TABLE ONLY portalowner_old.documenti_web
    ADD CONSTRAINT documenti_web_id_proprietario FOREIGN KEY (id_proprietario) REFERENCES portalowner2.utenti(id_utente);


--
-- Name: documenti_web documenti_web_id_tipo_documento_web_fkey; Type: FK CONSTRAINT; Schema: portalowner_old; Owner: -
--

ALTER TABLE ONLY portalowner_old.documenti_web
    ADD CONSTRAINT documenti_web_id_tipo_documento_web_fkey FOREIGN KEY (id_tipo_documento_web) REFERENCES portalowner2.tipi_documento_web(id_tipo_documento_web);


--
-- Name: documenti_web documenti_web_id_tipo_sistema_fkey; Type: FK CONSTRAINT; Schema: portalowner_old; Owner: -
--

ALTER TABLE ONLY portalowner_old.documenti_web
    ADD CONSTRAINT documenti_web_id_tipo_sistema_fkey FOREIGN KEY (id_tipo_sistema) REFERENCES portalowner2.tipi_sistema(id_tipo_sistema);


--
-- Name: paragrafi paragrafi_id_documento_web_fkey; Type: FK CONSTRAINT; Schema: portalowner_old; Owner: -
--

ALTER TABLE ONLY portalowner_old.paragrafi
    ADD CONSTRAINT paragrafi_id_documento_web_fkey FOREIGN KEY (id_documento_web) REFERENCES portalowner_old.documenti_web(id_documento_web);


--
-- Name: rel_documenti_web_documenti rel_documenti_web_documenti_id_documento_web_figlio_fkey; Type: FK CONSTRAINT; Schema: portalowner_old; Owner: -
--

ALTER TABLE ONLY portalowner_old.rel_documenti_web_documenti
    ADD CONSTRAINT rel_documenti_web_documenti_id_documento_web_figlio_fkey FOREIGN KEY (id_documento_web_figlio) REFERENCES portalowner_old.documenti_web(id_documento_web);


--
-- Name: rel_documenti_web_documenti rel_documenti_web_documenti_id_documento_web_padre_fkey; Type: FK CONSTRAINT; Schema: portalowner_old; Owner: -
--

ALTER TABLE ONLY portalowner_old.rel_documenti_web_documenti
    ADD CONSTRAINT rel_documenti_web_documenti_id_documento_web_padre_fkey FOREIGN KEY (id_documento_web_padre) REFERENCES portalowner_old.documenti_web(id_documento_web);


--
-- Name: categorie categorie_id_tipo_listino_fkey; Type: FK CONSTRAINT; Schema: prezzi; Owner: -
--

ALTER TABLE ONLY prezzi.categorie
    ADD CONSTRAINT categorie_id_tipo_listino_fkey FOREIGN KEY (id_tipo_listino) REFERENCES prezzi.tipi_listino(id_tipo_listino);


--
-- Name: informatori informatori_id_commissione_fkey; Type: FK CONSTRAINT; Schema: prezzi; Owner: -
--

ALTER TABLE ONLY prezzi.informatori
    ADD CONSTRAINT informatori_id_commissione_fkey FOREIGN KEY (id_commissione) REFERENCES prezzi.informatori(id_informatore);


--
-- Name: listini listini_id_documento_web_fkey; Type: FK CONSTRAINT; Schema: prezzi; Owner: -
--

ALTER TABLE ONLY prezzi.listini
    ADD CONSTRAINT listini_id_documento_web_fkey FOREIGN KEY (id_documento_web) REFERENCES portalowner2.documenti_web(id_documento_web);


--
-- Name: listini listini_id_tipo_listino_fkey; Type: FK CONSTRAINT; Schema: prezzi; Owner: -
--

ALTER TABLE ONLY prezzi.listini
    ADD CONSTRAINT listini_id_tipo_listino_fkey FOREIGN KEY (id_tipo_listino) REFERENCES prezzi.tipi_listino(id_tipo_listino);


--
-- Name: prodotti prodotti_id_categoria_fkey; Type: FK CONSTRAINT; Schema: prezzi; Owner: -
--

ALTER TABLE ONLY prezzi.prodotti
    ADD CONSTRAINT prodotti_id_categoria_fkey FOREIGN KEY (id_categoria) REFERENCES prezzi.categorie(id_categoria);


--
-- Name: prodotti prodotti_id_prodotto_calcprezzo_fkey; Type: FK CONSTRAINT; Schema: prezzi; Owner: -
--

ALTER TABLE ONLY prezzi.prodotti
    ADD CONSTRAINT prodotti_id_prodotto_calcprezzo_fkey FOREIGN KEY (id_prodotto_calcprezzo) REFERENCES prezzi.prodotti(id_prodotto);


--
-- Name: prodotti prodotti_id_prodotto_padre_fkey; Type: FK CONSTRAINT; Schema: prezzi; Owner: -
--

ALTER TABLE ONLY prezzi.prodotti
    ADD CONSTRAINT prodotti_id_prodotto_padre_fkey FOREIGN KEY (id_prodotto_padre) REFERENCES prezzi.prodotti(id_prodotto);


--
-- Name: quotazioni quotazioni_id_informatore_fkey; Type: FK CONSTRAINT; Schema: prezzi; Owner: -
--

ALTER TABLE ONLY prezzi.quotazioni
    ADD CONSTRAINT quotazioni_id_informatore_fkey FOREIGN KEY (id_informatore) REFERENCES prezzi.informatori(id_informatore);


--
-- Name: quotazioni quotazioni_id_listino_fkey; Type: FK CONSTRAINT; Schema: prezzi; Owner: -
--

ALTER TABLE ONLY prezzi.quotazioni
    ADD CONSTRAINT quotazioni_id_listino_fkey FOREIGN KEY (id_listino) REFERENCES prezzi.listini(id_listino);


--
-- Name: quotazioni quotazioni_id_prodotto_fkey; Type: FK CONSTRAINT; Schema: prezzi; Owner: -
--

ALTER TABLE ONLY prezzi.quotazioni
    ADD CONSTRAINT quotazioni_id_prodotto_fkey FOREIGN KEY (id_prodotto) REFERENCES prezzi.prodotti(id_prodotto);


--
-- Name: quotazioni quotazioni_id_utente_ins_fkey; Type: FK CONSTRAINT; Schema: prezzi; Owner: -
--

ALTER TABLE ONLY prezzi.quotazioni
    ADD CONSTRAINT quotazioni_id_utente_ins_fkey FOREIGN KEY (id_utente_ins) REFERENCES portalowner2.utenti(id_utente);


--
-- Name: rel_informatori_categorie rel_informatori_categorie_id_categoria_fkey; Type: FK CONSTRAINT; Schema: prezzi; Owner: -
--

ALTER TABLE ONLY prezzi.rel_informatori_categorie
    ADD CONSTRAINT rel_informatori_categorie_id_categoria_fkey FOREIGN KEY (id_categoria) REFERENCES prezzi.categorie(id_categoria);


--
-- Name: rel_informatori_categorie rel_informatori_categorie_id_informatore_fkey; Type: FK CONSTRAINT; Schema: prezzi; Owner: -
--

ALTER TABLE ONLY prezzi.rel_informatori_categorie
    ADD CONSTRAINT rel_informatori_categorie_id_informatore_fkey FOREIGN KEY (id_informatore) REFERENCES prezzi.informatori(id_informatore);


--
-- Name: tendenze tendenze_id_categoria_fkey; Type: FK CONSTRAINT; Schema: prezzi; Owner: -
--

ALTER TABLE ONLY prezzi.tendenze
    ADD CONSTRAINT tendenze_id_categoria_fkey FOREIGN KEY (id_categoria) REFERENCES prezzi.categorie(id_categoria);


--
-- Name: tendenze tendenze_id_listino_fkey; Type: FK CONSTRAINT; Schema: prezzi; Owner: -
--

ALTER TABLE ONLY prezzi.tendenze
    ADD CONSTRAINT tendenze_id_listino_fkey FOREIGN KEY (id_listino) REFERENCES prezzi.listini(id_listino);


--
-- PostgreSQL database dump complete
--

